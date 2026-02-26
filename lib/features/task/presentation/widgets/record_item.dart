import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/category_constants.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/models/dual_amount.dart';
import 'package:iron_split/core/models/record_model.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:iron_split/core/theme/app_theme.dart';
import 'package:iron_split/core/viewmodels/theme_vm.dart';
import 'package:iron_split/features/common/presentation/dialogs/d10_record_delete_confirm_dialog.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:provider/provider.dart';

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
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final displayState = context.watch<DisplayState>();
    final isEnlarged = displayState.isEnlarged;
    final double iconSize = AppLayout.inlineIconSize(isEnlarged);
    final isPrepay = record.type == RecordType.prepay;
    final originalCurrencyConstants = CurrencyConstants.getCurrencyConstants(
        record.currencyCode); // 注意這裡用 currencyCode
    final themeVm = context.watch<ThemeViewModel>();
    final expenseColor = themeVm.themeMode == ThemeMode.dark
        ? AppTheme.expenseLight
        : AppTheme.expenseDeep;
    final prepayColor = themeVm.themeMode == ThemeMode.dark
        ? AppTheme.prepayLight
        : AppTheme.prepayDeep;

    // UI 顯示邏輯 (Icon, Color, Title) 可以保留在 View 層
    final category = CategoryConstant.getCategoryById(record.categoryId);
    final title =
        (record.title.isNotEmpty) ? record.title : category.getName(t);
    final icon = isPrepay ? Icons.savings_outlined : category.icon;
    final iconColor = isPrepay ? prepayColor : expenseColor;
    final amountColor = isPrepay ? colorScheme.tertiary : colorScheme.primary;

    final amountText =
        "${originalCurrencyConstants.symbol} ${CurrencyConstants.formatAmount(amount.original, originalCurrencyConstants.code)}";
    final itemIcon = SizedBox(
      child: Icon(icon, color: iconColor, size: iconSize),
    );
    final itemName = Text(
      title,
      style: textTheme.bodyLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface, // 深黑色
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
    final amountSection = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          amountText,
          style: textTheme.titleMedium?.copyWith(
              color: amountColor, // 深紅/深綠
              fontWeight: FontWeight.w700, // 加粗
              fontFamily: 'RobotoMono', // 等寬字體
              fontSize: 16),
        ),
        // 匯率換算 (如果是不同幣別)
        if (originalCurrencyConstants != baseCurrency)
          Text(
            "≈ ${baseCurrency.code}${baseCurrency.symbol} ${CurrencyConstants.formatAmount(amount.base, baseCurrency.code)}",
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant, // 灰色
              fontFamily: 'RobotoMono',
              fontSize: 10,
            ),
          ),
      ],
    );
    return Dismissible(
      key: Key(record.id ?? ''),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: colorScheme.error,
          borderRadius: BorderRadius.circular(AppLayout.radiusL),
        ),
        padding: const EdgeInsets.only(right: AppLayout.spaceXL),
        child: Icon(Icons.delete_outline, size: iconSize, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        if (onDelete == null) return false;

        return await D10RecordDeleteConfirmDialog.show<bool>(context,
            recordTitle: title,
            currency: originalCurrencyConstants,
            amount: amount.original);
      },
      onDismissed: (direction) {
        if (onDelete != null) {
          onDelete!(context);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppLayout.spaceS), // 上下留白，讓背景透出來
        decoration: BoxDecoration(
          color: colorScheme.surface, // 純白背景
          borderRadius: BorderRadius.circular(AppLayout.radiusL),
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
            borderRadius: BorderRadius.circular(AppLayout.radiusL),
            child: Container(
              constraints: const BoxConstraints(minHeight: 48),
              padding: const EdgeInsets.symmetric(
                  horizontal: AppLayout.spaceL, vertical: AppLayout.spaceS),
              child: isEnlarged
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(children: [
                          itemIcon,
                          const SizedBox(width: AppLayout.spaceM),
                          Expanded(
                            child: itemName,
                          ),
                        ]),
                        amountSection,
                      ],
                    )
                  : Row(
                      children: [
                        itemIcon,
                        const SizedBox(width: AppLayout.spaceM),
                        Expanded(
                          child: itemName,
                        ),
                        amountSection,
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
