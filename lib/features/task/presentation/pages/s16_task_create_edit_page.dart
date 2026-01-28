import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/features/common/presentation/dialogs/d04_common_unsaved_confirm_dialog.dart';
import 'package:iron_split/features/task/presentation/dialogs/d03_task_create_confirm_dialog.dart';
import 'package:iron_split/features/task/presentation/widgets/form/task_currency_input.dart';
import 'package:iron_split/features/task/presentation/widgets/form/task_date_range_input.dart';
import 'package:iron_split/features/task/presentation/widgets/form/task_member_count_input.dart';
import 'package:iron_split/features/task/presentation/widgets/form/task_name_input.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:iron_split/features/task/presentation/widgets/common/task_form_section_card.dart';

/// Page Key: S16_TaskCreate.Edit
class S16TaskCreateEditPage extends StatefulWidget {
  const S16TaskCreateEditPage({super.key});

  @override
  State<S16TaskCreateEditPage> createState() => _S16TaskCreateEditPageState();
}

class _S16TaskCreateEditPageState extends State<S16TaskCreateEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  late DateTime _startDate;
  late DateTime _endDate;
  CurrencyOption _baseCurrencyOption = CurrencyOption.defaultCurrencyOption;
  bool _isCurrencyInitialized = false;
  int _memberCount = 1;
  final bool _isCurrencyEnabled = true;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, now.day);
    _endDate = _startDate;

    // 監聽文字變動以即時更新 Suffix 計數器
    _nameController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // 只有在「尚未初始化過幣別」時才執行自動偵測
    if (!_isCurrencyInitialized) {
      _isCurrencyInitialized = true;

      final CurrencyOption suggestedCurrency =
          CurrencyOption.detectSystemCurrency();

      setState(() {
        _baseCurrencyOption = suggestedCurrency;
      });
    }
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => D03TaskCreateConfirmDialog(
        taskName: _nameController.text.trim(),
        startDate: _startDate,
        endDate: _endDate,
        baseCurrencyOption: _baseCurrencyOption,
        memberCount: _memberCount,
      ),
    );
  }

  // 判斷是否需要攔截
  Future<void> _handleClose() async {
    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (context) => const D04CommonUnsavedConfirmDialog(),
    );

    if (shouldLeave == true && mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return PopScope(
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
            icon: const Icon(Icons.home),
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
                  Text(t.S16_TaskCreate_Edit.section_name,
                      style: theme.textTheme.titleSmall
                          ?.copyWith(color: colorScheme.primary)),
                  const SizedBox(height: 8),

                  TaskNameInput(controller: _nameController),

                  const SizedBox(height: 24),

                  // --- 2. 期間設定 (卡片分組) ---
                  TaskFormSectionCard(
                    title: t.S16_TaskCreate_Edit.section_period,
                    children: [
                      TaskDateRangeInput(
                        startDate: _startDate,
                        endDate: _endDate,
                        onStartDateChanged: (date) =>
                            setState(() => _startDate = date),
                        onEndDateChanged: (date) =>
                            setState(() => _endDate = date),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // --- 3. 詳細設定 (卡片分組) ---
                  TaskFormSectionCard(
                    title: t.S16_TaskCreate_Edit.section_settings,
                    children: [
                      TaskCurrencyInput(
                        currency: _baseCurrencyOption,
                        onCurrencyChanged: (currency) =>
                            setState(() => _baseCurrencyOption = currency),
                        enabled: _isCurrencyEnabled,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                            height: 1,
                            width: double.infinity,
                            color: theme.dividerColor),
                      ),
                      TaskMemberCountInput(
                        value: _memberCount,
                        onChanged: (val) => setState(() => _memberCount = val),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FilledButton(
              onPressed: _onSave,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: colorScheme.primary,
              ),
              child: Text(t.S16_TaskCreate_Edit.action_save),
            ),
          ),
        ),
      ),
    );
  }
}
