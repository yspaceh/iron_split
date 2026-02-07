import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/common/presentation/dialogs/common_alert_dialog.dart';
import 'package:iron_split/features/common/presentation/dialogs/common_error_dialog.dart';
import 'package:iron_split/features/common/presentation/view/common_state_view.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_name_input.dart'; // [新增] 引入 Input
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:iron_split/features/record/data/record_repository.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:iron_split/features/task/presentation/widgets/member_item.dart';
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

  // Dialog Logic (UI Layer)
  void _showRenameDialog(
      BuildContext context,
      S53TaskSettingsMembersViewModel vm,
      Map<String, dynamic> membersMap,
      String memberId,
      String currentName) {
    // [修改] 改為呼叫下方的私有 Dialog Widget
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

    // Call VM to attempt delete
    final success = await vm.deleteMember(membersMap, memberId);

    // If failed (blocked), show dialog
    if (!success && context.mounted) {
      CommonErrorDialog.show(
        context,
        title: t.error.dialog.member_delete_failed.title,
        content: t.error.dialog.member_delete_failed.message,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final vm = context.watch<S53TaskSettingsMembersViewModel>();

    return StreamBuilder<TaskModel?>(
      stream: vm.taskStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text(t.S53_TaskSettings_Members.title)),
            // 1. 中間是共用純文字 View
            body: CommonStateView(
              message: ErrorMapper.map(context, snapshot.error),
            ),
            // 2. 底部是 StickyBar + 重試按鈕
            bottomNavigationBar: StickyBottomActionBar(
              children: [
                AppButton(
                  text: t.common.buttons.retry,
                  type: AppButtonType.primary,
                  onPressed: () {
                    // 重試邏輯 (例如 vm.refresh() 或 pop)
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: Text(t.S53_TaskSettings_Members.title)),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final task = snapshot.data;
        if (task == null) {
          return Scaffold(
            appBar: AppBar(title: Text(t.S53_TaskSettings_Members.title)),
            // [修改] 使用極簡文字 View
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
          body: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: membersList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final entry = membersList[index];
                    final memberId = entry.key;
                    final memberData = entry.value as Map<String, dynamic>;

                    final bool isOwner = (memberId == createdBy);

                    return MemberItem(
                      key: ValueKey(memberId),
                      member: memberData,
                      isOwner: isOwner,
                      onRatioChanged: (val) =>
                          vm.updateRatio(membersMap, memberId, val),
                      onDelete: () =>
                          _handleDelete(context, vm, membersMap, memberId),
                      onEdit: () => _showRenameDialog(context, vm, membersMap,
                          memberId, memberData['displayName'] ?? ''),
                      isProcessing: vm.isProcessing,
                    );
                  },
                ),
              ),
            ],
          ),
          extendBody: true,
          bottomNavigationBar: StickyBottomActionBar(
            isSheetMode: false,
            children: [
              AppButton(
                text: t.S53_TaskSettings_Members.buttons.invite,
                type: AppButtonType.secondary,
                icon: Icons.share,
                onPressed: vm.isProcessing
                    ? null
                    : () => vm.inviteMember(context, taskName),
              ),
              AppButton(
                text: t.S53_TaskSettings_Members.buttons.add,
                type: AppButtonType.primary,
                icon: Icons.person_add_alt_1,
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

// [新增] 私有的重新命名 Dialog，整合了 TaskNameInput
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

    // 關閉 Dialog
    Navigator.of(context).pop();
    // 回調新名稱
    widget.onConfirm(newName);
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return CommonAlertDialog(
      title: t.S53_TaskSettings_Members.title,
      // 使用 SizedBox 確保輸入框有足夠寬度，避免在 Alert 中縮成一團
      content: SizedBox(
        width: double.maxFinite,
        child: TaskNameInput(
          controller: _controller,
          maxLength: 10,
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
        // 使用 ValueListenableBuilder 監聽輸入框，控制按鈕啟用狀態
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _controller,
          builder: (context, value, child) {
            final isValid = value.text.trim().isNotEmpty;
            return AppButton(
              text: t.common.buttons.confirm,
              type: AppButtonType.primary,
              // 若無內容則 disable 按鈕
              onPressed: isValid ? _submit : null,
            );
          },
        ),
      ],
    );
  }
}
