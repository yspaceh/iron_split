import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/remainder_rule_constants.dart';
import 'package:iron_split/features/record/presentation/bottom_sheets/b01_balance_rule_edit_bottom_sheet.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:provider/provider.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/features/task/presentation/viewmodels/s14_task_settings_vm.dart';
import 'package:iron_split/features/task/presentation/dialogs/d09_task_settings_currency_confirm_dialog.dart';
import 'package:iron_split/features/common/presentation/widgets/form_section.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_currency_input.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_date_range_input.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_name_input.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_remainder_rule_input.dart';
import 'package:iron_split/gen/strings.g.dart';

/// Page Key: S14_Task.Settings
class S14TaskSettingsPage extends StatelessWidget {
  final String taskId;
  const S14TaskSettingsPage({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => S14TaskSettingsViewModel(
        taskId: taskId,
        taskRepo: context.read<TaskRepository>(),
      )..init(),
      child: const _S14Content(),
    );
  }
}

class _S14Content extends StatefulWidget {
  const _S14Content();

  @override
  State<_S14Content> createState() => _S14ContentState();
}

class _S14ContentState extends State<_S14Content> {
  final FocusNode _nameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final vm = context.read<S14TaskSettingsViewModel>();
    // Auto-save Name when focus is lost
    _nameFocusNode.addListener(() {
      if (!_nameFocusNode.hasFocus) {
        vm.updateName();
      }
    });
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    super.dispose();
  }

  Future<void> _onCurrencyChange(BuildContext context,
      S14TaskSettingsViewModel vm, CurrencyOption selectedOption) async {
    // 髒檢查
    if (selectedOption.code == vm.currency?.code) return;

    // 等待 BottomSheet 關閉動畫
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    // 呼叫 D09 Dialog
    final bool? success = await showDialog<bool>(
      context: context,
      builder: (context) => D09TaskSettingsCurrencyConfirmDialog(
        taskId: vm.taskId,
        newCurrency: selectedOption,
      ),
    );

    // 成功後更新 VM 狀態
    if (success == true && mounted) {
      vm.updateCurrency(selectedOption);
    }
  }

  Future<void> _onRemainderRuleChange(
      BuildContext context, S14TaskSettingsViewModel vm) async {
    // 1. 準備成員資料 (Map 轉 List)
    final List<Map<String, dynamic>> membersList =
        vm.membersData.entries.map((e) {
      final m = e.value as Map<String, dynamic>;
      return <String, dynamic>{...m, 'id': e.key};
    }).toList();

    // 2. 呼叫 B01
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      builder: (context) => B01BalanceRuleEditBottomSheet(
        initialRule: vm.remainderRule,
        initialMemberId: vm.remainderAbsorberId,
        members: membersList,
      ),
    );

    // 3. 處理回傳
    if (result != null && mounted) {
      await vm.updateRemainderRule(result['rule'], result['memberId']);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final vm = context.watch<S14TaskSettingsViewModel>();

    if (vm.isLoading ||
        vm.startDate == null ||
        vm.endDate == null ||
        vm.currency == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(t.S14_Task_Settings.title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // --- 1. 名稱區塊 ---
          Text(t.S16_TaskCreate_Edit.section_name,
              style: theme.textTheme.titleSmall
                  ?.copyWith(color: colorScheme.primary)),
          const SizedBox(height: 8),

          Focus(
            focusNode: _nameFocusNode,
            child: TaskNameInput(controller: vm.nameController),
          ),

          const SizedBox(height: 24),

          // --- 2. 期間設定 ---
          TaskFormSectionCard(
            title: t.S16_TaskCreate_Edit.section_period,
            children: [
              TaskDateRangeInput(
                startDate: vm.startDate!,
                endDate: vm.endDate!,
                onStartDateChanged: (val) =>
                    vm.updateDateRange(val, vm.endDate!),
                onEndDateChanged: (val) =>
                    vm.updateDateRange(vm.startDate!, val),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // --- 3. 詳細設定 ---
          TaskFormSectionCard(
            title: t.S16_TaskCreate_Edit.section_settings,
            children: [
              TaskCurrencyInput(
                currency: vm.currency!,
                onCurrencyChanged: (val) => _onCurrencyChange(context, vm, val),
                enabled: true,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                    height: 1,
                    width: double.infinity,
                    color: theme.dividerColor),
              ),
              TaskRemainderRuleInput(
                rule:
                    RemainderRuleConstants.getLabel(context, vm.remainderRule),
                onTap: () => _onRemainderRuleChange(context, vm),
                enabled: true,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Settings Navigation
          _buildNavTile(
            context: context,
            icon: Icons.people_outline,
            title: t.S14_Task_Settings.menu_member_settings,
            onTap: () {
              context.pushNamed(
                'S53',
                pathParameters: {'taskId': vm.taskId},
              );
            },
          ),
          const SizedBox(height: 12),

          _buildNavTile(
            context: context,
            icon: Icons.history,
            title: t.S14_Task_Settings.menu_history,
            onTap: () {
              context.pushNamed(
                'S52',
                pathParameters: {'taskId': vm.taskId},
                extra: vm.membersData,
              );
            },
          ),

          if (vm.isOwner) ...[
            const SizedBox(height: 40),
            _buildNavTile(
              context: context,
              icon: Icons.check_circle_outline,
              title: t.S14_Task_Settings.menu_end_task,
              isDestructive: true,
              onTap: () {
                context.push('/task/${vm.taskId}/close');
              },
            ),
          ],

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildNavTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final theme = Theme.of(context);
    final color = isDestructive
        ? theme.colorScheme.error
        : theme.colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: isDestructive
                  ? theme.colorScheme.error.withValues(alpha: 0.3)
                  : theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 16),
            Expanded(
                child: Text(title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: isDestructive ? color : null,
                      fontWeight: isDestructive ? FontWeight.bold : null,
                    ))),
            Icon(Icons.arrow_forward_ios,
                size: 16, color: theme.colorScheme.outline),
          ],
        ),
      ),
    );
  }
}
