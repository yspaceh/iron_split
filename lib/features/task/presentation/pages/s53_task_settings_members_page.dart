import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/core/theme/app_theme.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/core/utils/split_ratio_helper.dart';
import 'package:iron_split/features/common/presentation/dialogs/common_alert_dialog.dart';
import 'package:iron_split/features/common/presentation/dialogs/common_info_dialog.dart';
import 'package:iron_split/features/common/presentation/view/common_state_view.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/app_stepper.dart'; // [新增]
import 'package:iron_split/features/common/presentation/widgets/common_avatar.dart'; // [新增]
import 'package:iron_split/features/common/presentation/widgets/form/task_name_input.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:iron_split/features/record/data/record_repository.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
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
      ),
      child: const _S53Content(),
    );
  }
}

class _S53Content extends StatelessWidget {
  const _S53Content();

  // --- Logic Helpers ---

  void _showRenameDialog(
      BuildContext context,
      S53TaskSettingsMembersViewModel vm,
      Map<String, dynamic> membersMap,
      String memberId,
      String currentName) {
    showDialog(
      context: context,
      builder: (context) => _RenameMemberDialog(
        initialName: currentName,
        onConfirm: (newName) {
          vm.renameMember(membersMap, memberId, newName);
        },
      ),
    );
  }

  Future<void> _handleDelete(
      BuildContext context,
      S53TaskSettingsMembersViewModel vm,
      Map<String, dynamic> membersMap,
      String memberId) async {
    final t = Translations.of(context);
    final success = await vm.deleteMember(membersMap, memberId);

    if (!success && context.mounted) {
      CommonInfoDialog.show(
        context,
        title: t.error.dialog.member_delete_failed.title,
        content: t.error.dialog.member_delete_failed.message,
      );
    }
  }

  // 權重調整邏輯
  void _updateRatio(
    S53TaskSettingsMembersViewModel vm,
    Map<String, dynamic> membersMap,
    String memberId,
    double newRatio, // 直接傳入算好的值
  ) {
    // 這裡只負責呼叫 VM 更新，數學計算交給 Helper 做了
    vm.updateRatio(membersMap, memberId, newRatio);
  }

  // --- UI Build ---

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final vm = context.watch<S53TaskSettingsMembersViewModel>();

    return StreamBuilder<TaskModel?>(
      stream: vm.taskStream,
      builder: (context, snapshot) {
        // Error State
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text(t.S53_TaskSettings_Members.title)),
            body: CommonStateView(
              message: ErrorMapper.map(context, snapshot.error),
            ),
            bottomNavigationBar: StickyBottomActionBar(
              children: [
                AppButton(
                  text: t.common.buttons.retry,
                  type: AppButtonType.primary,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          );
        }
        // Loading State
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: Text(t.S53_TaskSettings_Members.title)),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        // Empty/Null State
        final task = snapshot.data;
        if (task == null) {
          return Scaffold(
            appBar: AppBar(title: Text(t.S53_TaskSettings_Members.title)),
            body: CommonStateView(message: t.error.message.data_not_found),
            bottomNavigationBar: StickyBottomActionBar(
              children: [
                AppButton(
                  text: t.common.buttons.back,
                  type: AppButtonType.primary,
                  onPressed: () => context.pop(),
                ),
              ],
            ),
          );
        }

        final taskName = task.name;
        final createdBy = task.createdBy;
        final membersMap = task.members;
        final membersList = vm.getSortedMembers(task);

        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text(t.S53_TaskSettings_Members.title),
            centerTitle: true,
          ),
          body: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            itemCount: membersList.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final entry = membersList[index];
              final memberId = entry.key;
              final memberData = entry.value as Map<String, dynamic>;
              final bool isOwner = (memberId == createdBy);
              final isLinked = memberData['status'] == 'linked' ||
                  (memberData['isLinked'] == true);

              // 取得目前權重，預設 1.0 (注意這裡要處理 dynamic -> double 的轉型安全)
              // 舊資料的 defaultSplitRatio 可能不存在
              final rawRatio = memberData['defaultSplitRatio'] ?? 1.0;
              final double currentRatio = (rawRatio as num).toDouble();

              // [核心] 成員卡片
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface, // 白色卡片
                  borderRadius: BorderRadius.circular(16), // 圓角 16
                  // 可選：加上淡淡的陰影增加層次感，或者保持平面
                ),
                child: Row(
                  children: [
                    CommonAvatar(
                      avatarId: memberData['avatar'],
                      name: memberData['displayName'],
                      isLinked: memberData['isLinked'] ?? false,
                      radius: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Text(
                              memberData['displayName'],
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                child: isOwner
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Icon(
                                          Icons.star, // 或 star_rounded
                                          size: 22,
                                          color: AppTheme.starGold,
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () => _handleDelete(
                                            context, vm, membersMap, memberId),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: Icon(
                                            Icons.delete_outline,
                                            color: theme.colorScheme.error,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                              ),
                              if (!isLinked) ...[
                                const SizedBox(width: 8),
                                Container(
                                  width: 1,
                                  height: 20, // 不用撐滿，短一點比較精緻
                                  color: theme.colorScheme.onSurfaceVariant
                                      .withValues(alpha: 0.2), // 與頭像的距離
                                ),
                                const SizedBox(width: 8),
                                InkWell(
                                  onTap: () => _showRenameDialog(
                                      context,
                                      vm,
                                      membersMap,
                                      memberId,
                                      memberData['displayName'] ?? ''),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Icon(
                                      Icons.edit,
                                      color: theme.colorScheme.onSurface,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ],
                              const Spacer(),
                              AppStepper(
                                text: SplitRatioHelper.format(currentRatio),
                                onDecrease: vm.isProcessing
                                    ? null
                                    : () => _updateRatio(
                                          vm,
                                          membersMap,
                                          memberId,
                                          SplitRatioHelper.decrease(
                                              currentRatio), // 這裡！
                                        ),
                                onIncrease: vm.isProcessing
                                    ? null
                                    : () => _updateRatio(
                                          vm,
                                          membersMap,
                                          memberId,
                                          SplitRatioHelper.increase(
                                              currentRatio), // 這裡！
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
                text: t.S53_TaskSettings_Members.buttons.invite,
                type: AppButtonType.secondary,
                onPressed: vm.isProcessing
                    ? null
                    : () => vm.inviteMember(context, taskName),
              ),
              AppButton(
                text: t.S53_TaskSettings_Members.buttons.add,
                type: AppButtonType.primary,
                onPressed:
                    vm.isProcessing ? null : () => vm.addMember(membersMap, t),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Rename Dialog 保持不變
class _RenameMemberDialog extends StatefulWidget {
  final String initialName;
  final ValueChanged<String> onConfirm;

  const _RenameMemberDialog({
    required this.initialName,
    required this.onConfirm,
  });

  @override
  State<_RenameMemberDialog> createState() => _RenameMemberDialogState();
}

class _RenameMemberDialogState extends State<_RenameMemberDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final newName = _controller.text.trim();
    if (newName.isEmpty) return;
    Navigator.of(context).pop();
    widget.onConfirm(newName);
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);

    return CommonAlertDialog(
      title: t.S53_TaskSettings_Members.title,
      content: SizedBox(
        width: double.maxFinite,
        child: TaskNameInput(
          controller: _controller,
          maxLength: 10,
          fillColor: theme.colorScheme.surfaceContainerLow,
          label: t.S53_TaskSettings_Members.member_name,
          placeholder: t.S53_TaskSettings_Members.member_name,
        ),
      ),
      actions: [
        AppButton(
          text: t.common.buttons.cancel,
          type: AppButtonType.secondary,
          onPressed: () => Navigator.of(context).pop(),
        ),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _controller,
          builder: (context, value, child) {
            final isValid = value.text.trim().isNotEmpty;
            return AppButton(
              text: t.common.buttons.confirm,
              type: AppButtonType.primary,
              onPressed: isValid ? _submit : null,
            );
          },
        ),
      ],
    );
  }
}
