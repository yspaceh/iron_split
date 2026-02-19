import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/category_constants.dart';
import 'package:iron_split/core/theme/app_theme.dart';
import 'package:iron_split/core/viewmodels/theme_vm.dart';
import 'package:iron_split/features/common/presentation/widgets/form/app_text_field.dart';
import 'package:iron_split/features/common/presentation/widgets/pickers/category_picker_sheet.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:provider/provider.dart';

class TaskItemInput extends StatelessWidget {
  const TaskItemInput({
    super.key,
    required this.onCategoryChanged,
    required this.titleController,
    required this.selectedCategoryId,
    this.focusNode,
  });

  final ValueChanged<String> onCategoryChanged;
  final TextEditingController titleController;
  final String selectedCategoryId;
  final FocusNode? focusNode;

  void _showCategoryPicker(BuildContext context) {
    CategoryPickerSheet.show(
      context: context,
      initialCategoryId: selectedCategoryId,
      onSelected: (category) {
        onCategoryChanged(category.id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final t = Translations.of(context);
    final themeVm = context.watch<ThemeViewModel>();
    final expenseColor = themeVm.themeMode == ThemeMode.dark
        ? AppTheme.expenseLight
        : AppTheme.expenseDeep;

    return Row(
      // [對齊策略]：對齊底部，讓左側方塊跟右側輸入框平行
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 左側：類別按鈕 (風格化)
        Padding(
          padding: const EdgeInsets.only(bottom: 2), // 微調高度以對齊
          child: InkWell(
            onTap: () => _showCategoryPicker(context),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 64, // 與 AppTextField 高度一致
              width: 56, // 正方形
              decoration: BoxDecoration(
                // [風格統一]：淡灰底，無邊框
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                CategoryConstant.getCategoryById(selectedCategoryId).icon,
                color: expenseColor,
                size: 24,
              ),
            ),
          ),
        ),

        const SizedBox(width: 8),

        // 右側：標題輸入 (使用 AppTextField)
        Expanded(
          child: AppTextField(
            controller: titleController,
            labelText: t.S15_Record_Edit.label.title,
            hintText: t.S15_Record_Edit.hint.item(
                category: CategoryConstant.getHint(t, selectedCategoryId)),
            validator: (v) =>
                v?.isEmpty == true ? t.error.message.required : null,
            focusNode: focusNode,
          ),
        ),
      ],
    );
  }
}
