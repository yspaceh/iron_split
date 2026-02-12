import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/features/system/presentation/pages/s72_terms_update_page.dart';
import 'package:iron_split/features/system/presentation/pages/s73_system_settings_payment_info_page.dart';
import 'package:iron_split/features/system/presentation/pages/s74_delete_account_notice_page.dart';
import 'package:iron_split/features/task/presentation/pages/s14_task_settings_page.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/services/deep_link_service.dart';
import 'package:iron_split/core/models/record_model.dart';

// System
import 'package:iron_split/features/system/presentation/pages/s00_system_bootstrap_page.dart';
import 'package:iron_split/features/system/presentation/pages/s70_system_settings_page.dart';
import 'package:iron_split/features/system/presentation/pages/s71_system_settings_terms_page.dart';

// Auth
import 'package:iron_split/features/onboarding/presentation/pages/s50_onboarding_consent_page.dart';
import 'package:iron_split/features/onboarding/presentation/pages/s51_onboarding_name_page.dart';

// Home / Task List
import 'package:iron_split/features/task/presentation/pages/s10_home_task_list_page.dart';

// Task Create
import 'package:iron_split/features/task/presentation/pages/s16_task_create_edit_page.dart';

// Invite
import 'package:iron_split/features/onboarding/presentation/pages/s11_invite_confirm_page.dart';

// Task Dashboard & Sub-pages
import 'package:iron_split/features/task/presentation/pages/s13_task_dashboard_page.dart';
import 'package:iron_split/features/task/presentation/pages/s17_task_locked_page.dart';
import 'package:iron_split/features/task/presentation/pages/s53_task_settings_members_page.dart';
import 'package:iron_split/features/task/presentation/pages/s52_task_settings_log_page.dart';
import 'package:iron_split/features/task/presentation/pages/s12_task_close_notice_page.dart';
import 'package:iron_split/features/record/presentation/pages/s15_record_edit_page.dart';

// Settlement
import 'package:iron_split/features/settlement/presentation/pages/s30_settlement_confirm_page.dart';
import 'package:iron_split/features/settlement/presentation/pages/s31_settlement_payment_info_page.dart';
import 'package:iron_split/features/settlement/presentation/pages/s32_settlement_result_page.dart';

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
      // S00_System.Bootstrap
      GoRoute(
        path: '/',
        name: 'S00',
        builder: (context, state) => const S00SystemBootstrapPage(),
      ),

      // S50_Onboarding.Consent
      GoRoute(
        path: '/onboarding/consent',
        name: 'S50',
        builder: (context, state) => const S50OnboardingConsentPage(),
      ),

      // S51_Onboarding.Name
      GoRoute(
        path: '/onboarding/name',
        name: 'S51',
        builder: (context, state) => const S51OnboardingNamePage(),
      ),

      // S10_Home.TaskList (Landing)
      GoRoute(
        path: '/tasks',
        name: 'S10',
        builder: (context, state) => const S10HomeTaskListPage(),
      ),

      // S16_TaskCreate.Edit
      GoRoute(
        path: '/tasks/create',
        name: 'S16',
        builder: (context, state) => const S16TaskCreateEditPage(),
      ),

      // S17_Task.Locked
      GoRoute(
        path: '/locked/:taskId',
        name: 'S17',
        builder: (context, state) {
          final taskId = state.pathParameters['taskId']!;
          return S17TaskLockedPage(taskId: taskId);
        },
      ),

      // S11_Invite.Confirm
      GoRoute(
        path: '/invite/confirm',
        name: 'S11',
        builder: (context, state) {
          final code = state.uri.queryParameters['code'] ?? '';
          return S11InviteConfirmPage(inviteCode: code);
        },
      ),

      // S13_Task.Dashboard (Dynamic :taskId)
      GoRoute(
        path: '/tasks/:taskId',
        name: 'S13',
        builder: (context, state) {
          final taskId = state.pathParameters['taskId']!;
          return S13TaskDashboardPage(taskId: taskId);
        },
        routes: [
          // S14_Task.Settings
          GoRoute(
            path: 'settings', // Full: /task/:taskId/settings
            name: 'S14',
            builder: (context, state) {
              final taskId = state.pathParameters['taskId']!;
              return S14TaskSettingsPage(taskId: taskId);
            },
            routes: [
              // S53_TaskSettings.Members
              GoRoute(
                path: 'members', // Full: /task/:taskId/settings/members
                name: 'S53',
                builder: (context, state) {
                  final taskId = state.pathParameters['taskId']!;
                  return S53TaskSettingsMembersPage(taskId: taskId);
                },
              ),
              // S52_TaskSettings.Log
              GoRoute(
                path: 'log', // full path: /tasks/:taskId/settings/log
                name: 'S52',
                builder: (context, state) {
                  final taskId = state.pathParameters['taskId']!;
                  // Retrieve complex data passed via 'extra'
                  final membersData =
                      state.extra as Map<String, dynamic>? ?? {};

                  return S52TaskSettingsLogPage(
                      taskId: taskId, membersData: membersData);
                },
              ),
              // S12_TaskClose.Notice
              GoRoute(
                path: 'close', // Full: /task/:taskId/settings/close
                name: 'S12',
                builder: (context, state) {
                  final taskId = state.pathParameters['taskId']!;
                  return S12TaskCloseNoticePage(taskId: taskId);
                },
              ),
            ],
          ),
          // S15_Record.Edit
          GoRoute(
            path: 'record', // Full: /task/:taskId/record
            name: 'S15',
            builder: (context, state) {
              final taskId = state.pathParameters['taskId']!;
              final recordId = state.uri.queryParameters['recordId'] ??
                  state.uri.queryParameters['id'];
              final extra = state.extra as Map<String, dynamic>? ?? {};
              final poolBalancesByCurrency =
                  extra['poolBalancesByCurrency'] as Map<String, double>? ?? {};
              final record = extra['record'] as RecordModel?;
              final date = extra['date'] as DateTime?;
              final baseCurrency =
                  extra['baseCurrency'] as CurrencyConstants? ??
                      CurrencyConstants.defaultCurrencyConstants;

              return S15RecordEditPage(
                taskId: taskId,
                recordId: recordId,
                record: record,
                poolBalancesByCurrency: poolBalancesByCurrency,
                baseCurrency: baseCurrency,
                initialDate: date,
              );
            },
          ),
          // S30_Settlement.Confirm
          GoRoute(
              path:
                  'settlement/preview', // Full: /task/:taskId/settlement/preview
              name: 'S30',
              builder: (context, state) {
                final taskId = state.pathParameters['taskId']!;
                return S30SettlementConfirmPage(taskId: taskId);
              },
              routes: [
                // S31_Settlement.PaymentInfo
                GoRoute(
                  path:
                      'settlement/payment', // Full: /task/:taskId/settlement/payment
                  name: 'S31',
                  builder: (context, state) {
                    final taskId = state.pathParameters['taskId']!;
                    final extra = state.extra as Map<String, dynamic>? ?? {};
                    final checkPointPoolBalance =
                        extra['checkPointPoolBalance'] as double;
                    final mergeMap =
                        extra['mergeMap'] as Map<String, List<String>>;
                    return S31SettlementPaymentInfoPage(
                        taskId: taskId,
                        checkPointPoolBalance: checkPointPoolBalance,
                        mergeMap: mergeMap);
                  },
                ),
              ]),
          // S32_Settlement.Result
          GoRoute(
            path: 'settlement/result', // Full: /task/:taskId/settlement/result
            name: 'S32',
            builder: (context, state) {
              final taskId = state.pathParameters['taskId']!;
              return S32SettlementResultPage(taskId: taskId);
            },
          ),
        ],
      ),

      // S70_System.Settings
      GoRoute(
        path: '/settings',
        name: 'S70',
        builder: (context, state) => const S70SystemSettingsPage(),
        routes: [
          // S71_SystemSettings.Terms`
          GoRoute(
            path: 'terms', // Full: /settings/terms
            name: 'S71',
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>? ?? {};
              final isTerms = extra['isTerms'] as bool?;
              return S71SettingsTermsPage(isTerms: isTerms ?? true);
            },
          ),
          // S73_System.PaymentInfo`
          GoRoute(
            path: 'payment-info', // Full: /settings/payment-info
            name: 'S73',
            builder: (context, state) {
              return S73SystemSettingsPaymentInfoPage();
            },
          ),
          // S73_DeleteAccount_Notice`
          GoRoute(
            path: 'delete-account',
            name: 'S74',
            builder: (context, state) {
              return S74DeleteAccountNoticePage();
            },
          ),
        ],
      ),
      GoRoute(
        path: '/terms-update',
        name: 'S72',
        builder: (context, state) {
          return S72TermsUpdatePage();
        },
      ),
    ],
  );
}
