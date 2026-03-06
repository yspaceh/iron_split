import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/models/invite_code_model.dart';
import 'package:iron_split/core/services/deep_link_service.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/onboarding/data/invite_repository.dart';
import 'package:iron_split/features/task/application/share_service.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:iron_split/features/task/presentation/pages/s16_task_create_edit_page.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockInviteRepository extends Mock implements InviteRepository {}

class MockShareService extends Mock implements ShareService {}

class MockDeepLinkService extends Mock implements DeepLinkService {}

class MockUser extends Mock implements User {}

void main() {
  late MockTaskRepository mockTaskRepo;
  late MockAuthRepository mockAuthRepo;
  late MockInviteRepository mockInviteRepo;
  late MockShareService mockShareService;
  late MockDeepLinkService mockDeepLinkService;
  late MockUser mockUser;

  setUp(() {
    mockTaskRepo = MockTaskRepository();
    mockAuthRepo = MockAuthRepository();
    mockInviteRepo = MockInviteRepository();
    mockShareService = MockShareService();
    mockDeepLinkService = MockDeepLinkService();
    mockUser = MockUser();

    when(() => mockUser.uid).thenReturn('u1');
    when(() => mockUser.displayName).thenReturn('Captain');
    when(() => mockAuthRepo.currentUser).thenReturn(mockUser);

    when(() => mockTaskRepo.createTask(any())).thenAnswer((_) async => 'task-1');

    when(() => mockInviteRepo.createInviteCode('task-1')).thenAnswer(
      (_) async => InviteCodeDetail(
        code: 'INV12345',
        expiresAt: DateTime(2026, 1, 2),
      ),
    );

    when(() => mockDeepLinkService.generateJoinLink('INV12345'))
        .thenReturn('https://ironsplit.app/join?code=INV12345');

    when(() => mockShareService.shareText(any(), subject: any(named: 'subject')))
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
          builder: (context, state) => Text('S13:${state.pathParameters['taskId']}'),
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
            Provider<AuthRepository>.value(value: mockAuthRepo),
            Provider<InviteRepository>.value(value: mockInviteRepo),
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

  group('S16TaskCreateEditPage widget test', () {
    testWidgets('多人建立成功：createInviteCode + share 後導向 S13', (tester) async {
      await _pump(tester);

      await tester.enterText(find.byType(TextFormField).first, 'Trip 2026');
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(FilledButton, 'Save'));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(FilledButton, 'Confirm'));
      await tester.pumpAndSettle();

      verify(() => mockTaskRepo.createTask(any())).called(1);
      verify(() => mockInviteRepo.createInviteCode('task-1')).called(1);

      final captured = verify(
        () => mockShareService.shareText(
          captureAny(),
          subject: captureAny(named: 'subject'),
        ),
      ).captured;

      final message = captured[0] as String;
      final subject = captured[1] as String;

      expect(subject, 'Join Iron Split Task');
      expect(message, contains('"Trip 2026"'));
      expect(message, contains('INV12345'));
      expect(message, contains('https://ironsplit.app/join?code=INV12345'));

      expect(find.text('S13:task-1'), findsOneWidget);
    });
  });
}
