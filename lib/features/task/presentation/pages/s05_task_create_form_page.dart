import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:iron_split/features/task/presentation/dialogs/d03_task_create_confirm_dialog.dart';
import 'package:iron_split/gen/strings.g.dart';

/// Page Key: S05_TaskCreate.Form
/// CSV Page 11
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
  String _currency = 'TWD'; // MVP 預設
  int _memberCount = 1; // 預設 1 人

  @override
  void initState() {
    super.initState();
    // 預設日期為今天
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, now.day);
    _endDate = _startDate;

    // 監聽字數變化
    _nameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;

    // 開啟 D03 確認彈窗 (Page 14)
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

  // --- 滾輪選擇器實作 (符合 CSV: ModalBottomSheet + Wheel) ---

  void _showWheelBottomSheet({required Widget child}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (ctx) => SizedBox(
        height: 300,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(t.S05_TaskCreate_Form.picker_done),
                ),
              ],
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }

  void _showStartDatePicker() {
    _showWheelBottomSheet(
      child: CupertinoDatePicker(
        initialDateTime: _startDate,
        mode: CupertinoDatePickerMode.date,
        // iOS 風格滾輪
        onDateTimeChanged: (val) {
          setState(() {
            _startDate = DateTime(val.year, val.month, val.day);
            if (_endDate.isBefore(_startDate)) {
              _endDate = _startDate;
            }
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
        onDateTimeChanged: (val) {
          setState(() {
            _endDate = DateTime(val.year, val.month, val.day);
          });
        },
      ),
    );
  }

  void _showCurrencyPicker() {
    final currencies = ['TWD', 'JPY', 'USD'];
    final labels = [
      t.S05_TaskCreate_Form.currency_twd,
      t.S05_TaskCreate_Form.currency_jpy,
      t.S05_TaskCreate_Form.currency_usd,
    ];

    _showWheelBottomSheet(
      child: CupertinoPicker(
        itemExtent: 40,
        scrollController: FixedExtentScrollController(
            initialItem: currencies.indexOf(_currency)),
        onSelectedItemChanged: (index) {
          setState(() => _currency = currencies[index]);
        },
        children: labels.map((e) => Center(child: Text(e))).toList(),
      ),
    );
  }

  void _showCountPicker() {
    // 規則：1-15 人
    _showWheelBottomSheet(
      child: CupertinoPicker(
        itemExtent: 40,
        scrollController:
            FixedExtentScrollController(initialItem: _memberCount - 1),
        onSelectedItemChanged: (index) {
          setState(() => _memberCount = index + 1);
        },
        children:
            List.generate(15, (index) => Center(child: Text('${index + 1} 人'))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('yyyy/MM/dd');

    return Scaffold(
      appBar: AppBar(
        title: Text(t.S05_TaskCreate_Form.title),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              // 1. 名稱
              Text(t.S05_TaskCreate_Form.section_name,
                  style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                maxLength: 20,
                decoration: InputDecoration(
                  hintText: t.S05_TaskCreate_Form.field_name_hint,
                  counterText: t.S05_TaskCreate_Form.field_name_counter(
                    current: _nameController.text.length,
                  ),
                  border: const OutlineInputBorder(),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                validator: (val) => (val == null || val.trim().isEmpty)
                    ? t.S05_TaskCreate_Form.error_name_empty
                    : null,
              ),
              const SizedBox(height: 24),

              // 2. 期間
              Text(t.S05_TaskCreate_Form.section_period,
                  style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildPickerField(
                      label: t.S05_TaskCreate_Form.field_start_date,
                      value: dateFormat.format(_startDate),
                      icon: Icons.calendar_today,
                      onTap: _showStartDatePicker,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildPickerField(
                      label: t.S05_TaskCreate_Form.field_end_date,
                      value: dateFormat.format(_endDate),
                      icon: Icons.event_available,
                      onTap: _showEndDatePicker,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 3. 設定
              Text(t.S05_TaskCreate_Form.section_settings,
                  style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              _buildPickerField(
                label: t.S05_TaskCreate_Form.field_currency,
                value: _currency,
                icon: Icons.currency_exchange,
                onTap: _showCurrencyPicker,
              ),
              const SizedBox(height: 12),
              _buildPickerField(
                label: t.S05_TaskCreate_Form.field_member_count,
                value: '$_memberCount',
                icon: Icons.group_outlined,
                onTap: _showCountPicker,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FilledButton(
            onPressed: _onSave,
            style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16)),
            child: Text(t.S05_TaskCreate_Form.action_save),
          ),
        ),
      ),
    );
  }

  Widget _buildPickerField({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          prefixIcon: Icon(icon, size: 20),
        ),
        child: Text(value, style: Theme.of(context).textTheme.bodyLarge),
      ),
    );
  }
}
