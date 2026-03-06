import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/models/record_model.dart';
import 'package:iron_split/core/services/preferences_service.dart';
import 'package:iron_split/core/viewmodels/theme_vm.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/record/application/record_service.dart';
import 'package:iron_split/features/record/data/record_repository.dart';
import 'package:iron_split/features/record/presentation/pages/s15_record_edit_page.dart';
import 'package:iron_split/features/record/presentation/views/s15_expense_form.dart';
import 'package:iron_split/features/record/presentation/views/s15_prepay_form.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/features/task/data/models/activity_log_model.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockRecordService extends Mock implements RecordService {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockTaskRepository extends Mock implements TaskRepository {}

class MockRecordRepository extends Mock implements RecordRepository {}

class MockPreferencesService extends Mock implements PreferencesService {}

class MockUser extends Mock implements User {}

class MockCurrencyRateFetcher extends Mock {
  Future<double> call({required String from, required String to});
}

class MockActivityLogger extends Mock {
  Future<void> call({
    required String taskId,
    required LogAction action,
    required Map<String, dynamic> details,
  });
}

class FakeRecordModel extends Fake implements RecordModel {}

void main() {
  late MockRecordService mockRecordService;
  late MockAuthRepository mockAuthRepo;
  late MockTaskRepository mockTaskRepo;
  late MockRecordRepository mockRecordRepo;
  late MockPreferencesService mockPrefsService;
  late MockCurrencyRateFetcher mockRateFetcher;
  late MockActivityLogger mockActivityLogger;
  late MockUser mockUser;

  setUpAll(() {
    registerFallbackValue(FakeRecordModel());
    registerFallbackValue(LogAction.createRecord);
  });

  setUp(() {
    mockRecordService = MockRecordService();
    mockAuthRepo = MockAuthRepository();
    mockTaskRepo = MockTaskRepository();
    mockRecordRepo = MockRecordRepository();
    mockPrefsService = MockPreferencesService();
    mockRateFetcher = MockCurrencyRateFetcher();
    mockActivityLogger = MockActivityLogger();
    mockUser = MockUser();

    when(() => mockUser.uid).thenReturn('u1');
    when(() => mockUser.displayName).thenReturn('Tester');
    when(() => mockAuthRepo.currentUser).thenReturn(mockUser);

    when(() => mockPrefsService.getLastCurrency()).thenReturn(null);
    when(() => mockPrefsService.saveLastCurrency(any())).thenAnswer((_) async {});
    when(
      () => mockTaskRepo.streamTask(any()),
    ).thenAnswer((_) => Stream.value(_task()));
    when(
      () => mockRecordService.createRecord(
        taskId: any(named: 'taskId'),
        draftRecord: any(named: 'draftRecord'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => mockRecordService.updateRecord(
        taskId: any(named: 'taskId'),
        oldRecord: any(named: 'oldRecord'),
        newRecord: any(named: 'newRecord'),
      ),
    ).thenAnswer((_) async {});
    when(() => mockRecordService.deleteRecord(any(), any())).thenAnswer((_) async {});
    when(
      () => mockRecordService.validateAndDelete(any(), any(), any()),
    ).thenAnswer((_) async {});

    when(
      () => mockRateFetcher.call(from: any(named: 'from'), to: any(named: 'to')),
    ).thenAnswer((_) async => 150.0);

    when(
      () => mockActivityLogger.call(
        taskId: any(named: 'taskId'),
        action: any(named: 'action'),
        details: any(named: 'details'),
      ),
    ).thenAnswer((_) async {});
  });

  GoRouter _router() {
    return GoRouter(
      initialLocation: '/record',
      routes: [
        GoRoute(
          path: '/record',
          builder: (context, state) => S15RecordEditPage(
            taskId: 'task-1',
            baseCurrency: CurrencyConstants.getCurrencyConstants('USD'),
            recordService: mockRecordService,
            rateFetcher: mockRateFetcher.call,
            activityLogger: mockActivityLogger.call,
          ),
        ),
        GoRoute(
          path: '/done',
          builder: (context, state) => const Text('DONE'),
        ),
      ],
    );
  }

  Future<void> _pump(WidgetTester tester) async {
    LocaleSettings.setLocale(AppLocale.enUs);

    await tester.pumpWidget(
      TranslationProvider(
        child: MultiProvider(
          providers: [
            Provider<AuthRepository>.value(value: mockAuthRepo),
            Provider<TaskRepository>.value(value: mockTaskRepo),
            Provider<RecordRepository>.value(value: mockRecordRepo),
            Provider<PreferencesService>.value(value: mockPrefsService),
            Provider<RecordService>.value(value: mockRecordService),
            ChangeNotifierProvider<ThemeViewModel>(
              create: (_) => ThemeViewModel(),
            ),
            Provider<DisplayState>.value(
              value: DisplayState(isEnlarged: false, scale: 1.0),
            ),
          ],
          child: MaterialApp.router(routerConfig: _router()),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Finder _saveButtonFinder() => find.widgetWithText(FilledButton, 'Save');

  FilledButton _saveButton(WidgetTester tester) =>
      tester.widget<FilledButton>(_saveButtonFinder());

  Finder _textFieldByLabel(String label) {
    final fieldStack =
        find.ancestor(of: find.text(label).first, matching: find.byType(Stack));
    return find
        .descendant(of: fieldStack.first, matching: find.byType(TextFormField))
        .first;
  }

  group('S15RecordEditPage widget', () {
    testWidgets('核心測試 1: 切換 Expense -> Prepay 時，VM 與 UI 應正確反映', (tester) async {
      await _pump(tester);

      expect(find.byType(S15ExpenseForm), findsOneWidget);
      expect(find.byType(S15PrepayForm), findsNothing);

      await tester.tap(find.text('Prepaid'));
      await tester.pumpAndSettle();

      expect(find.byType(S15ExpenseForm), findsNothing);
      expect(find.byType(S15PrepayForm), findsOneWidget);
    });

    testWidgets('核心測試 2: 儲存按鈕初始禁用，輸入金額與標題後啟用', (tester) async {
      await _pump(tester);

      expect(_saveButton(tester).onPressed, isNull);

      await tester.enterText(_textFieldByLabel('Amount'), '120');
      await tester.enterText(_textFieldByLabel('Item Name'), 'Dinner');
      await tester.pumpAndSettle();

      expect(_saveButton(tester).onPressed, isNotNull);
    });

    testWidgets('核心測試 3: prepayIsUsed 錯誤應被攔截並顯示提示', (tester) async {
      when(
        () => mockRecordService.createRecord(
          taskId: any(named: 'taskId'),
          draftRecord: any(named: 'draftRecord'),
        ),
      ).thenThrow(AppErrorCodes.prepayIsUsed);

      await _pump(tester);

      await tester.tap(find.text('Prepaid'));
      await tester.pumpAndSettle();

      await tester.enterText(_textFieldByLabel('Amount'), '100');
      await tester.pumpAndSettle();

      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      await tester.ensureVisible(_saveButtonFinder());
      await tester.tap(_saveButtonFinder());
      await tester.pumpAndSettle();

      verify(
        () => mockRecordService.createRecord(
          taskId: 'task-1',
          draftRecord: any(named: 'draftRecord'),
        ),
      ).called(1);

      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('核心測試 4: 切換幣別後應顯示對應貨幣符號', (tester) async {
      await _pump(tester);

      expect(find.text('USD'), findsWidgets);

      await tester.tap(find.text('USD').first);
      await tester.pumpAndSettle();

      // 從 USD(0) 滾到 JPY(1)
      await tester.drag(find.byType(CupertinoPicker), const Offset(0, -50));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Confirm').last);
      await tester.pumpAndSettle();

      verify(() => mockPrefsService.saveLastCurrency('JPY')).called(1);
      verify(() => mockRateFetcher.call(from: 'JPY', to: 'USD')).called(1);

      expect(find.text('JPY'), findsWidgets);
      expect(find.text('¥'), findsWidgets);
    });
  });
}

TaskModel _task() {
  final now = DateTime(2026, 1, 1);
  return TaskModel(
    id: 'task-1',
    name: 'Task',
    baseCurrency: 'USD',
    members: {
      'u1': TaskMember(
        id: 'u1',
        displayName: 'Tester',
        isLinked: true,
        role: 'captain',
        joinedAt: now,
        createdAt: now,
      ),
    },
    memberIds: const ['u1'],
    status: TaskStatus.ongoing,
    createdBy: 'u1',
    remainderRule: 'random',
    createdAt: now,
    updatedAt: now,
  );
}
