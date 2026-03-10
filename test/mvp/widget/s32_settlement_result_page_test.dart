import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/constants/remainder_rule_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/core/services/deep_link_service.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/settlement/application/settlement_service.dart';
import 'package:iron_split/features/settlement/presentation/pages/s32_settlement_result_page.dart';
import 'package:iron_split/features/task/application/share_service.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockDeepLinkService extends Mock implements DeepLinkService {}

class MockSettlementService extends Mock implements SettlementService {}

class MockShareService extends Mock implements ShareService {}

class MockUser extends Mock implements User {}

void main() {
  late MockTaskRepository mockTaskRepo;
  late MockAuthRepository mockAuthRepo;
  late MockDeepLinkService mockDeepLinkService;
  late MockSettlementService mockSettlementService;
  late MockShareService mockShareService;
  late MockUser mockUser;

  late TaskModel nonRandomTask;
  late TaskModel randomTask;

  setUp(() {
    mockTaskRepo = MockTaskRepository();
    mockAuthRepo = MockAuthRepository();
    mockDeepLinkService = MockDeepLinkService();
    mockSettlementService = MockSettlementService();
    mockShareService = MockShareService();
    mockUser = MockUser();

    when(() => mockUser.uid).thenReturn('u1');
    when(() => mockAuthRepo.currentUser).thenReturn(mockUser);

    when(() => mockDeepLinkService.generateSettlementLink(any()))
        .thenReturn('https://ironsplit.app/locked/task-1');

    when(
      () => mockSettlementService.markSettlementAsSeen(
        taskId: any(named: 'taskId'),
        memberId: any(named: 'memberId'),
      ),
    ).thenAnswer((_) async {});

    when(() =>
            mockShareService.shareText(any(), subject: any(named: 'subject')))
        .thenAnswer((_) async {});

    nonRandomTask = _task(rule: RemainderRuleConstants.member, remainder: 0.0);
    randomTask = _task(rule: RemainderRuleConstants.random, remainder: 0.02);

    when(() => mockTaskRepo.streamTask('task-1'))
        .thenAnswer((_) => Stream.value(nonRandomTask));
  });

  GoRouter router() {
    return GoRouter(
      initialLocation: '/result',
      routes: [
        GoRoute(
          path: '/result',
          builder: (context, state) =>
              const S32SettlementResultPage(taskId: 'task-1'),
        ),
        GoRoute(
          path: '/locked/:taskId',
          name: 'S17',
          builder: (context, state) =>
              Text('S17:${state.pathParameters['taskId']}'),
        ),
      ],
    );
  }

  Future<void> pump(WidgetTester tester, {bool settle = true}) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    LocaleSettings.setLocale(AppLocale.enUs);

    await tester.pumpWidget(
      TranslationProvider(
        child: MultiProvider(
          providers: [
            Provider<TaskRepository>.value(value: mockTaskRepo),
            Provider<AuthRepository>.value(value: mockAuthRepo),
            Provider<DeepLinkService>.value(value: mockDeepLinkService),
            Provider<SettlementService>.value(value: mockSettlementService),
            Provider<ShareService>.value(value: mockShareService),
            Provider<DisplayState>.value(
              value: DisplayState(isEnlarged: false, scale: 1.0),
            ),
          ],
          child: MaterialApp.router(routerConfig: router()),
        ),
      ),
    );

    if (settle) {
      await tester.pumpAndSettle();
    } else {
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  group('S32SettlementResultPage widget test', () {
    testWidgets('核心測試 1: 應正確渲染結算結果與操作按鈕', (tester) async {
      await pump(tester);

      expect(find.text('Settlement Complete'), findsOneWidget);
      expect(
        find.text(
            'All records are finalized. Please notify members to complete payment.'),
        findsOneWidget,
      );
      expect(find.text('Share Result'), findsOneWidget);
      expect(find.text('Back to Task'), findsOneWidget);
      expect(find.text('Revealing result...'), findsNothing);
    });

    testWidgets('核心測試 2: 點擊分享應呼叫 shareText 並帶入 deep link', (tester) async {
      await pump(tester);

      await tester.tap(find.text('Share Result'));
      await tester.pumpAndSettle();

      final captured = verify(
        () => mockShareService.shareText(
          captureAny(),
          subject: captureAny(named: 'subject'),
        ),
      ).captured;

      final message = captured[0] as String;
      final subject = captured[1] as String;

      expect(subject, 'Check Iron Split Task Settlement');
      expect(message, contains('"Trip"'));
      expect(message, contains('https://ironsplit.app/locked/task-1'));
    });

    testWidgets('核心測試 3: 點擊 Back to Task 應先 mark seen 再導航至 S17',
        (tester) async {
      await pump(tester);

      await tester.tap(find.text('Back to Task'));
      await tester.pumpAndSettle();

      verify(
        () => mockSettlementService.markSettlementAsSeen(
          taskId: 'task-1',
          memberId: 'u1',
        ),
      ).called(1);

      expect(find.text('S17:task-1'), findsOneWidget);
    });

    testWidgets('核心測試 4: random 且有零頭時，初始應顯示等待揭曉文案', (tester) async {
      when(() => mockTaskRepo.streamTask('task-1'))
          .thenAnswer((_) => Stream.value(randomTask));

      await pump(tester, settle: false);

      expect(find.text('Revealing result...'), findsOneWidget);

      // 清掉頁面內部 500ms 延遲 timer，避免測試結束殘留 pending timer
      await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));
      await tester.pump(const Duration(milliseconds: 600));
    });
  });
}

TaskModel _task({required String rule, required double remainder}) {
  final now = DateTime(2026, 1, 1);
  return TaskModel(
    id: 'task-1',
    name: 'Trip',
    baseCurrency: 'USD',
    members: {
      'u1': TaskMember(
        id: 'u1',
        displayName: 'Captain',
        isLinked: true,
        role: 'captain',
        joinedAt: now,
        createdAt: now,
      ),
      'u2': TaskMember(
        id: 'u2',
        displayName: 'Member B',
        isLinked: true,
        role: 'member',
        joinedAt: now,
        createdAt: now,
      ),
    },
    memberIds: const ['u1', 'u2'],
    status: TaskStatus.settled,
    createdBy: 'u1',
    remainderRule: rule,
    remainderAbsorberId: rule == RemainderRuleConstants.member ? 'u1' : null,
    createdAt: now,
    updatedAt: now,
    settlement: {
      'remainderWinnerId': 'u2',
      'allocations': {
        'u1': -10.0,
        'u2': 10.0,
      },
      'dashboardSnapshot': {
        'remainder': remainder,
      },
      'memberStatus': {
        'u1': false,
        'u2': false,
      },
      'viewStatus': {
        'u1': false,
        'u2': false,
      },
    },
  );
}
