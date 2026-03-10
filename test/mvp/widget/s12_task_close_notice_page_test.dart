import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/models/record_model.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/record/data/record_repository.dart';
import 'package:iron_split/features/task/application/task_service.dart';
import 'package:iron_split/features/task/presentation/pages/s12_task_close_notice_page.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockRecordRepository extends Mock implements RecordRepository {}

class MockTaskService extends Mock implements TaskService {}

class MockUser extends Mock implements User {}

void main() {
  late MockAuthRepository mockAuthRepo;
  late MockRecordRepository mockRecordRepo;
  late MockTaskService mockTaskService;
  late MockUser mockUser;

  setUp(() {
    mockAuthRepo = MockAuthRepository();
    mockRecordRepo = MockRecordRepository();
    mockTaskService = MockTaskService();
    mockUser = MockUser();

    when(() => mockUser.uid).thenReturn('u1');
    when(() => mockAuthRepo.currentUser).thenReturn(mockUser);
    when(() => mockTaskService.deleteTask(any())).thenAnswer((_) async {});
    when(() => mockTaskService.closeTaskWithRetention(any()))
        .thenAnswer((_) async {});
  });

  GoRouter router() {
    return GoRouter(
      initialLocation: '/task/task-1/settings/close',
      routes: [
        GoRoute(
          path: '/',
          name: 'S00',
          builder: (context, state) => const Text('S00'),
        ),
        GoRoute(
          path: '/task/:taskId/settings/close',
          name: 'S12',
          builder: (context, state) =>
              S12TaskCloseNoticePage(taskId: state.pathParameters['taskId']!),
        ),
      ],
    );
  }

  Future<void> pump(WidgetTester tester) async {
    LocaleSettings.setLocale(AppLocale.enUs);

    await tester.pumpWidget(
      TranslationProvider(
        child: MultiProvider(
          providers: [
            Provider<AuthRepository>.value(value: mockAuthRepo),
            Provider<RecordRepository>.value(value: mockRecordRepo),
            Provider<TaskService>.value(value: mockTaskService),
            Provider<DisplayState>.value(
              value: DisplayState(isEnlarged: false, scale: 1.0),
            ),
          ],
          child: MaterialApp.router(routerConfig: router()),
        ),
      ),
    );

    for (int i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Future<void> confirmCloseFlow(WidgetTester tester) async {
    await tester.tap(find.widgetWithText(FilledButton, 'Close Task'));
    await tester.pumpAndSettle();

    expect(find.text('Close Task'), findsWidgets);
    expect(find.textContaining('cannot be undone'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Confirm').last);
    await tester.pumpAndSettle();
  }

  group('S12TaskCloseNoticePage widget test', () {
    testWidgets('無記錄時 confirm 應呼叫 deleteTask 並導回 S00', (tester) async {
      when(() => mockRecordRepo.getRecordsOnce('task-1'))
          .thenAnswer((_) async => []);

      await pump(tester);
      await confirmCloseFlow(tester);

      verify(() => mockTaskService.deleteTask('task-1')).called(1);
      verifyNever(() => mockTaskService.closeTaskWithRetention(any()));
      expect(find.text('S00'), findsOneWidget);
    });

    testWidgets('有記錄時 confirm 應呼叫 closeTaskWithRetention 並導回 S00',
        (tester) async {
      when(() => mockRecordRepo.getRecordsOnce('task-1')).thenAnswer(
        (_) async => [
          RecordModel(
            id: 'r1',
            date: DateTime(2026, 1, 1),
            title: 'Expense',
            type: RecordType.expense,
            amount: 100,
            currencyCode: CurrencyConstants.defaultCode,
          )
        ],
      );

      await pump(tester);
      await confirmCloseFlow(tester);

      verify(() => mockTaskService.closeTaskWithRetention('task-1')).called(1);
      verifyNever(() => mockTaskService.deleteTask(any()));
      expect(find.text('S00'), findsOneWidget);
    });
  });
}
