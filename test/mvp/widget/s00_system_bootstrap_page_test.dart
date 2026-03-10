import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/services/analytics_service.dart';
import 'package:iron_split/features/onboarding/application/pending_invite_provider.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/system/presentation/pages/s00_system_bootstrap_page.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import '../helpers/mock_analytics_service.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUser extends Mock implements User {}

class FakePendingInviteProvider extends PendingInviteProvider {
  FakePendingInviteProvider(this.code);

  final String? code;

  @override
  String? get pendingCode => code;
}

void main() {
  late MockAuthRepository mockAuthRepo;
  late MockUser mockUser;
  late MockAnalyticsService mockAnalyticsService;

  setUp(() {
    mockAuthRepo = MockAuthRepository();
    mockUser = MockUser();
    mockAnalyticsService = MockAnalyticsService();
    stubAnalyticsService(mockAnalyticsService);
    when(() => mockUser.uid).thenReturn('u1');
  });

  GoRouter router() {
    return GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          name: 'S00',
          builder: (context, state) => const S00SystemBootstrapPage(),
        ),
        GoRoute(
          path: '/task',
          name: 'S10',
          builder: (_, __) => const Text('S10'),
        ),
        GoRoute(
          path: '/join',
          name: 'S11',
          builder: (context, state) =>
              Text('S11:${state.uri.queryParameters['code'] ?? ''}'),
        ),
        GoRoute(
          path: '/onboarding/consent',
          name: 'S50',
          builder: (_, __) => const Text('S50'),
        ),
        GoRoute(
          path: '/onboarding/name',
          name: 'S51',
          builder: (_, __) => const Text('S51'),
        ),
        GoRoute(
          path: '/settings/terms-update',
          name: 'S72',
          builder: (_, __) => const Text('S72'),
        ),
      ],
    );
  }

  Future<void> pump(
    WidgetTester tester, {
    required User? user,
    required bool isTermsValid,
    String? pendingCode,
  }) async {
    LocaleSettings.setLocale(AppLocale.enUs);

    when(() => mockAuthRepo.currentUser).thenReturn(user);
    when(() => mockAuthRepo.isTermsValid())
        .thenAnswer((_) async => isTermsValid);

    await tester.pumpWidget(
      TranslationProvider(
        child: MultiProvider(
          providers: [
            Provider<AuthRepository>.value(value: mockAuthRepo),
            Provider<AnalyticsService>.value(value: mockAnalyticsService),
            ChangeNotifierProvider<PendingInviteProvider>.value(
              value: FakePendingInviteProvider(pendingCode),
            ),
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

  group('S00SystemBootstrapPage widget test', () {
    testWidgets('未登入應導向 S50 onboarding', (tester) async {
      await pump(
        tester,
        user: null,
        isTermsValid: false,
      );

      expect(find.text('S50'), findsOneWidget);
      verifyNever(() => mockAuthRepo.isTermsValid());
    });

    testWidgets('已登入但條款過期應導向 S72 update terms', (tester) async {
      when(() => mockUser.displayName).thenReturn('Captain');

      await pump(
        tester,
        user: mockUser,
        isTermsValid: false,
      );

      expect(find.text('S72'), findsOneWidget);
      verify(() => mockAuthRepo.isTermsValid()).called(1);
    });

    testWidgets('已登入且缺少名稱應導向 S51 setup name', (tester) async {
      when(() => mockUser.displayName).thenReturn('');

      await pump(
        tester,
        user: mockUser,
        isTermsValid: true,
      );

      expect(find.text('S51'), findsOneWidget);
    });

    testWidgets('已登入且有 pending code 應導向 S11 confirm invite', (tester) async {
      when(() => mockUser.displayName).thenReturn('Captain');

      await pump(
        tester,
        user: mockUser,
        isTermsValid: true,
        pendingCode: 'INV-777',
      );

      expect(find.text('S11:INV-777'), findsOneWidget);
    });

    testWidgets('已登入且條件皆通過應導向 S10 home', (tester) async {
      when(() => mockUser.displayName).thenReturn('Captain');

      await pump(
        tester,
        user: mockUser,
        isTermsValid: true,
        pendingCode: null,
      );

      expect(find.text('S10'), findsOneWidget);
    });
  });
}
