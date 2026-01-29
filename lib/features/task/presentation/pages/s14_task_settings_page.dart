import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/features/common/presentation/bottom_sheets/remainder_rule_picker_sheet.dart';
import 'package:iron_split/features/task/presentation/dialogs/d09_task_settings_currency_confirm_dialog.dart';
import 'package:iron_split/features/task/presentation/widgets/common/task_form_section_card.dart';
import 'package:iron_split/features/task/presentation/widgets/form/task_currency_input.dart';
import 'package:iron_split/features/task/presentation/widgets/form/task_date_range_input.dart';
import 'package:iron_split/features/task/presentation/widgets/form/task_name_input.dart';
import 'package:iron_split/features/task/presentation/widgets/form/task_remainder_rule_input.dart';
import 'package:iron_split/gen/strings.g.dart';

/// Page Key: S14_Task.Settings
class S14TaskSettingsPage extends StatefulWidget {
  final String taskId;
  const S14TaskSettingsPage({super.key, required this.taskId});

  @override
  State<S14TaskSettingsPage> createState() => _S14TaskSettingsPageState();
}

class _S14TaskSettingsPageState extends State<S14TaskSettingsPage> {
  late TextEditingController _nameController;
  final FocusNode _nameFocusNode = FocusNode();

  DateTime? _startDate;
  DateTime? _endDate;
  CurrencyOption? _currency;
  String _remainderRule = 'random';
  String? _createdBy;
  bool _isLoading = true;
  Map<String, dynamic> _membersData = {};

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();

    // Auto-save Name when focus is lost
    _nameFocusNode.addListener(() {
      if (!_nameFocusNode.hasFocus) {
        _updateName();
      }
    });

    _fetchTaskData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  Future<void> _fetchTaskData() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('tasks')
          .doc(widget.taskId)
          .get();
      if (doc.exists && mounted) {
        final data = doc.data()!;
        _nameController.text = data['name'] ?? '';

        setState(() {
          _startDate = (data['startDate'] as Timestamp?)?.toDate();
          _endDate = (data['endDate'] as Timestamp?)?.toDate();
          _currency = CurrencyOption.getCurrencyOption(
              data['baseCurrency'] ?? CurrencyOption.defaultCode);
          _remainderRule = data['remainderRule'] ?? 'random';
          _createdBy = data['createdBy'] as String?;
          _membersData = data['members'] as Map<String, dynamic>? ?? {};
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- Auto-Save Actions ---

  Future<void> _updateName() async {
    final newName = _nameController.text.trim();
    if (newName.isEmpty) return;
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(widget.taskId)
        .update({
      'name': newName,
    });
  }

  Future<void> _updateDateRange(DateTime start, DateTime end) async {
    setState(() {
      _startDate = start;
      _endDate = end;
    });
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(widget.taskId)
        .update({
      'startDate': Timestamp.fromDate(start),
      'endDate': Timestamp.fromDate(end),
    });
  }

  Future<void> _handleCurrencyChange(CurrencyOption newCurrency) async {
    // Show D09 Confirm
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => const D09TaskSettingsCurrencyConfirmDialog(),
    );

    if (confirm == true) {
      setState(() => _currency = newCurrency);
      // Immediate Save
      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(widget.taskId)
          .update({
        'baseCurrency': newCurrency.code,
      });
    }
  }

  Future<void> _handleRuleChange(String newRule) async {
    setState(() => _remainderRule = newRule);
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(widget.taskId)
        .update({
      'remainderRule': newRule,
    });
  }

  // --- Build UI ---

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentUid = FirebaseAuth.instance.currentUser?.uid;
    final isOwner = currentUid != null && currentUid == _createdBy;

    if (_isLoading) {
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
            onFocusChange: (hasFocus) {
              if (!hasFocus) _updateName();
            },
            child: TaskNameInput(controller: _nameController),
          ),

          const SizedBox(height: 24),

          // --- 2. 期間設定 (卡片分組) ---
          TaskFormSectionCard(
            title: t.S16_TaskCreate_Edit.section_period,
            children: [
              TaskDateRangeInput(
                startDate: _startDate!,
                endDate: _endDate!,
                onStartDateChanged: (val) => _updateDateRange(val, _endDate!),
                onEndDateChanged: (val) => _updateDateRange(_startDate!, val),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // --- 3. 詳細設定 (卡片分組) ---
          TaskFormSectionCard(
            title: t.S16_TaskCreate_Edit.section_settings,
            children: [
              TaskCurrencyInput(
                currency: _currency!,
                onCurrencyChanged: _handleCurrencyChange,
                enabled: true,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                    height: 1,
                    width: double.infinity,
                    color: theme.dividerColor),
              ),
              TaskRemainderRuleInput(
                rule: RemainderRulePickerSheet.getRuleName(
                    context, _remainderRule),
                onRuleChanged: _handleRuleChange,
                enabled: true,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 3. Settings Navigation (Use S14 Keys)
          // S53: Member Settings
          _buildNavTile(
            context: context,
            icon: Icons.people_outline,
            title: t.S14_Task_Settings.menu_member_settings,
            onTap: () {
              context.push('/task/${widget.taskId}/settings/members');
            },
          ),
          const SizedBox(height: 12),

          // S52: History
          _buildNavTile(
            context: context,
            icon: Icons.history,
            title: t.S14_Task_Settings.menu_history,
            onTap: () {
              context.pushNamed(
                'S52',
                pathParameters: {'taskId': widget.taskId},
                extra: _membersData, // 透過 extra 傳遞 Map 資料
              );
            },
          ),

          // 4. End Task (S12) - Owner Only
          if (isOwner) ...[
            const SizedBox(height: 40),
            _buildNavTile(
              context: context,
              icon: Icons.check_circle_outline,
              title: t.S14_Task_Settings.menu_end_task,
              isDestructive: true,
              onTap: () {
                context.push('/task/${widget.taskId}/close');
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
