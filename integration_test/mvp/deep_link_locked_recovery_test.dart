import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/services/analytics_service.dart';
import 'package:iron_split/core/services/deep_link_service.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/record/data/record_repository.dart';
import 'package:iron_split/features/settlement/application/settlement_service.dart';
import 'package:iron_split/features/task/application/export_service.dart';
import 'package:iron_split/features/task/application/share_service.dart';
import 'package:iron_split/features/task/application/task_service.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:iron_split/features/task/presentation/pages/s17_task_locked_page.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import '../../test/mvp/helpers/mock_analytics_service.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

class MockRecordRepository extends Mock implements RecordRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockTaskService extends Mock implements TaskService {}

class MockShareService extends Mock implements ShareService {}

class MockDeepLinkService extends Mock implements DeepLinkService {}

class MockSettlementService extends Mock implements SettlementService {}

class MockUser extends Mock implements User {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MockTaskRepository mockTaskRepo;
  late MockRecordRepository mockRecordRepo;
  late MockAuthRepository mockAuthRepo;
  late MockTaskService mockTaskService;
  late MockShareService mockShareService;
  late ExportService exportService;
  late MockDeepLinkService mockDeepLinkService;
  late MockSettlementService mockSettlementService;
  late MockUser mockUser;
  late MockAnalyticsService mockAnalyticsService;

  setUp(() {
    mockTaskRepo = MockTaskRepository();
    mockRecordRepo = MockRecordRepository();
    mockAuthRepo = MockAuthRepository();
    mockTaskService = MockTaskService();
    mockShareService = MockShareService();
    exportService = ExportService();
    mockDeepLinkService = MockDeepLinkService();
    mockSettlementService = MockSettlementService();
    mockUser = MockUser();
    mockAnalyticsService = MockAnalyticsService();
    stubAnalyticsService(mockAnalyticsService);

    when(() => mockUser.uid).thenReturn('u1');
    when(() => mockAuthRepo.currentUser).thenReturn(mockUser);
  });

  GoRouter _router() {
    return GoRouter(
      initialLocation: '/locked/task-404',
      routes: [
        GoRoute(
          path: '/locked/:taskId',
          name: 'S17',
          builder: (context, state) =>
              S17TaskLockedPage(taskId: state.pathParameters['taskId']!),
        ),
        GoRoute(
          path: '/task',
          name: 'S10',
          builder: (_, __) => const Scaffold(body: Center(child: Text('S10'))),
        ),
        GoRoute(
          path: '/task/:taskId',
          name: 'S13',
          builder: (_, state) =>
              Scaffold(body: Center(child: Text('S13:${state.pathParameters['taskId']}'))),
        ),
        GoRoute(
          path: '/task/:taskId/settings',
          name: 'S14',
          builder: (_, __) => const Scaffold(body: Center(child: Text('S14'))),
        ),
      ],
    );
  }

  Future<void> _pump(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    LocaleSettings.setLocale(AppLocale.enUs);

    await tester.pumpWidget(
      TranslationProvider(
        child: MultiProvider(
          providers: [
            Provider<TaskRepository>.value(value: mockTaskRepo),
            Provider<RecordRepository>.value(value: mockRecordRepo),
            Provider<AuthRepository>.value(value: mockAuthRepo),
            Provider<AnalyticsService>.value(value: mockAnalyticsService),
            Provider<TaskService>.value(value: mockTaskService),
            Provider<ShareService>.value(value: mockShareService),
            Provider<ExportService>.value(value: exportService),
            Provider<DeepLinkService>.value(value: mockDeepLinkService),
            Provider<SettlementService>.value(value: mockSettlementService),
            Provider<DisplayState>.value(
              value: DisplayState(isEnlarged: false, scale: 1.0),
            ),
          ],
          child: MaterialApp.router(routerConfig: _router()),
        ),
      ),
    );

    for (int i = 0; i < 25; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  group('MVP Integration - Deep Link Locked Recovery', () {
    testWidgets('permissionDenied on /locked/:taskId should recover to S10 with prompt',
        (tester) async {
      when(() => mockTaskService.getValidatedTask('task-404'))
          .thenThrow(AppErrorCodes.permissionDenied);

      await _pump(tester);

      expect(find.text('S10'), findsOneWidget);
      expect(find.text('Permission denied.'), findsOneWidget);
    });

    testWidgets('dataNotFound on /locked/:taskId should recover to S10 with prompt',
        (tester) async {
      when(() => mockTaskService.getValidatedTask('task-404'))
          .thenAnswer((_) async => null);

      await _pump(tester);

      expect(find.text('S10'), findsOneWidget);
      expect(find.text('Data not found. Please try again later.'), findsOneWidget);
    });
  });
}
