import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/models/invite_code_model.dart';
import 'package:iron_split/core/services/analytics_service.dart';
import 'package:iron_split/core/services/deep_link_service.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/onboarding/data/invite_repository.dart';
import 'package:iron_split/features/task/application/share_service.dart';
import 'package:iron_split/features/task/application/task_service.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:iron_split/features/task/presentation/pages/s16_task_create_edit_page.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import '../../test/mvp/helpers/mock_analytics_service.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockInviteRepository extends Mock implements InviteRepository {}

class MockShareService extends Mock implements ShareService {}

class MockDeepLinkService extends Mock implements DeepLinkService {}

class MockUser extends Mock implements User {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MockTaskRepository mockTaskRepo;
  late MockAuthRepository mockAuthRepo;
  late MockInviteRepository mockInviteRepo;
  late MockShareService mockShareService;
  late MockDeepLinkService mockDeepLinkService;
  late MockUser mockUser;
  late MockAnalyticsService mockAnalyticsService;

  setUp(() {
    mockTaskRepo = MockTaskRepository();
    mockAuthRepo = MockAuthRepository();
    mockInviteRepo = MockInviteRepository();
    mockShareService = MockShareService();
    mockDeepLinkService = MockDeepLinkService();
    mockUser = MockUser();
    mockAnalyticsService = MockAnalyticsService();
    stubAnalyticsService(mockAnalyticsService);

    when(() => mockUser.uid).thenReturn('u1');
    when(() => mockUser.displayName).thenReturn('Captain');
    when(() => mockAuthRepo.currentUser).thenReturn(mockUser);

    when(() =>
            mockShareService.shareText(any(), subject: any(named: 'subject')))
        .thenAnswer((_) async {});
  });

  GoRouter _router() {
    return GoRouter(
      initialLocation: '/task/create',
      routes: [
        GoRoute(
          path: '/task/create',
          name: 'S16',
          builder: (context, state) => const S16TaskCreateEditPage(),
        ),
        GoRoute(
          path: '/task/:taskId',
          name: 'S13',
          builder: (context, state) =>
              Text('S13:${state.pathParameters['taskId']}'),
        ),
      ],
    );
  }

  Future<void> _pumpFlowApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(430, 1200);
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
            Provider<InviteRepository>.value(value: mockInviteRepo),
            Provider<AnalyticsService>.value(value: mockAnalyticsService),
            Provider<TaskService>.value(
              value: TaskService(
                taskRepo: mockTaskRepo,
                analyticsService: mockAnalyticsService,
              ),
            ),
            Provider<ShareService>.value(value: mockShareService),
            Provider<DeepLinkService>.value(value: mockDeepLinkService),
            Provider<DisplayState>.value(
              value: DisplayState(isEnlarged: false, scale: 1.0),
            ),
          ],
          child: MaterialApp.router(routerConfig: _router()),
        ),
      ),
    );

    for (int i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Future<void> _createTaskFromS16(
    WidgetTester tester, {
    required String taskName,
    bool increaseMemberCount = false,
  }) async {
    await tester.enterText(find.byType(TextFormField).first, taskName);
    await tester.pumpAndSettle();
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    if (increaseMemberCount) {
      await tester.tap(find.byIcon(Icons.add).last);
      await tester.pumpAndSettle();
    }

    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Confirm'));
    await tester.pumpAndSettle();
  }

  group('MVP Integration - S16 Task Create Flow', () {
    testWidgets(
        'single member: should create task and navigate to S13 without invite/share',
        (tester) async {
      when(() => mockTaskRepo.createTask(any()))
          .thenAnswer((_) async => 'task-single');

      await _pumpFlowApp(tester);
      await _createTaskFromS16(tester, taskName: 'Solo Trip');

      verify(() => mockTaskRepo.createTask(any())).called(1);
      verifyNever(() => mockShareService.createInviteCode(any()));
      verifyNever(() =>
          mockShareService.shareText(any(), subject: any(named: 'subject')));

      expect(find.text('S13:task-single'), findsOneWidget);
    });

    testWidgets(
        'multi member: should create invite + share then navigate to S13',
        (tester) async {
      when(() => mockTaskRepo.createTask(any()))
          .thenAnswer((_) async => 'task-multi');
      when(() => mockShareService.createInviteCode('task-multi')).thenAnswer(
        (_) async => InviteCodeDetail(
          code: 'INV88888',
          expiresAt: DateTime(2026, 1, 2),
        ),
      );
      when(() => mockDeepLinkService.generateJoinLink('INV88888'))
          .thenReturn('https://ironsplit.app/join?code=INV88888');

      await _pumpFlowApp(tester);
      await _createTaskFromS16(
        tester,
        taskName: 'Group Trip',
        increaseMemberCount: true,
      );

      verify(() => mockTaskRepo.createTask(any())).called(1);
      verify(() => mockShareService.createInviteCode('task-multi')).called(1);

      final captured = verify(
        () => mockShareService.shareText(
          captureAny(),
          subject: captureAny(named: 'subject'),
        ),
      ).captured;

      final sharedMessage = captured[0] as String;
      final subject = captured[1] as String;

      expect(subject, 'Join Iron Split Task');
      expect(sharedMessage, contains('"Group Trip"'));
      expect(sharedMessage, contains('INV88888'));
      expect(
          sharedMessage, contains('https://ironsplit.app/join?code=INV88888'));

      expect(find.text('S13:task-multi'), findsOneWidget);
    });
  });
}
