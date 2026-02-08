import 'package:flutter/material.dart';
import 'package:iron_split/features/common/presentation/widgets/pickers/app_select_field.dart';
import 'package:iron_split/gen/strings.g.dart';

class TaskRemainderRuleInput extends StatelessWidget {
  const TaskRemainderRuleInput(
      {super.key, required this.rule, required this.onTap});

  final String rule;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // 直接替換為 AppSelectField
    return AppSelectField(
      labelText: t.common.remainder_rule.title, // 標題：零頭處理
      text: rule,
      onTap: onTap,
    );
  }
}
