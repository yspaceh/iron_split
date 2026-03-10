import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/features/onboarding/application/onboarding_service.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/onboarding/data/invite_repository.dart';
import 'package:iron_split/features/onboarding/data/pending_invite_local_store.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/mock_analytics_service.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockInviteRepository extends Mock implements InviteRepository {}

class MockPendingInviteLocalStore extends Mock
    implements PendingInviteLocalStore {}

class MockUser extends Mock implements User {}

void main() {
  late MockAuthRepository mockAuthRepo;
  late MockInviteRepository mockInviteRepo;
  late MockPendingInviteLocalStore mockLocalStore;
  late MockAnalyticsService mockAnalyticsService;
  late OnboardingService service;
  late MockUser mockUser;

  setUp(() {
    mockAuthRepo = MockAuthRepository();
    mockInviteRepo = MockInviteRepository();
    mockLocalStore = MockPendingInviteLocalStore();
    mockAnalyticsService = MockAnalyticsService();
    stubAnalyticsService(mockAnalyticsService);
    mockUser = MockUser();

    service = OnboardingService(
      authRepo: mockAuthRepo,
      inviteRepo: mockInviteRepo,
      localStore: mockLocalStore,
      analyticsService: mockAnalyticsService,
    );

    when(() => mockUser.uid).thenReturn('u1');
    when(() => mockUser.displayName).thenReturn('Captain');
    when(() => mockLocalStore.clear()).thenAnswer((_) async {});
  });

  group('OnboardingService.validateName', () {
    test('空白名稱應拋 fieldRequired', () {
      expect(
        () => service.validateName('   '),
        throwsA(AppErrorCodes.fieldRequired),
      );
    });

    test('長度超過 10 應拋 nameLengthExceeded', () {
      expect(
        () => service.validateName('12345678901'),
        throwsA(AppErrorCodes.nameLengthExceeded),
      );
    });

    test('含控制字元應拋 invalidChar', () {
      expect(
        () => service.validateName('A\nB'),
        throwsA(AppErrorCodes.invalidChar),
      );
    });

    test('合法名稱應通過', () {
      service.validateName('Amy');
    });
  });

  group('OnboardingService.analyzeInvite (ghost auto-assign)', () {
    test('多個 ghost 財務相同時 isAutoAssign 應為 true', () async {
      when(() => mockInviteRepo.previewInviteCode('INV-SAME')).thenAnswer(
        (_) async => {
          'taskId': 'task-1',
          'ghosts': [
            {
              'id': 'g1',
              'displayName': 'Ghost 1',
              'isLinked': false,
              'role': 'member',
              'prepaid': 10.0,
              'expense': 5.0,
            },
            {
              'id': 'g2',
              'displayName': 'Ghost 2',
              'isLinked': false,
              'role': 'member',
              'prepaid': 10.0,
              'expense': 5.0,
            },
          ],
        },
      );

      final result = await service.analyzeInvite('INV-SAME');

      expect(result.ghosts.length, 2);
      expect(result.isAutoAssign, isTrue);
    });

    test('多個 ghost 財務不同時 isAutoAssign 應為 false', () async {
      when(() => mockInviteRepo.previewInviteCode('INV-DIFF')).thenAnswer(
        (_) async => {
          'taskId': 'task-1',
          'ghosts': [
            {
              'id': 'g1',
              'displayName': 'Ghost 1',
              'isLinked': false,
              'role': 'member',
              'prepaid': 10.0,
              'expense': 5.0,
            },
            {
              'id': 'g2',
              'displayName': 'Ghost 2',
              'isLinked': false,
              'role': 'member',
              'prepaid': 8.0,
              'expense': 5.0,
            },
          ],
        },
      );

      final result = await service.analyzeInvite('INV-DIFF');

      expect(result.ghosts.length, 2);
      expect(result.isAutoAssign, isFalse);
    });
  });

  group('OnboardingService.confirmJoin', () {
    test('應呼叫 joinTask 並清除 pending invite', () async {
      when(() => mockAuthRepo.currentUser).thenReturn(mockUser);
      when(
        () => mockInviteRepo.joinTask(
          code: 'INV123',
          displayName: 'New Member',
          targetMemberId: 'g1',
        ),
      ).thenAnswer((_) async => 'task-joined-1');

      final taskId = await service.confirmJoin(
        code: 'INV123',
        method: InviteMethod.link,
        targetMemberId: 'g1',
      );

      expect(taskId, 'task-joined-1');
      verify(
        () => mockInviteRepo.joinTask(
          code: 'INV123',
          displayName: 'New Member',
          targetMemberId: 'g1',
        ),
      ).called(1);
      verify(() => mockLocalStore.clear()).called(1);
    });

    test('進行中任務已達上限時應拋 tasksExceeded，且不清除 pending invite', () async {
      when(() => mockInviteRepo.joinTask(
            code: 'INV123',
            displayName: 'New Member',
            targetMemberId: 'g1',
          )).thenThrow(AppErrorCodes.tasksExceeded);

      await expectLater(
        () => service.confirmJoin(
          code: 'INV123',
          method: InviteMethod.link,
          targetMemberId: 'g1',
        ),
        throwsA(AppErrorCodes.tasksExceeded),
      );

      verify(() => mockInviteRepo.joinTask(
            code: 'INV123',
            displayName: 'New Member',
            targetMemberId: 'g1',
          )).called(1);
      verifyNever(() => mockLocalStore.clear());
    });
  });
}
