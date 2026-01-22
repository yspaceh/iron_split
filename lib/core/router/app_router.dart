import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/services/deep_link_service.dart';
import 'package:iron_split/features/task/presentation/pages/s13_task_dashboard_page.dart';
import 'package:iron_split/features/task/presentation/pages/s15_record_edit_page.dart';
import 'package:iron_split/features/common/presentation/pages/s00_system_bootstrap_page.dart';
import 'package:iron_split/features/auth/presentation/pages/s50_onboarding_consent_page.dart';
import 'package:iron_split/features/auth/presentation/pages/s51_onboarding_name_page.dart';
import 'package:iron_split/features/task/presentation/pages/s10_home_task_list_page.dart';
import 'package:iron_split/features/invite/presentation/pages/s11_invite_confirm_page.dart';
import 'package:iron_split/features/common/presentation/pages/s71_settings_tos_page.dart';
import 'package:iron_split/features/task/presentation/pages/s16_task_create_edit_page.dart';

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
        name: 'S00',
        builder: (context, state) => const S00SystemBootstrapPage(),
      ),

      // S00: 同意頁
      GoRoute(
        path: '/tos-consent',
        name: 'S50',
        builder: (context, state) => const S50OnboardingConsentPage(),
      ),

      // S01: 設定名稱
      GoRoute(
        path: '/onboarding/name',
        name: 'S51',
        builder: (context, state) => const S51OnboardingNamePage(),
      ),

      // S02: 任務列表首頁 (包含子路由)
      GoRoute(
        path: '/tasks',
        name: 'S10',
        builder: (context, state) => const S10HomeTaskListPage(),
        routes: [
          // S05: 建立新任務 (路徑: /tasks/create)
          GoRoute(
            path: 'create',
            name: 'S16',
            builder: (context, state) => const S16TaskCreateEditPage(),
          ),
          // S06: 任務儀表板
          GoRoute(
            path: ':taskId',
            name: 'S13',
            builder: (context, state) {
              final taskId = state.pathParameters['taskId']!;
              return S13TaskDashboardPage(taskId: taskId);
            },
            routes: [
              GoRoute(
                path: 'record', // 完整路徑: /tasks/:taskId/record
                name: 'S15',
                builder: (context, state) {
                  final taskId = state.pathParameters['taskId']!;
                  final recordId = state.uri.queryParameters['id'];
                  return S15RecordEditPage(taskId: taskId, recordId: recordId);
                },
              ),
            ],
          ),
        ],
      ),

      // S04: 邀請確認頁
      GoRoute(
        path: '/invite/confirm',
        name: 'S11',
        builder: (context, state) {
          final code = state.uri.queryParameters['code'] ?? '';
          return S11InviteConfirmPage(inviteCode: code);
        },
      ),

      // S19: 服務條款
      GoRoute(
        path: '/settings/tos',
        name: 'S71',
        builder: (context, state) => const S71SettingsTosPage(),
      ),
    ],
  );
}
