import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/category_constants.dart';
import 'package:iron_split/gen/strings.g.dart';

class TaskItemInput extends StatelessWidget {
  const TaskItemInput({
    super.key,
    required this.onCategoryTap,
    required this.titleController,
    required this.selectedCategoryId,
  });

  final VoidCallback onCategoryTap;
  final TextEditingController titleController;
  final String selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Row(
      children: [
        InkWell(
          onTap: onCategoryTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: colorScheme.outlineVariant),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              CategoryConstant.getCategoryById(selectedCategoryId).icon,
              color: colorScheme.primary,
              size: 24,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            controller: titleController,
            decoration: InputDecoration(
              labelText: t.S15_Record_Edit.label_title,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            validator: (v) => v?.isEmpty == true ? "Required" : null,
          ),
        ),
      ],
    );
  }
}
