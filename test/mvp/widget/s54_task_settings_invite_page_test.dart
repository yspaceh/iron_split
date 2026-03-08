import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/constants/remainder_rule_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/models/invite_code_model.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/core/services/analytics_service.dart';
import 'package:iron_split/core/services/brightness_service.dart';
import 'package:iron_split/core/services/deep_link_service.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/onboarding/data/invite_repository.dart';
import 'package:iron_split/features/task/application/share_service.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:iron_split/features/task/presentation/pages/s54_task_settings_invite_page.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import '../helpers/mock_analytics_service.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

class MockInviteRepository extends Mock implements InviteRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockShareService extends Mock implements ShareService {}

class MockDeepLinkService extends Mock implements DeepLinkService {}

class MockUser extends Mock implements User {}

void main() {
  late MockTaskRepository mockTaskRepo;
  late MockAuthRepository mockAuthRepo;
  late MockShareService mockShareService;
  late MockDeepLinkService mockDeepLinkService;
  late MockUser mockUser;
  late MockAnalyticsService mockAnalyticsService;
  String? copiedText;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(BrightnessService.platform,
            (MethodCall call) async {
      if (call.method == 'getBrightness') return 0.5;
      return null;
    });
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform,
            (MethodCall call) async {
      if (call.method == 'Clipboard.setData') {
        final args = call.arguments as Map<dynamic, dynamic>;
        copiedText = args['text'] as String?;
        return null;
      }
      if (call.method == 'Clipboard.getData') {
        return <String, dynamic>{'text': copiedText};
      }
      return null;
    });
  });

  tearDownAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(BrightnessService.platform, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
  });

  setUp(() {
    mockTaskRepo = MockTaskRepository();
    mockAuthRepo = MockAuthRepository();
    mockShareService = MockShareService();
    mockDeepLinkService = MockDeepLinkService();
    mockUser = MockUser();
    mockAnalyticsService = MockAnalyticsService();
    stubAnalyticsService(mockAnalyticsService);
    copiedText = null;

    when(() => mockUser.uid).thenReturn('u1');
    when(() => mockAuthRepo.currentUser).thenReturn(mockUser);

    when(() =>
            mockShareService.shareText(any(), subject: any(named: 'subject')))
        .thenAnswer((_) async {});
    when(() => mockDeepLinkService.generateJoinLink(any())).thenAnswer(
      (inv) =>
          'https://ironsplit.app/join?code=${inv.positionalArguments.first}',
    );
  });

  GoRouter _router() {
    return GoRouter(
      initialLocation: '/task/task-1/settings/invite',
      routes: [
        GoRoute(
          path: '/task/:taskId/settings/invite',
          name: 'S54',
          builder: (context, state) => S54TaskSettingsInvitePage(
            taskId: state.pathParameters['taskId']!,
          ),
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
            Provider<TaskRepository>.value(value: mockTaskRepo),
            Provider<AuthRepository>.value(value: mockAuthRepo),
            Provider<AnalyticsService>.value(value: mockAnalyticsService),
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

  group('S54TaskSettingsInvitePage widget test', () {
    testWidgets('no active invite should auto-generate new invite code',
        (tester) async {
      when(() => mockTaskRepo.streamTask('task-1')).thenAnswer(
        (_) => Stream.value(
            _task(activeInviteCode: null, activeInviteExpiresAt: null)),
      );
      when(() => mockShareService.createInviteCode('task-1')).thenAnswer(
        (_) async => InviteCodeDetail(
          code: 'ABCD1234',
          expiresAt: DateTime.now().add(const Duration(minutes: 10)),
        ),
      );

      await _pump(tester);

      verify(() => mockShareService.createInviteCode('task-1')).called(1);
      expect(find.text('ABCD 1234'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Share'), findsOneWidget);
    });

    testWidgets('tap Regenerate should request new code and update display',
        (tester) async {
      when(() => mockTaskRepo.streamTask('task-1')).thenAnswer(
        (_) => Stream.value(
          _task(
            activeInviteCode: 'WXYZ5678',
            activeInviteExpiresAt:
                DateTime.now().add(const Duration(minutes: 10)),
          ),
        ),
      );
      when(() => mockShareService.createInviteCode('task-1')).thenAnswer(
        (_) async => InviteCodeDetail(
          code: 'NEWW1234',
          expiresAt: DateTime.now().add(const Duration(minutes: 15)),
        ),
      );

      await _pump(tester);
      expect(find.text('WXYZ 5678'), findsOneWidget);

      await tester.tap(find.widgetWithText(OutlinedButton, 'Regenerate'));
      await tester.pumpAndSettle();

      verify(() => mockShareService.createInviteCode('task-1')).called(1);
      expect(find.text('NEWW 1234'), findsOneWidget);
    });

    testWidgets('tap Share should call shareText with invite code and link',
        (tester) async {
      when(() => mockTaskRepo.streamTask('task-1')).thenAnswer(
        (_) => Stream.value(
          _task(
            activeInviteCode: 'QWER9999',
            activeInviteExpiresAt:
                DateTime.now().add(const Duration(minutes: 10)),
          ),
        ),
      );

      await _pump(tester);

      await tester.tap(find.widgetWithText(FilledButton, 'Share'));
      await tester.pumpAndSettle();

      final captured = verify(
        () => mockShareService.shareText(
          captureAny(),
          subject: captureAny(named: 'subject'),
        ),
      ).captured;

      final message = captured[0] as String;
      final subject = captured[1] as String;

      expect(subject, 'Join Iron Split Task');
      expect(message, contains('QWER9999'));
      expect(message, contains('https://ironsplit.app/join?code=QWER9999'));
    });

    testWidgets('tap invite code should copy raw code to clipboard',
        (tester) async {
      when(() => mockTaskRepo.streamTask('task-1')).thenAnswer(
        (_) => Stream.value(
          _task(
            activeInviteCode: 'COPY1234',
            activeInviteExpiresAt:
                DateTime.now().add(const Duration(minutes: 10)),
          ),
        ),
      );

      await _pump(tester);

      await tester.tap(find.text('COPY 1234'));
      await tester.pumpAndSettle();

      expect(copiedText, 'COPY1234');
    });

    testWidgets('expired invite should disable share and show expired label',
        (tester) async {
      when(() => mockTaskRepo.streamTask('task-1')).thenAnswer(
        (_) => Stream.value(
          _task(
            activeInviteCode: 'TIME1234',
            activeInviteExpiresAt:
                DateTime.now().add(const Duration(seconds: 1)),
          ),
        ),
      );

      await _pump(tester);
      await tester.pump(const Duration(seconds: 2));

      expect(find.text('Invite code has expired'), findsOneWidget);
      final shareButton = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Share'),
      );
      expect(shareButton.onPressed, isNull);
    });
  });
}

TaskModel _task({
  required String? activeInviteCode,
  required DateTime? activeInviteExpiresAt,
}) {
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
    },
    memberIds: const ['u1'],
    status: TaskStatus.ongoing,
    createdBy: 'u1',
    remainderRule: RemainderRuleConstants.member,
    createdAt: now,
    updatedAt: now,
    activeInviteCode: activeInviteCode,
    activeInviteExpiresAt: activeInviteExpiresAt,
  );
}
