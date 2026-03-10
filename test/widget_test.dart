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

import 'mvp/helpers/mock_analytics_service.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepo;
  late MockAnalyticsService mockAnalyticsService;

  setUp(() {
    mockAuthRepo = MockAuthRepository();
    mockAnalyticsService = MockAnalyticsService();
    stubAnalyticsService(mockAnalyticsService);
    when(() => mockAuthRepo.currentUser).thenReturn(null);
  });

  GoRouter router() {
    return GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => const S00SystemBootstrapPage(),
        ),
        GoRoute(
          path: '/onboarding/consent',
          name: 'S50',
          builder: (_, __) => const Text('S50'),
        ),
      ],
    );
  }

  testWidgets('S00 bootstrap shows loading then routes unauthenticated users',
      (WidgetTester tester) async {
    LocaleSettings.setLocale(AppLocale.enUs);

    await tester.pumpWidget(
      TranslationProvider(
        child: MultiProvider(
          providers: [
            Provider<AuthRepository>.value(value: mockAuthRepo),
            Provider<AnalyticsService>.value(value: mockAnalyticsService),
            ChangeNotifierProvider<PendingInviteProvider>(
              create: (_) => PendingInviteProvider(),
            ),
            Provider<DisplayState>.value(
              value: DisplayState(isEnlarged: false, scale: 1.0),
            ),
          ],
          child: MaterialApp.router(routerConfig: router()),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    for (int i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(find.text('S50'), findsOneWidget);
  });
}
