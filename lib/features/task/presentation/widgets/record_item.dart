import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/category_constants.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/models/record_model.dart';
import 'package:iron_split/core/theme/app_theme.dart';
import 'package:iron_split/features/common/presentation/dialogs/common_alert_dialog.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/task/presentation/viewmodels/balance_summary_state.dart';
import 'package:iron_split/gen/strings.g.dart';

class RecordItem extends StatelessWidget {
  final RecordModel record;
  final DualAmount amount;
  final CurrencyConstants baseCurrency;
  final VoidCallback? onTap;
  final Future<void> Function(BuildContext context)? onDelete;

  const RecordItem({
    super.key,
    required this.record,
    required this.amount,
    required this.baseCurrency,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final isIncome = record.type == 'income';
    final originalCurrencyConstants = CurrencyConstants.getCurrencyConstants(
        record.currencyCode); // 注意這裡用 currencyCode
    final exchangeRate = record.exchangeRate;

    // UI 顯示邏輯 (Icon, Color, Title) 可以保留在 View 層
    final category = CategoryConstant.getCategoryById(record.categoryId);
    final title =
        (record.title.isNotEmpty) ? record.title : category.getName(t);
    final icon = isIncome ? Icons.savings_outlined : category.icon;
    final iconColor = isIncome ? AppTheme.incomeDeep : AppTheme.expenseDeep;
    final amountColor =
        isIncome ? theme.colorScheme.tertiary : theme.colorScheme.primary;

    final amountText =
        "${originalCurrencyConstants.symbol} ${CurrencyConstants.formatAmount(amount.original, originalCurrencyConstants.code)}";
    return Dismissible(
      key: Key(record.id ?? ''),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: theme.colorScheme.error,
          borderRadius: BorderRadius.circular(16), // 圓角要跟卡片一樣
        ),
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        if (onDelete == null) return false;

        return await CommonAlertDialog.show<bool>(
          context,
          title: t.D10_RecordDelete_Confirm.delete_record_title,
          content: Text(t.D10_RecordDelete_Confirm.delete_record_content(
              title: title, amount: amountText)),
          actions: [
            AppButton(
              text: t.common.buttons.close,
              type: AppButtonType.secondary,
              onPressed: () => context.pop(false),
            ),
            AppButton(
              text: t.common.buttons.close,
              type: AppButtonType.primary,
              onPressed: () => context.pop(true),
            ),
          ],
        );
      },
      onDismissed: (direction) {
        if (onDelete != null) {
          onDelete!(context);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8), // 上下留白，讓背景透出來
        decoration: BoxDecoration(
          color: Colors.white, // 純白背景
          borderRadius: BorderRadius.circular(16), // 精緻圓角
          // 可選：極淡的陰影，增加立體感 (如果不喜歡可以拿掉 boxshadow)
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              offset: const Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  // (A) 左側 Icon
                  SizedBox(
                    child: Icon(icon, color: iconColor, size: 20),
                  ),

                  const SizedBox(width: 12),

                  // (B) 中間標題
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface, // 深黑色
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // (C) 右側金額
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        amountText,
                        style: theme.textTheme.titleMedium?.copyWith(
                            color: amountColor, // 深紅/深綠
                            fontWeight: FontWeight.w700, // 加粗
                            fontFamily: 'RobotoMono', // 等寬字體
                            fontSize: 16),
                      ),
                      // 匯率換算 (如果是不同幣別)
                      if (originalCurrencyConstants != baseCurrency)
                        Text(
                          "≈ ${baseCurrency.code}${baseCurrency.symbol} ${CurrencyConstants.formatAmount(amount.base, baseCurrency.code)}",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant, // 灰色
                            fontFamily: 'RobotoMono',
                            fontSize: 10,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
