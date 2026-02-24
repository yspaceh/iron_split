import 'package:flutter/material.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/theme/app_theme.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/core/utils/split_ratio_helper.dart';
import 'package:iron_split/features/common/presentation/dialogs/common_info_dialog.dart';
import 'package:iron_split/features/common/presentation/view/common_state_view.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/app_stepper.dart'; //
import 'package:iron_split/features/common/presentation/widgets/app_toast.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar.dart'; //
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/record/data/record_repository.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:iron_split/features/task/presentation/dialogs/d07_rename_member_dialog.dart';
import 'package:provider/provider.dart';
import 'package:iron_split/features/task/presentation/viewmodels/s53_task_settings_members_vm.dart';
import 'package:iron_split/gen/strings.g.dart';

class S53TaskSettingsMembersPage extends StatelessWidget {
  final String taskId;

  const S53TaskSettingsMembersPage({
    super.key,
    required this.taskId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => S53TaskSettingsMembersViewModel(
        taskId: taskId,
        taskRepo: context.read<TaskRepository>(),
        recordRepo: context.read<RecordRepository>(),
        authRepo: context.read<AuthRepository>(),
      )..init(),
      child: const _S53Content(),
    );
  }
}

class _S53Content extends StatelessWidget {
  const _S53Content();

  // --- Logic Helpers ---
  void _showRenameDialog(BuildContext context,
      S53TaskSettingsMembersViewModel vm, String memberId, String currentName) {
    D07RenameMemberDialog.show(context, initialName: currentName,
        onConfirm: (newName) {
      vm.renameMember(memberId, newName);
    });
  }

  Future<void> _handleDelete(
      BuildContext context,
      S53TaskSettingsMembersViewModel vm,
      Translations t,
      String memberId) async {
    try {
      await vm.deleteMember(memberId);
    } on AppErrorCodes {
      if (!context.mounted) return;
      CommonInfoDialog.show(
        context,
        title: t.error.dialog.member_delete_failed.title,
        content: t.error.dialog.member_delete_failed.content,
      );
    }
  }

  Future<void> _handleAdd(
      BuildContext context, S53TaskSettingsMembersViewModel vm) async {
    try {
      await vm.addMember();
    } on AppErrorCodes catch (code) {
      if (!context.mounted) return;
      final msg = ErrorMapper.map(context, code: code);
      AppToast.showError(context, msg);
    }
  }

  Future<void> _handleIncreaseRatio(
      BuildContext context,
      S53TaskSettingsMembersViewModel vm,
      String memberId,
      double currentRatio) async {
    try {
      await vm.updateRatio(
        memberId,
        SplitRatioHelper.increase(currentRatio), // 這裡！
      );
    } on AppErrorCodes catch (code) {
      if (!context.mounted) return;
      final msg = ErrorMapper.map(context, code: code);
      AppToast.showError(context, msg);
    }
  }

  Future<void> _handleDecreaseRatio(
      BuildContext context,
      S53TaskSettingsMembersViewModel vm,
      String memberId,
      double currentRatio) async {
    try {
      await vm.updateRatio(
        memberId,
        SplitRatioHelper.decrease(currentRatio), // 這裡！
      );
    } on AppErrorCodes catch (code) {
      if (!context.mounted) return;
      final msg = ErrorMapper.map(context, code: code);
      AppToast.showError(context, msg);
    }
  }

  // --- UI Build ---
  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final vm = context.watch<S53TaskSettingsMembersViewModel>();
    final title = t.S53_TaskSettings_Members.title;

    return CommonStateView(
      status: vm.initStatus,
      errorCode: vm.initErrorCode,
      title: title,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(title),
          centerTitle: true,
        ),
        body: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          itemCount: vm.membersList.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final entry = vm.membersList[index];
            final memberId = entry.key;
            final memberData = entry.value;
            final bool isOwner = (memberId == vm.createdBy);
            final bool amICaptain = (vm.currentUserId == vm.createdBy);

            final isLinked = memberData.isLinked;

            // 取得目前權重，預設 1.0 (注意這裡要處理 dynamic -> double 的轉型安全)
            // 舊資料的 defaultSplitRatio 可能不存在
            final rawRatio = memberData.defaultSplitRatio;
            final double currentRatio = (rawRatio as num).toDouble();

            // [核心] 成員卡片
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: colorScheme.surface, // 白色卡片
                borderRadius: BorderRadius.circular(16), // 圓角 16
                // 可選：加上淡淡的陰影增加層次感，或者保持平面
              ),
              child: Row(
                children: [
                  CommonAvatar(
                    avatarId: memberData.avatar,
                    name: memberData.displayName,
                    isLinked: memberData.isLinked,
                    radius: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Row(
                            children: [
                              Text(
                                memberData.displayName,
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onSurface,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (isOwner) ...[
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.star, // 或 star_rounded
                                  size: 22,
                                  color: AppTheme.starGold,
                                ),
                              ],
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            if (amICaptain && !isOwner) ...[
                              InkWell(
                                onTap: () =>
                                    _handleDelete(context, vm, t, memberId),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Icon(
                                    Icons.delete_outline,
                                    color: colorScheme.error,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                            if (!isLinked) ...[
                              const SizedBox(width: 8),
                              Container(
                                width: 1,
                                height: 20, // 不用撐滿，短一點比較精緻
                                color: colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.2), // 與頭像的距離
                              ),
                              const SizedBox(width: 8),
                              InkWell(
                                onTap: () => _showRenameDialog(context, vm,
                                    memberId, memberData.displayName),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Icon(
                                    Icons.edit,
                                    color: colorScheme.onSurface,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                            const Spacer(),
                            AppStepper(
                              text: SplitRatioHelper.format(currentRatio),
                              onDecrease: vm.updateStatus == LoadStatus.loading
                                  ? null
                                  : () => _handleDecreaseRatio(
                                      context, vm, memberId, currentRatio),
                              onIncrease: vm.updateStatus == LoadStatus.loading
                                  ? null
                                  : () => _handleIncreaseRatio(
                                        context,
                                        vm,
                                        memberId,
                                        currentRatio,
                                      ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        extendBody: true,
        bottomNavigationBar: StickyBottomActionBar(
          isSheetMode: false,
          children: [
            AppButton(
              text: t.S53_TaskSettings_Members.buttons.add_member,
              type: AppButtonType.primary,
              isLoading: vm.addMemberStatus == LoadStatus.loading,
              onPressed: () => _handleAdd(context, vm),
            ),
          ],
        ),
      ),
    );
  }
}
