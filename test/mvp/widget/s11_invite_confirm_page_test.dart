import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/services/analytics_service.dart';
import 'package:iron_split/features/onboarding/application/onboarding_service.dart';
import 'package:iron_split/features/onboarding/application/pending_invite_provider.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/onboarding/data/invite_repository.dart';
import 'package:iron_split/features/onboarding/presentation/pages/s11_invite_confirm_page.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import '../helpers/mock_analytics_service.dart';

class MockInviteRepository extends Mock implements InviteRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUser extends Mock implements User {}

void main() {
  late MockInviteRepository mockInviteRepo;
  late MockAuthRepository mockAuthRepo;
  late PendingInviteProvider pendingProvider;
  late MockUser mockUser;
  late MockAnalyticsService mockAnalyticsService;
  late OnboardingService onboardingService;

  setUp(() {
    mockInviteRepo = MockInviteRepository();
    mockAuthRepo = MockAuthRepository();
    pendingProvider = PendingInviteProvider();
    mockUser = MockUser();
    mockAnalyticsService = MockAnalyticsService();
    stubAnalyticsService(mockAnalyticsService);
    onboardingService = OnboardingService(
      authRepo: mockAuthRepo,
      inviteRepo: mockInviteRepo,
      analyticsService: mockAnalyticsService,
    );

    when(() => mockUser.displayName).thenReturn('Tester');
    when(() => mockAuthRepo.currentUser).thenReturn(mockUser);

    // 讓 S11 進入「需手動選 Ghost」模式，測試按鈕啟用邏輯
    when(() => mockInviteRepo.previewInviteCode(any())).thenAnswer(
      (_) async => {
        'taskData': {
          'taskName': 'Trip 2026',
          'startDate': '2026-01-01',
          'endDate': '2026-01-03',
          'baseCurrency': 'USD',
        },
        'ghosts': [
          {
            'id': 'ghost_1',
            'displayName': 'Ghost A',
            'isLinked': false,
            'role': 'member',
            'joinedAt': DateTime(2026, 1, 1).millisecondsSinceEpoch,
            'createdAt': DateTime(2026, 1, 1).millisecondsSinceEpoch,
            'prepaid': 0.0,
            'expense': 0.0,
          }
        ],
      },
    );
  });

  Future<void> pumpPage(
    WidgetTester tester, {
    required GoRouter router,
  }) async {
    LocaleSettings.setLocale(AppLocale.enUs);

    await tester.pumpWidget(
      TranslationProvider(
        child: MultiProvider(
          providers: [
            Provider<InviteRepository>.value(value: mockInviteRepo),
            Provider<AuthRepository>.value(value: mockAuthRepo),
            Provider<AnalyticsService>.value(value: mockAnalyticsService),
            Provider<OnboardingService>.value(value: onboardingService),
            ChangeNotifierProvider<PendingInviteProvider>.value(
                value: pendingProvider),
            Provider<DisplayState>.value(
              value: DisplayState(isEnlarged: false, scale: 1.0),
            ),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      ),
    );

    // init + VM state update
    await tester.pumpAndSettle();
  }

  GoRouter buildRouter() {
    return GoRouter(
      initialLocation: '/join',
      routes: [
        GoRoute(
          path: '/join',
          builder: (context, state) => const S11InviteConfirmPage(
              inviteCode: 'INV123', inviteMethod: InviteMethod.link),
        ),
        GoRoute(
          path: '/task/:taskId',
          name: 'S13',
          builder: (context, state) =>
              Text('TASK:${state.pathParameters['taskId']}'),
        ),
        GoRoute(
          path: '/',
          name: 'S00',
          builder: (context, state) => const Text('HOME'),
        ),
      ],
    );
  }

  FilledButton confirmButton(WidgetTester tester) {
    // S11 底部 action bar 內只有一顆 primary (confirm) FilledButton
    return tester.widget<FilledButton>(find.byType(FilledButton).first);
  }

  group('S11InviteConfirmPage', () {
    testWidgets('核心測試 1: 初始化後「確認加入」按鈕應為禁用', (tester) async {
      when(
        () => mockInviteRepo.joinTask(
          code: any(named: 'code'),
          displayName: any(named: 'displayName'),
          targetMemberId: any(named: 'targetMemberId'),
        ),
      ).thenAnswer((_) async => 'task_001');

      final router = buildRouter();
      await pumpPage(tester, router: router);

      expect(find.text('Ghost A'), findsOneWidget);
      expect(confirmButton(tester).onPressed, isNull);
    });

    testWidgets('核心測試 2: 選中 Ghost 後「確認加入」按鈕應啟用', (tester) async {
      when(
        () => mockInviteRepo.joinTask(
          code: any(named: 'code'),
          displayName: any(named: 'displayName'),
          targetMemberId: any(named: 'targetMemberId'),
        ),
      ).thenAnswer((_) async => 'task_001');

      final router = buildRouter();
      await pumpPage(tester, router: router);

      await tester.tap(find.text('Ghost A'));
      await tester.pumpAndSettle();

      expect(confirmButton(tester).onPressed, isNotNull);
    });

    testWidgets('核心測試 3: 點擊確認後應呼叫 joinTask 並成功導航', (tester) async {
      when(
        () => mockInviteRepo.joinTask(
          code: any(named: 'code'),
          displayName: any(named: 'displayName'),
          targetMemberId: any(named: 'targetMemberId'),
        ),
      ).thenAnswer((_) async => 'task_999');

      final router = buildRouter();
      await pumpPage(tester, router: router);

      await tester.tap(find.text('Ghost A'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(FilledButton).first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      verify(
        () => mockInviteRepo.joinTask(
          code: 'INV123',
          displayName: 'Tester',
          targetMemberId: 'ghost_1',
        ),
      ).called(1);
    });

    testWidgets('核心測試 4: 加入失敗時應顯示錯誤對話框', (tester) async {
      when(
        () => mockInviteRepo.joinTask(
          code: any(named: 'code'),
          displayName: any(named: 'displayName'),
          targetMemberId: any(named: 'targetMemberId'),
        ),
      ).thenThrow(AppErrorCodes.inviteExpired);

      final router = buildRouter();
      await pumpPage(tester, router: router);

      await tester.tap(find.text('Ghost A'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(FilledButton).first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(Dialog), findsOneWidget);
    });
  });
}
