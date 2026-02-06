import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:iron_split/features/record/data/record_repository.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:iron_split/features/task/presentation/widgets/member_item.dart';
import 'package:provider/provider.dart';
import 'package:iron_split/features/common/presentation/dialogs/common_alert_dialog.dart';
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
    final t = Translations.of(context);
    final controller = TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(t.S53_TaskSettings_Members.title),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              labelText: t.S53_TaskSettings_Members.member_name,
              border: const OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: (val) {
              Navigator.pop(context);
              vm.renameMember(membersMap, memberId, val);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(t.common.buttons.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                vm.renameMember(membersMap, memberId, controller.text);
              },
              child: Text(t.common.buttons.confirm),
            ),
          ],
        );
      },
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
      // 這裡假設 VM 回傳 false 代表因為有資料而擋下
      // (如果是因為錯誤，通常 VM 內部已經 catch 並 log 了，也可以選擇回傳 enum 來區分錯誤類型)
      // 簡單起見，我們再次檢查資料 (或者信任 VM 的回傳)
      // 實際上我們應該在 VM 回傳更具體的狀態，但此處先假設 false = blocked
      await CommonAlertDialog.show(
        context,
        title: t.S53_TaskSettings_Members.dialog_delete_error_title,
        content: Text(t.S53_TaskSettings_Members.dialog_delete_error_content),
        actions: [
          AppButton(
            text: t.common.buttons.close,
            type: AppButtonType.secondary,
            onPressed: () => context.pop(),
          ),
        ],
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
          // TODO: 這邊的錯誤處理語言要處理
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final task = snapshot.data;
        if (task == null) return const SizedBox();

        final taskName = task.name;
        final createdBy = task.createdBy;
        final membersMap = task.members;
        // Sort Logic (UI Layer)
        final List<MapEntry<String, dynamic>> membersList =
            membersMap.entries.toList();

        membersList.sort((a, b) {
          final dataA = a.value as Map<String, dynamic>;
          final dataB = b.value as Map<String, dynamic>;
          final bool isALinked =
              dataA['status'] == 'linked' || (dataA['isLinked'] == true);
          final bool isBLinked =
              dataB['status'] == 'linked' || (dataB['isLinked'] == true);
          if (isALinked && !isBLinked) return -1;
          if (!isALinked && isBLinked) return 1;
          final int tA = dataA['createdAt'] as int? ?? 0;
          final int tB = dataB['createdAt'] as int? ?? 0;
          return tA.compareTo(tB);
        });

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
