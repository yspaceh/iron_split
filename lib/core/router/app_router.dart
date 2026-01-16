import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/services/deep_link_service.dart';
import 'package:iron_split/features/common/presentation/pages/s_system_bootstrap_page.dart';
import 'package:iron_split/features/auth/presentation/pages/s00_onboarding_consent_page.dart';
import 'package:iron_split/features/auth/presentation/pages/s01_onboarding_name_page.dart';
import 'package:iron_split/features/task/presentation/pages/s02_home_task_list_page.dart';
import 'package:iron_split/features/invite/presentation/pages/s04_invite_confirm_page.dart';
import 'package:iron_split/features/common/presentation/pages/s19_settings_tos_page.dart';
import 'package:iron_split/features/task/presentation/pages/s05_task_create_form_page.dart';

/// Page Key System: Sxx
class AppRouter {
  final DeepLinkService deepLinkService;

  AppRouter(this.deepLinkService);

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  late final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      // S_System.Bootstrap: 啟動決策
      GoRoute(
        path: '/',
        name: 'Bootstrap',
        builder: (context, state) => const SSystemBootstrapPage(),
      ),

      // S00: 同意頁
      GoRoute(
        path: '/tos-consent',
        name: 'S00',
        builder: (context, state) => const S00OnboardingConsentPage(),
      ),

      // S01: 設定名稱
      GoRoute(
        path: '/onboarding/name',
        name: 'S01',
        builder: (context, state) => const S01OnboardingNamePage(),
      ),

      // S02: 任務列表首頁 (包含子路由)
      GoRoute(
        path: '/tasks',
        name: 'S02',
        builder: (context, state) => const S02HomeTaskListPage(),
        routes: [
          // S05: 建立新任務 (路徑: /tasks/create)
          GoRoute(
            path: 'create',
            name: 'S05',
            builder: (context, state) => const S05TaskCreateFormPage(),
          ),

          // ✅ S12/S17: 任務儀表板 (路徑: /tasks/:taskId)
          // 這是 S02 點擊卡片與 S05 建立完成後會去的地方
          GoRoute(
            path: ':taskId',
            name: 'TaskDashboard',
            builder: (context, state) {
              final taskId = state.pathParameters['taskId']!;
              // TODO: 未來請替換成真實的 S12TaskDashboardPage(taskId: taskId)
              return Scaffold(
                appBar: AppBar(title: Text('Task Dashboard: $taskId')),
                body: const Center(
                    child: Text('TODO: Implement Dashboard (S12/S17)')),
              );
            },
          ),
        ],
      ),

      // S04: 邀請確認頁
      GoRoute(
        path: '/invite/confirm',
        name: 'S04',
        builder: (context, state) {
          final code = state.uri.queryParameters['code'] ?? '';
          return S04InviteConfirmPage(inviteCode: code);
        },
      ),

      // S19: 服務條款
      GoRoute(
        path: '/settings/tos',
        name: 'S19',
        builder: (context, state) => const S19SettingsTosPage(),
      ),
    ],
  );
}
