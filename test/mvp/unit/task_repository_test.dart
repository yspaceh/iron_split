import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

// ignore: subtype_of_sealed_class
class MockTaskCollectionRef extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

// ignore: subtype_of_sealed_class
class MockTaskDocRef extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

class MockWriteBatch extends Mock implements WriteBatch {}

void main() {
  late MockFirebaseFirestore mockFirestore;
  late MockTaskCollectionRef mockTaskCollection;
  late MockTaskDocRef mockTaskDoc;
  late MockTaskDocRef mockCreateDoc;
  late MockTaskDocRef mockAddMemberDoc;
  late MockWriteBatch mockBatch;
  late TaskRepository repository;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockTaskCollection = MockTaskCollectionRef();
    mockTaskDoc = MockTaskDocRef();
    mockCreateDoc = MockTaskDocRef();
    mockAddMemberDoc = MockTaskDocRef();
    mockBatch = MockWriteBatch();

    repository = TaskRepository(firestore: mockFirestore);

    when(() => mockFirestore.collection('tasks')).thenReturn(mockTaskCollection);
    when(() => mockTaskCollection.doc(any())).thenReturn(mockTaskDoc);
    when(() => mockTaskCollection.doc()).thenReturn(mockCreateDoc);
    when(() => mockTaskCollection.doc('task-add-member'))
        .thenReturn(mockAddMemberDoc);
    when(() => mockTaskDoc.update(any())).thenAnswer((_) async {});
    when(() => mockTaskDoc.set(any())).thenAnswer((_) async {});
    when(() => mockCreateDoc.set(any())).thenAnswer((_) async {});
    when(() => mockCreateDoc.id).thenReturn('task-created-1');
    when(() => mockFirestore.batch()).thenReturn(mockBatch);
    when(() => mockBatch.update(mockAddMemberDoc, any())).thenReturn(null);
    when(() => mockBatch.update(mockTaskDoc, any())).thenReturn(null);
    when(() => mockBatch.commit()).thenAnswer((_) async {});
  });

  group('TaskRepository.updateTaskStatus', () {
    test('應更新 status 與 updatedAt 到正確 task document', () async {
      await repository.updateTaskStatus('task-1', 'pending');

      final captured = verify(() => mockTaskDoc.update(captureAny())).captured;
      final updateData = Map<String, dynamic>.from(captured.single as Map);

      expect(updateData['status'], 'pending');
      expect(updateData['updatedAt'], isA<FieldValue>());

      verify(() => mockFirestore.collection('tasks')).called(1);
      verify(() => mockTaskCollection.doc('task-1')).called(1);
      verifyNoMoreInteractions(mockTaskDoc);
    });
  });

  group('TaskRepository.settleTask', () {
    test('應寫入完整 settled payload（status/finalizedAt/settlement/updatedAt）', () async {
      const settlementData = {
        'allocations': {'u1': 10.0, 'u2': -10.0},
        'memberStatus': {'u1': false, 'u2': false},
        'dashboardSnapshot': {
          'poolBalance': 100.0,
          'remainder': 0.02,
        },
      };

      await repository.settleTask(
        taskId: 'task-2',
        settlementData: settlementData,
      );

      final captured = verify(() => mockTaskDoc.update(captureAny())).captured;
      final updateData = Map<String, dynamic>.from(captured.single as Map);

      expect(updateData['status'], 'settled');
      expect(updateData['finalizedAt'], isA<FieldValue>());
      expect(updateData['updatedAt'], isA<FieldValue>());
      expect(updateData['settlement'], isA<Map<String, dynamic>>());

      final settlement =
          Map<String, dynamic>.from(updateData['settlement'] as Map);
      expect(settlement['allocations'], settlementData['allocations']);
      expect(settlement['memberStatus'], settlementData['memberStatus']);
      expect(settlement['dashboardSnapshot'], settlementData['dashboardSnapshot']);

      verify(() => mockFirestore.collection('tasks')).called(1);
      verify(() => mockTaskCollection.doc('task-2')).called(1);
      verifyNoMoreInteractions(mockTaskDoc);
    });
  });

  group('TaskRepository error mapping', () {
    test('permission-denied 應轉為 AppErrorCodes.permissionDenied', () async {
      when(() => mockTaskDoc.update(any())).thenThrow(
        FirebaseException(
          plugin: 'cloud_firestore',
          code: 'permission-denied',
        ),
      );

      await expectLater(
        () => repository.updateTaskStatus('task-3', 'ongoing'),
        throwsA(AppErrorCodes.permissionDenied),
      );

      verify(() => mockTaskCollection.doc('task-3')).called(1);
      verify(() => mockTaskDoc.update(any())).called(1);
    });
  });

  group('TaskRepository.createTask', () {
    test('應寫入建立 payload：id/status/memberIds/createdAt/updatedAt', () async {
      final taskData = <String, dynamic>{
        'name': 'Trip',
        'baseCurrency': 'USD',
        'members': {
          'u1': {'displayName': 'Captain'},
          'v1': {'displayName': 'Ghost 2'},
        },
      };

      final createdTaskId = await repository.createTask(taskData);

      expect(createdTaskId, 'task-created-1');
      verify(() => mockTaskCollection.doc()).called(1);

      final captured = verify(() => mockCreateDoc.set(captureAny())).captured;
      final payload = Map<String, dynamic>.from(captured.single as Map);

      expect(payload['name'], 'Trip');
      expect(payload['baseCurrency'], 'USD');
      expect(payload['id'], 'task-created-1');
      expect(payload['status'], 'ongoing');
      expect(payload['memberIds'], ['u1', 'v1']);
      expect(payload['createdAt'], isA<FieldValue>());
      expect(payload['updatedAt'], isA<FieldValue>());
    });
  });

  group('TaskRepository.updateTaskReceiverInfos', () {
    test('應用 dot-notation 更新 settlement.receiverInfos 與 updatedAt', () async {
      await repository.updateTaskReceiverInfos(
        'task-r1',
        '{"bank":"abc","account":"123"}',
      );

      final captured = verify(() => mockTaskDoc.update(captureAny())).captured;
      final payload = Map<String, dynamic>.from(captured.single as Map);

      expect(payload['settlement.receiverInfos'], '{"bank":"abc","account":"123"}');
      expect(payload['updatedAt'], isA<FieldValue>());
      verify(() => mockTaskCollection.doc('task-r1')).called(1);
    });
  });

  group('TaskRepository.addMemberToTask', () {
    test('應透過 batch 原子更新 members/memberIds/memberCount/maxMembers/updatedAt',
        () async {
      final memberData = <String, dynamic>{
        'displayName': 'Ghost 3',
        'role': 'member',
        'isLinked': false,
      };

      await repository.addMemberToTask('task-add-member', 'v3', memberData);

      final captured = verify(
        () => mockBatch.update(mockAddMemberDoc, captureAny()),
      ).captured;
      final payload = Map<String, dynamic>.from(captured.single as Map);

      expect(payload['members.v3'], memberData);
      expect(payload['memberIds'], isA<FieldValue>());
      expect(payload['memberCount'], isA<FieldValue>());
      expect(payload['maxMembers'], isA<FieldValue>());
      expect(payload['updatedAt'], isA<FieldValue>());
      verify(() => mockBatch.commit()).called(1);
    });
  });

  group('TaskRepository.leaveTask', () {
    test('應透過 batch 移除 memberIds 權限並將 members 狀態改為 ghost', () async {
      await repository.leaveTask('task-leave', 'u2');

      verify(() => mockTaskCollection.doc('task-leave')).called(1);
      final captured = verify(
        () => mockBatch.update(mockTaskDoc, captureAny()),
      ).captured;
      final payload = Map<String, dynamic>.from(captured.single as Map);

      expect(payload['memberIds'], isA<FieldValue>());
      expect(payload['members.u2.isLinked'], isFalse);
      expect(payload['members.u2.avatar'], isNull);
      expect(payload['updatedAt'], isA<FieldValue>());
      verify(() => mockBatch.commit()).called(1);
    });
  });
}
