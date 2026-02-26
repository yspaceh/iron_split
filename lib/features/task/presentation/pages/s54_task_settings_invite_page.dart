import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/services/deep_link_service.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/common/presentation/view/common_state_view.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/app_toast.dart';
import 'package:iron_split/features/common/presentation/widgets/share_loading.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/onboarding/data/invite_repository.dart';
import 'package:iron_split/features/task/application/share_service.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:iron_split/features/task/presentation/viewmodels/s54_task_settings_invite_vm.dart';
import 'package:iron_split/features/task/presentation/widgets/qr_code.dart';
import 'package:provider/provider.dart';
import 'package:iron_split/gen/strings.g.dart';

class S54TaskSettingsInvitePage extends StatelessWidget {
  final String taskId;

  const S54TaskSettingsInvitePage({
    super.key,
    required this.taskId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => S54TaskSettingsInviteViewModel(
        taskId: taskId,
        taskRepo: context.read<TaskRepository>(),
        inviteRepo: context.read<InviteRepository>(),
        authRepo: context.read<AuthRepository>(),
        shareService: context.read<ShareService>(),
        deepLinkService: context.read<DeepLinkService>(),
      )..init(),
      child: const _S54Content(),
    );
  }
}

class _S54Content extends StatelessWidget {
  const _S54Content();

  Future<void> _handleShare(BuildContext context,
      S54TaskSettingsInviteViewModel vm, Translations t) async {
    try {
      final message = t.common.share.invite.content(
        taskName: vm.taskName,
        code: vm.inviteCode,
        link: vm.link,
      );
      // 2. 委派 VM 執行
      await vm.notifyMembers(
        message: message,
        subject: t.common.share.invite.subject,
      );
    } on AppErrorCodes catch (code) {
      if (!context.mounted) return;
      final msg = ErrorMapper.map(context, code: code);
      AppToast.showError(context, msg);
    }
  }

  void _handleCopy(
      BuildContext context, S54TaskSettingsInviteViewModel vm, Translations t) {
    if (vm.isExpired) return;
    vm.copyToClipboard();
    AppToast.showSuccess(context, t.success.copied);
  }

  // --- UI Build ---
  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final vm = context.watch<S54TaskSettingsInviteViewModel>();
    final isEnlarged = context.watch<DisplayState>().isEnlarged;
    final double iconSize = AppLayout.inlineIconSize(isEnlarged);
    final double horizontalMargin = AppLayout.pageMargin(isEnlarged);
    final title = t.S54_TaskSettings_Invite.title;

    return CommonStateView(
      status: vm.initStatus,
      errorCode: vm.initErrorCode,
      title: title,
      child: Stack(
        children: [
          Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text(title),
              centerTitle: true,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                    horizontal: horizontalMargin, vertical: AppLayout.spaceM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // --- 邀請碼文字與複製按鈕 ---
                    InkWell(
                      onTap: vm.isExpired
                          ? null
                          : () => _handleCopy(context, vm, t),
                      borderRadius: BorderRadius.circular(AppLayout.radiusM),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.center,
                              child: Text(
                                vm.displayInviteCode,
                                style: textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 2.0,
                                  color: vm.isExpired
                                      ? colorScheme.onSurface
                                          .withValues(alpha: 0.1)
                                      : colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                          if (!vm.isExpired) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppLayout.spaceM),
                              child: Icon(Icons.copy, size: iconSize),
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: AppLayout.spaceM),
                    // --- 倒數計時器 ---
                    if (!vm.isExpired) ...[
                      Text(
                        vm.formattedTimer,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ] else ...[
                      const SizedBox(height: AppLayout.spaceXL),
                    ],

                    const SizedBox(height: AppLayout.spaceM),

                    // --- QR Code 區塊 ---
                    QrCode(
                      link: vm.link,
                      isExpired: vm.isExpired,
                    ),
                    const SizedBox(height: AppLayout.spaceL),
                  ],
                ),
              ),
            ),
            extendBody: true,
            bottomNavigationBar: StickyBottomActionBar(
              isSheetMode: false,
              children: [
                AppButton(
                  text: t.S54_TaskSettings_Invite.buttons.regenerate,
                  type: AppButtonType.secondary,
                  isLoading: vm.generateStatus == LoadStatus.loading,
                  onPressed: () => vm.generateNewInviteCode(),
                ),
                AppButton(
                  text: t.S54_TaskSettings_Invite.buttons.share,
                  type: AppButtonType.primary,
                  onPressed: vm.isExpired || vm.initStatus != LoadStatus.success
                      ? null
                      : () => _handleShare(context, vm, t),
                ),
              ],
            ),
          ),
          if (vm.generateStatus == LoadStatus.loading) SharePreparing(),
        ],
      ),
    );
  }
}
