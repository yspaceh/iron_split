import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:iron_split/features/common/presentation/dialogs/d04_unsaved_changes_dialog.dart';
import 'package:iron_split/features/task/presentation/dialogs/d03_task_create_confirm_dialog.dart';
import 'package:iron_split/gen/strings.g.dart';

/// Page Key: S05_TaskCreate.Form
class S05TaskCreateFormPage extends StatefulWidget {
  const S05TaskCreateFormPage({super.key});

  @override
  State<S05TaskCreateFormPage> createState() => _S05TaskCreateFormPageState();
}

class _S05TaskCreateFormPageState extends State<S05TaskCreateFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  late DateTime _startDate;
  late DateTime _endDate;
  String _currency = 'TWD';
  int _memberCount = 1;

  final List<String> _currencies = [
    'TWD',
    'JPY',
    'USD',
    'KRW',
    'EUR',
    'CNY',
    'HKD',
    'GBP',
    'AUD',
    'CAD',
    'SGD',
    'THB',
    'VND'
  ];

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
        currency: _currency,
        memberCount: _memberCount,
      ),
    );
  }

  // --- Picker 邏輯 ---
  void _showWheelBottomSheet({required Widget child}) {
    FocusScope.of(context).unfocus();

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (ctx) => Container(
        height: 320,
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(t.common.cancel,
                        style: const TextStyle(color: Colors.grey)), // '取消'
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(
                      t.S05_TaskCreate_Form.picker_done,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }

  // (以下 _showStartDatePicker, _showEndDatePicker, _showCurrencyPicker 邏輯保持不變，省略以節省篇幅)
  void _showStartDatePicker() {
    _showWheelBottomSheet(
      child: CupertinoDatePicker(
        initialDateTime: _startDate,
        mode: CupertinoDatePickerMode.date,
        onDateTimeChanged: (val) {
          setState(() {
            _startDate = DateTime(val.year, val.month, val.day);
            if (_endDate.isBefore(_startDate)) _endDate = _startDate;
          });
        },
      ),
    );
  }

  void _showEndDatePicker() {
    _showWheelBottomSheet(
      child: CupertinoDatePicker(
        initialDateTime: _endDate,
        minimumDate: _startDate,
        mode: CupertinoDatePickerMode.date,
        onDateTimeChanged: (val) =>
            setState(() => _endDate = DateTime(val.year, val.month, val.day)),
      ),
    );
  }

  void _showCurrencyPicker() {
    _showWheelBottomSheet(
      child: CupertinoPicker(
        itemExtent: 40,
        scrollController: FixedExtentScrollController(
            initialItem: _currencies.indexOf(_currency)),
        onSelectedItemChanged: (index) =>
            setState(() => _currency = _currencies[index]),
        children: _currencies.map((e) => Center(child: Text(e))).toList(),
      ),
    );
  }

  // 判斷是否需要攔截 (例如：表單有輸入內容才攔截，或者無條件攔截)
  // MVP 簡單起見：只要按取消就跳 D04
  Future<void> _handleClose() async {
    // 呼叫 D04 Dialog
    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (context) => const D04UnsavedChangesDialog(),
    );

    // 如果使用者選了 "true" (回首頁)，才真的關閉頁面
    if (shouldLeave == true && mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dateFormat = DateFormat('yyyy/MM/dd');

    return PopScope(
      canPop: false, // 設為 false 表示手動控制返回邏輯
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _handleClose();
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          title: Text(t.S05_TaskCreate_Form.title),
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
                  Text(t.S05_TaskCreate_Form.section_name,
                      style: theme.textTheme.titleSmall
                          ?.copyWith(color: colorScheme.primary)),
                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _nameController,
                    autofocus: true,
                    maxLength: 20,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(
                          RegExp(r'[\x00-\x1F\x7F]')),
                    ],
                    decoration: InputDecoration(
                      hintText: t.S05_TaskCreate_Form.field_name_hint,
                      // 2. 移除下方的 counterText，改用 suffixText 放在框內
                      counterText: "",
                      suffixText: "${_nameController.text.length}/20",
                      suffixStyle:
                          TextStyle(color: colorScheme.onSurfaceVariant),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      filled: true,
                      fillColor:
                          colorScheme.surfaceContainerHighest.withOpacity(0.5),
                    ),
                    validator: (val) => (val == null || val.trim().isEmpty)
                        ? t.S05_TaskCreate_Form.error_name_empty
                        : null,
                  ),

                  const SizedBox(height: 24),

                  // --- 2. 期間設定 (卡片分組) ---
                  Text(t.S05_TaskCreate_Form.section_period,
                      style: theme.textTheme.titleSmall
                          ?.copyWith(color: colorScheme.primary)),
                  const SizedBox(height: 8),

                  _buildSectionCard(
                    children: [
                      _buildRowItem(
                        icon: Icons.calendar_today,
                        label: t.S05_TaskCreate_Form.field_start_date,
                        value: dateFormat.format(_startDate),
                        onTap: _showStartDatePicker,
                        showDivider: true,
                      ),
                      _buildRowItem(
                        icon: Icons.event_available,
                        label: t.S05_TaskCreate_Form.field_end_date,
                        value: dateFormat.format(_endDate),
                        onTap: _showEndDatePicker,
                        showDivider: false,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // --- 3. 詳細設定 (卡片分組) ---
                  Text(t.S05_TaskCreate_Form.section_settings,
                      style: theme.textTheme.titleSmall
                          ?.copyWith(color: colorScheme.primary)),
                  const SizedBox(height: 8),

                  _buildSectionCard(
                    children: [
                      _buildRowItem(
                        icon: Icons.currency_exchange,
                        label: t.S05_TaskCreate_Form.field_currency,
                        value: _currency,
                        onTap: _showCurrencyPicker,
                        showDivider: true,
                      ),
                      _buildStepperRow(
                        icon: Icons.group_outlined,
                        label: t.S05_TaskCreate_Form.field_member_count,
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
              child: Text(t.S05_TaskCreate_Form.action_save),
            ),
          ),
        ),
      ),
    );
  }

  // (以下 _buildSectionCard, _buildRowItem, _buildStepperRow 保持不變，省略以節省篇幅)
  Widget _buildSectionCard({required List<Widget> children}) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildRowItem({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
    bool showDivider = false,
  }) {
    final theme = Theme.of(context);
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Icon(icon, size: 24, color: theme.colorScheme.primary),
                const SizedBox(width: 16),
                Expanded(child: Text(label, style: theme.textTheme.bodyLarge)),
                Text(
                  value,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.chevron_right,
                    size: 20, color: theme.colorScheme.outline),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
              height: 1,
              indent: 56,
              color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
      ],
    );
  }

  Widget _buildStepperRow({
    required IconData icon,
    required String label,
    required int value,
    required ValueChanged<int> onChanged,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 24, color: theme.colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(child: Text(label, style: theme.textTheme.bodyLarge)),
          IconButton.filledTonal(
            onPressed: value > 1 ? () => onChanged(value - 1) : null,
            icon: const Icon(Icons.remove),
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
          SizedBox(
            width: 40,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          IconButton.filledTonal(
            onPressed: value < 15 ? () => onChanged(value + 1) : null,
            icon: const Icon(Icons.add),
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ],
      ),
    );
  }
}
