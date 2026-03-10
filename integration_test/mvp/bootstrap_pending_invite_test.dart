import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/services/analytics_service.dart';
import 'package:iron_split/features/onboarding/application/pending_invite_provider.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/system/presentation/pages/s00_system_bootstrap_page.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import '../../test/mvp/helpers/mock_analytics_service.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUser extends Mock implements User {}

class FakePendingInviteProvider extends PendingInviteProvider {
  FakePendingInviteProvider(this.code);
  final String? code;

  @override
  String? get pendingCode => code;
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthRepository mockAuthRepo;
  late MockUser mockUser;
  late MockAnalyticsService mockAnalyticsService;

  setUp(() {
    mockAuthRepo = MockAuthRepository();
    mockUser = MockUser();
    mockAnalyticsService = MockAnalyticsService();
    stubAnalyticsService(mockAnalyticsService);
    when(() => mockUser.uid).thenReturn('u1');
    when(() => mockUser.displayName).thenReturn('Captain');
    when(() => mockAuthRepo.currentUser).thenReturn(mockUser);
    when(() => mockAuthRepo.isTermsValid()).thenAnswer((_) async => true);
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
          path: '/join',
          name: 'S11',
          builder: (context, state) =>
              Text('JOIN:${state.uri.queryParameters['code'] ?? ''}'),
        ),
        GoRoute(
            path: '/task', name: 'S10', builder: (_, __) => const Text('S10')),
        GoRoute(
            path: '/onboarding/consent',
            name: 'S50',
            builder: (_, __) => const Text('S50')),
        GoRoute(
            path: '/onboarding/name',
            name: 'S51',
            builder: (_, __) => const Text('S51')),
        GoRoute(
            path: '/settings/terms-update',
            name: 'S72',
            builder: (_, __) => const Text('S72')),
      ],
    );
  }

  Future<void> pumpApp(WidgetTester tester, {String? pendingCode}) async {
    LocaleSettings.setLocale(AppLocale.enUs);
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

    // S00 initApp 內有 800ms 延遲
    for (int i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  group('MVP Integration - Bootstrap Pending Invite', () {
    testWidgets(
      'pending invite exists and logged-in user should route to /join?code=...',
      (tester) async {
        await pumpApp(tester, pendingCode: 'INV123');
        expect(find.text('JOIN:INV123'), findsOneWidget);
      },
    );

    testWidgets(
      'no pending invite and logged-in user should route to /task',
      (tester) async {
        await pumpApp(tester, pendingCode: null);
        expect(find.text('S10'), findsOneWidget);
      },
    );
  });
}
