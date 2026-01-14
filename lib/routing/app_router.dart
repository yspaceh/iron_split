import 'package:go_router/go_router.dart';
import '../pages/splash_screen.dart';
import '../pages/confirm_invite_page.dart'; // p7 頁面

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/splash',
    routes: [
        GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
        // p7: 邀請確認頁面
        GoRoute(
        path: '/invite/confirm',
        builder: (context, state) {
            final code = state.uri.queryParameters['code'];
            return ConfirmInvitePage(code: code); 
        },
        ),
        // 結算頁面
        GoRoute(
        path: '/tasks/:taskId/settlement',
        builder: (context, state) {
            final taskId = state.pathParameters['taskId']!;
            return SettlementPage(taskId: taskId);
        },
        ),
    ],
  );
}