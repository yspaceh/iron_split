import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/features/common/presentation/dialogs/d04_common_unsaved_confirm_dialog.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_date_input.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:iron_split/features/task/presentation/helpers/task_share_helper.dart';
import 'package:iron_split/features/task/presentation/viewmodels/s16_task_create_edit_vm.dart';
import 'package:provider/provider.dart';
import 'package:iron_split/features/task/presentation/dialogs/d03_task_create_confirm_dialog.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_currency_input.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_member_count_input.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_name_input.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:iron_split/features/common/presentation/widgets/form_section.dart';

/// Page Key: S16_TaskCreate.Edit
class S16TaskCreateEditPage extends StatelessWidget {
  const S16TaskCreateEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 注入 VM
    return ChangeNotifierProvider(
      create: (_) => S16TaskCreateEditViewModel(
        taskRepo: context.read<TaskRepository>(),
      ),
      child: const _S16Content(),
    );
  }
}

class _S16Content extends StatefulWidget {
  const _S16Content();

  @override
  State<_S16Content> createState() => _S16ContentState();
}

class _S16ContentState extends State<_S16Content> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 監聽文字變動以即時更新 Suffix 計數器 (保留原邏輯)
    _nameController.addListener(() {
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 初始化幣別 (移交給 VM 處理)
    context.read<S16TaskCreateEditViewModel>().initCurrency();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _onSave(
      BuildContext context, S16TaskCreateEditViewModel vm) async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    // 1. 顯示 D03 確認框 (純 UI)
    final bool? confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => D03TaskCreateConfirmDialog(
        taskName: _nameController.text.trim(),
        startDate: vm.startDate,
        endDate: vm.endDate,
        baseCurrency: vm.baseCurrency,
        memberCount: vm.memberCount,
      ),
    );

    // 2. 如果使用者確認
    if (confirmed == true && mounted) {
      try {
        // 呼叫 VM 執行建立流程
        final result = await vm.createTask(_nameController.text.trim(), t);

        if (result != null && mounted) {
          // 2. 如果有邀請碼 (代表多人任務)，呼叫 Helper 進行分享
          if (result.inviteCode != null) {
            await TaskShareHelper.inviteMember(
              context: context,
              taskId: result.taskId,
              taskName: _nameController.text.trim(),
              existingCode: result.inviteCode, //  傳入 VM 拿到的 Code
            );
          }

          // 3. 導航到任務 Dashboard
          if (mounted) {
            context.goNamed(
              'S13', // 請確認您的 Router name (例如 S13)
              pathParameters: {'taskId': result.taskId},
            );
          }
        }
      } catch (e) {
        if (mounted) {
          debugPrint(e.toString());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(Translations.of(context)
                    .common
                    .error_prefix(message: e.toString()))),
          );
        }
      }
    }
  }

  // 判斷是否需要攔截
  Future<void> _handleClose() async {
    final confirm = await D04CommonUnsavedConfirmDialog.show<bool>(context);

    if (confirm == true && mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // 監聽 VM 狀態
    final vm = context.watch<S16TaskCreateEditViewModel>();

    return Stack(
      children: [
        PopScope(
          canPop: false, // 設為 false 表示手動控制返回邏輯
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;
            await _handleClose();
          },
          child: Scaffold(
            backgroundColor: colorScheme.surface,
            appBar: AppBar(
              title: Text(t.S16_TaskCreate_Edit.title),
              leading: IconButton(
                icon: Icon(Icons.adaptive.arrow_back),
                onPressed: _handleClose,
              ),
            ),
            // 1. 全局點擊偵測：點擊背景收起鍵盤
            body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              behavior: HitTestBehavior.translucent, // 確保點擊空白處也能觸發
              child: SafeArea(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // --- 1. 名稱區塊 ---
                      Text(t.S16_TaskCreate_Edit.section.name,
                          style: theme.textTheme.titleSmall
                              ?.copyWith(color: colorScheme.primary)),
                      const SizedBox(height: 8),

                      TaskNameInput(controller: _nameController),

                      const SizedBox(height: 24),

                      // --- 2. 期間設定 (卡片分組) ---
                      TaskFormSectionCard(
                        title: t.S16_TaskCreate_Edit.section.name,
                        children: [
                          TaskDateInput(
                            label: t.S16_TaskCreate_Edit.label.start_date,
                            date: vm.startDate,
                            onDateChanged: (val) =>
                                vm.updateDateRange(val, vm.endDate),
                          ),
                          TaskDateInput(
                            label: t.S16_TaskCreate_Edit.label.end_date,
                            date: vm.endDate,
                            onDateChanged: (val) =>
                                vm.updateDateRange(vm.startDate, val),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // --- 3. 詳細設定 (卡片分組) ---
                      TaskFormSectionCard(
                        title: t.S16_TaskCreate_Edit.section.settings,
                        children: [
                          TaskCurrencyInput(
                            currency: vm.baseCurrency,
                            onCurrencyChanged: vm.updateCurrency,
                            enabled: vm.isCurrencyEnabled,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                                height: 1,
                                width: double.infinity,
                                color: theme.dividerColor),
                          ),
                          TaskMemberCountInput(
                            value: vm.memberCount,
                            onChanged: vm.updateMemberCount,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: StickyBottomActionBar(
              isSheetMode: false,
              children: [
                AppButton(
                  text: t.S16_TaskCreate_Edit.buttons.save,
                  type: AppButtonType.primary,
                  onPressed: () => _onSave(context, vm),
                ),
              ],
            ),
          ),
        ),
        // 全局 Loading Overlay
        if (vm.isProcessing)
          Container(
            color: Colors.black54,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(color: Colors.white),
                  const SizedBox(height: 16),
                  Text(
                    vm.statusText ?? t.D03_TaskCreate_Confirm.creating_task,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
