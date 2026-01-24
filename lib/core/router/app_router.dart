import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/services/deep_link_service.dart';
// System
import 'package:iron_split/features/system/presentation/pages/s00_system_bootstrap_page.dart';
import 'package:iron_split/features/system/presentation/pages/s70_system_settings_page.dart';
import 'package:iron_split/features/system/presentation/pages/s71_system_settings_tos_page.dart'
    show S71SettingsTosPage;
// Auth
import 'package:iron_split/features/auth/presentation/screens/s50_onboarding_consent_page.dart';
import 'package:iron_split/features/auth/presentation/screens/s51_onboarding_name_page.dart';
// Home
import 'package:iron_split/features/task/presentation/pages/s10_home_task_list_page.dart';
// Task
import 'package:iron_split/features/task/presentation/pages/s13_task_dashboard_page.dart';
import 'package:iron_split/features/task/presentation/pages/s14_task_settings_page.dart';
import 'package:iron_split/features/task/presentation/pages/s15_record_edit_page.dart';
import 'package:iron_split/features/task/presentation/pages/s16_task_create_edit_page.dart';
import 'package:iron_split/features/task/presentation/pages/s12_task_close_notice_page.dart';
import 'package:iron_split/features/task/presentation/pages/s52_task_settings_log_page.dart';
import 'package:iron_split/features/task/presentation/pages/s53_task_settings_members_page.dart';
// Settlement
import 'package:iron_split/features/settlement/presentation/pages/s30_settlement_confirm_page.dart';
import 'package:iron_split/features/settlement/presentation/pages/s31_settlement_payment_info_page.dart';
import 'package:iron_split/features/settlement/presentation/pages/s32_settlement_result_page.dart';
// Invite
import 'package:iron_split/features/invite/presentation/pages/s11_invite_confirm_page.dart';

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
      // S00_System.Bootstrap: 啟動決策
      GoRoute(
        path: '/',
        name: 'S00',
        builder: (context, state) => const S00SystemBootstrapPage(),
      ),

      // S50_Onboarding.Consent: 同意頁
      GoRoute(
        path: '/tos-consent',
        name: 'S50',
        builder: (context, state) => const S50OnboardingConsentPage(),
      ),

      // S51_Onboarding.Name: 設定名稱
      GoRoute(
        path: '/onboarding/name',
        name: 'S51',
        builder: (context, state) => const S51OnboardingNamePage(),
      ),

      // S10_Home.TaskList: 任務列表首頁 (包含子路由)
      GoRoute(
        path: '/tasks',
        name: 'S10',
        builder: (context, state) => const S10HomeTaskListPage(),
        routes: [
          // S16_TaskCreate.Edit: 建立新任務 (路徑: /tasks/create)
          GoRoute(
            path: 'create',
            name: 'S16',
            builder: (context, state) => const S16TaskCreateEditPage(),
          ),
          // S13_Task.Dashboard: 任務儀表板
          GoRoute(
            path: ':taskId',
            name: 'S13',
            builder: (context, state) {
              final taskId = state.pathParameters['taskId']!;
              return S13TaskDashboardPage(taskId: taskId);
            },
            routes: [
              // S15_Record.Edit: 紀錄編輯 (完整路徑: /tasks/:taskId/record)
              GoRoute(
                path: 'record',
                name: 'S15',
                builder: (context, state) {
                  final taskId = state.pathParameters['taskId']!;
                  final recordId = state.uri.queryParameters['id'];
                  return S15RecordEditPage(taskId: taskId, recordId: recordId);
                },
              ),
              // S14_Task.Settings: 任務設定
              GoRoute(
                path: 'settings',
                name: 'S14',
                builder: (context, state) {
                  // taskId available via state.pathParameters['taskId'] (for future use)
                  return const S14TaskSettingsPage();
                },
                routes: [
                  // S52_TaskSettings.Log: 歷史紀錄
                  GoRoute(
                    path: 'log',
                    name: 'S52',
                    builder: (context, state) {
                      // taskId available via state.pathParameters['taskId']
                      return const S52TaskSettingsLogPage();
                    },
                  ),
                  // S53_TaskSettings.Members: 成員設定
                  GoRoute(
                    path: 'members',
                    name: 'S53',
                    builder: (context, state) {
                      // taskId available via state.pathParameters['taskId']
                      return const S53TaskSettingsMembersPage();
                    },
                  ),
                ],
              ),
              // S12_TaskClose.Notice: 結束任務
              GoRoute(
                path: 'close',
                name: 'S12',
                builder: (context, state) {
                  // taskId available via state.pathParameters['taskId']
                  return const S12TaskCloseNoticePage();
                },
              ),
            ],
          ),
        ],
      ),

      // S11_Invite.Confirm: 邀請確認頁
      GoRoute(
        path: '/invite/confirm',
        name: 'S11',
        builder: (context, state) {
          final code = state.uri.queryParameters['code'] ?? '';
          return S11InviteConfirmPage(inviteCode: code);
        },
      ),

      // S30_Settlement.Confirm: 結算確認
      GoRoute(
        path: '/settlement/confirm',
        name: 'S30',
        builder: (context, state) {
          // taskId available via state.uri.queryParameters['taskId']
          return const S30SettlementConfirmPage();
        },
      ),

      // S31_Settlement.PaymentInfo: 結算收款資訊
      GoRoute(
        path: '/settlement/payment-info',
        name: 'S31',
        builder: (context, state) {
          // taskId available via state.uri.queryParameters['taskId']
          return const S31SettlementPaymentInfoPage();
        },
      ),

      // S32_Settlement.Result: 結算結果
      GoRoute(
        path: '/settlement/result',
        name: 'S32',
        builder: (context, state) {
          // taskId available via state.uri.queryParameters['taskId']
          return const S32SettlementResultPage();
        },
      ),

      // S70_System.Settings: 系統設定
      GoRoute(
        path: '/settings',
        name: 'S70',
        builder: (context, state) => const S70SystemSettingsPage(),
        routes: [
          // S71_SystemSettings.Tos: 服務條款
          GoRoute(
            path: 'tos',
            name: 'S71',
            builder: (context, state) => const S71SettingsTosPage(),
          ),
        ],
      ),
    ],
  );
}
