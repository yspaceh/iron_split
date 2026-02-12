import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/split_method_constants.dart';
import 'package:iron_split/core/utils/split_ratio_helper.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/app_stepper.dart';
import 'package:iron_split/features/common/presentation/widgets/form/compact_amount_input.dart';
import 'package:iron_split/features/common/presentation/widgets/selection_tile.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar.dart';
import 'package:iron_split/features/common/presentation/widgets/common_bottom_sheet.dart';
import 'package:iron_split/features/common/presentation/widgets/custom_sliding_segment.dart';
import 'package:iron_split/features/common/presentation/widgets/info_bar.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:iron_split/features/record/presentation/viewmodels/b03_split_method_edit_vm.dart';
import 'package:iron_split/features/settlement/presentation/widgets/summary_row.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:provider/provider.dart';

class B03SplitMethodEditBottomSheet extends StatelessWidget {
  final double totalAmount;
  final CurrencyConstants selectedCurrency;
  final List<Map<String, dynamic>> allMembers;
  final Map<String, double> defaultMemberWeights;
  final double exchangeRate;
  final CurrencyConstants baseCurrency;
  final String initialSplitMethod;
  final List<String> initialMemberIds;
  final Map<String, double> initialDetails;

  const B03SplitMethodEditBottomSheet({
    super.key,
    required this.totalAmount,
    required this.selectedCurrency,
    required this.allMembers,
    required this.defaultMemberWeights,
    required this.exchangeRate,
    required this.baseCurrency,
    required this.initialSplitMethod,
    required this.initialMemberIds,
    required this.initialDetails,
  });

  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    required double totalAmount,
    required CurrencyConstants selectedCurrency,
    required List<Map<String, dynamic>> allMembers,
    required Map<String, double> defaultMemberWeights,
    double exchangeRate = 1.0,
    required CurrencyConstants baseCurrency,
    required String initialSplitMethod,
    required List<String> initialMemberIds,
    required Map<String, double> initialDetails,
  }) {
    return showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => B03SplitMethodEditBottomSheet(
        totalAmount: totalAmount,
        selectedCurrency: selectedCurrency,
        allMembers: allMembers,
        defaultMemberWeights: defaultMemberWeights,
        exchangeRate: exchangeRate,
        baseCurrency: baseCurrency,
        initialSplitMethod: initialSplitMethod,
        initialMemberIds: initialMemberIds,
        initialDetails: initialDetails,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => B03SplitMethodEditViewModel(
        totalAmount: totalAmount,
        selectedCurrency: selectedCurrency,
        allMembers: allMembers,
        defaultMemberWeights: defaultMemberWeights,
        exchangeRate: exchangeRate,
        baseCurrency: baseCurrency,
        initialSplitMethod: initialSplitMethod,
        initialMemberIds: initialMemberIds,
        initialDetails: initialDetails,
      )..init(),
      child: const _B03Content(),
    );
  }
}

class _B03Content extends StatelessWidget {
  const _B03Content();
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<B03SplitMethodEditViewModel>();
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final result = vm.getSplitResult();
    final int selectedIndex =
        SplitMethodConstant.allRules.indexOf(vm.splitMethod);

    //  使用 CommonBottomSheet
    return CommonBottomSheet(
      title: t.B03_SplitMethod_Edit.title,

      // 底部按鈕區：使用 .sheet 建構子
      bottomActionBar: StickyBottomActionBar.sheet(
        children: [
          AppButton(
            text: t.common.buttons.save,
            type: AppButtonType.primary,
            onPressed: vm.isValid
                ? () {
                    Navigator.pop(context, vm.save());
                  }
                : null,
          ),
        ],
      ),

      // 內容區：改為 Column 結構，實現「上方固定，下方捲動」
      children: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: CustomSlidingSegment<int>(
              selectedValue: selectedIndex,
              onValueChanged: (val) {
                vm.switchMethod(SplitMethodConstant.allRules[val]);
              },
              segments: {
                0: SplitMethodConstant.getLabel(
                    context, SplitMethodConstant.even),
                1: SplitMethodConstant.getLabel(
                    context, SplitMethodConstant.exact),
                2: SplitMethodConstant.getLabel(
                    context, SplitMethodConstant.percent),
              },
            ),
          ),
          // 1. Info Bar (金額 & 方式) - 固定在上方
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SummaryRow(
                    label: t.S15_Record_Edit.label.amount,
                    amount: vm.totalAmount,
                    currencyConstants: vm.selectedCurrency),
                if (vm.exchangeRate != 1.0) ...[
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      "≈ ${vm.baseCurrency.code}${vm.baseCurrency.symbol} ${CurrencyConstants.formatAmount(result.totalAmount.base, vm.baseCurrency.code)}",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Divider(
                  height: 1,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
                ),
                InfoBar(
                  icon: Icons.savings_outlined,
                  backgroundColor: colorScheme.surface,
                  text: Text(
                    t.common.remainder_rule.message_remainder(
                        amount:
                            "${vm.baseCurrency.code}${vm.baseCurrency.symbol} ${CurrencyConstants.formatAmount(vm.selectedMemberIds.isEmpty ? 0 : result.remainder, vm.baseCurrency.code)}"),
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

          // 2. Content Area - 捲動區
          // 使用 Expanded 佔滿剩餘高度，內部使用 ListView 實現捲動
          Expanded(
            child: ListView(
              children: [
                // 注意：這裡假設您的原始檔案中有定義 _buildEvenSection 等方法
                // 否則這裡會報錯。如果您需要我補上這些方法的空殼或實作，請告知。
                if (vm.splitMethod == SplitMethodConstant.even)
                  _buildEvenSection(vm, theme),
                if (vm.splitMethod == SplitMethodConstant.percent)
                  _buildPercentSection(vm, theme),
                if (vm.splitMethod == SplitMethodConstant.exact)
                  _buildExactSection(vm, theme, t),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Method 1: Even (平分) ---
  Widget _buildEvenSection(B03SplitMethodEditViewModel vm, ThemeData theme) {
    // 使用新的計算邏輯
    final result = vm.getSplitResult();
    final memberAmounts = result.memberAmounts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...vm.allMembers.map((m) {
          final id = m['id'];
          final isSelected = vm.selectedMemberIds.contains(id);
          final amount = memberAmounts[id]?.original ?? 0.0;
          final baseAmount = memberAmounts[id]?.base ?? 0.0;

          return SelectionTile(
            isSelected: isSelected,
            isRadio: false,
            onTap: () => vm.toggleMember(id),
            leading: CommonAvatar(
                avatarId: m['avatar'],
                name: m['displayName'],
                isLinked: m['isLinked'] ?? false),
            title: m['displayName'],
            trailing: Visibility(
              visible: isSelected,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${vm.selectedCurrency.symbol} ${CurrencyConstants.formatAmount(amount, vm.selectedCurrency.code)}",
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  if (vm.exchangeRate != 1.0)
                    Builder(builder: (context) {
                      final baseCurrency =
                          CurrencyConstants.getCurrencyConstants(
                              vm.baseCurrency.code);
                      return Text(
                        "≈ ${baseCurrency.code}${baseCurrency.symbol} ${CurrencyConstants.formatAmount(baseAmount, baseCurrency.code)}",
                        style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant),
                      );
                    }),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  // --- Method 2: Percent (比例) ---
  Widget _buildPercentSection(B03SplitMethodEditViewModel vm, ThemeData theme) {
    final result = vm.getSplitResult();
    final memberAmounts = result.memberAmounts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...vm.allMembers.map((m) {
          final id = m['id'];
          final weight = vm.details[id] ?? 0.0;
          final isSelected = weight > 0;
          final amount = memberAmounts[id]?.original ?? 0.0;
          final baseAmount = memberAmounts[id]?.base ?? 0.0;

          return SelectionTile(
            isSelected: isSelected,
            isRadio: false,
            onTap: () => vm.toggleMember(id),
            leading: CommonAvatar(
                avatarId: m['avatar'],
                name: m['displayName'],
                isLinked: m['isLinked'] ?? false),
            title: m['displayName'],
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    if (isSelected) ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${vm.selectedCurrency.symbol} ${CurrencyConstants.formatAmount(amount, vm.selectedCurrency.code)}",
                            style: theme.textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          if (vm.exchangeRate != 1.0)
                            Builder(builder: (context) {
                              final baseCurrency =
                                  CurrencyConstants.getCurrencyConstants(
                                      vm.baseCurrency.code);
                              return Text(
                                "≈ ${baseCurrency.code}${baseCurrency.symbol} ${CurrencyConstants.formatAmount(baseAmount, baseCurrency.code)}",
                                style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant),
                              );
                            }),
                        ],
                      ),
                    ]
                  ],
                ),
                const SizedBox(height: 8),
                AppStepper(
                  text: SplitRatioHelper.format(weight),
                  onDecrease: () => vm.updatePercent(id, false),
                  onIncrease: () => vm.updatePercent(id, true),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // --- Method 3: Exact (金額) ---
  Widget _buildExactSection(
      B03SplitMethodEditViewModel vm, ThemeData theme, Translations t) {
    final currentSum = vm.details.values.fold(0.0, (sum, v) => sum + v);
    final isMatched = (vm.totalAmount - currentSum).abs() < 0.1;
    final result = vm.getSplitResult();
    final memberAmounts = result.memberAmounts;

    return Column(
      children: [
        const SizedBox(height: 12),
        SummaryRow(
          label: t.B03_SplitMethod_Edit.label.total(
              current: CurrencyConstants.formatAmount(
                  currentSum, vm.selectedCurrency.code),
              target: CurrencyConstants.formatAmount(
                  vm.totalAmount, vm.selectedCurrency.code)),
          amount: 0,
          currencyConstants: vm.selectedCurrency,
          customValueText: isMatched ? "OK" : t.B03_SplitMethod_Edit.mismatch,
          valueColor:
              isMatched ? theme.colorScheme.tertiary : theme.colorScheme.error,
        ),
        const SizedBox(height: 8),
        ...vm.allMembers.map((m) {
          final id = m['id'];
          final isSelected = vm.selectedMemberIds.contains(id);
          final baseAmount = memberAmounts[id]?.base ?? 0.0;

          return SelectionTile(
            isSelected: isSelected,
            isRadio: false,
            onTap: () => vm.toggleMember(id),
            leading: CommonAvatar(
                avatarId: m['avatar'],
                name: m['displayName'],
                isLinked: m['isLinked'] ?? false),
            title: m['displayName'],
            trailing: SizedBox(
              width: 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CompactAmountInput(
                    controller: vm.amountControllers[id],
                    onChanged: (val) => vm.updateAmount(id, val),
                    hintText: '0',
                    currencyConstants: vm.selectedCurrency,
                  ),
                  if (isSelected && vm.exchangeRate != 1.0)
                    Builder(
                      builder: (context) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            "≈ ${vm.baseCurrency.code}${vm.baseCurrency.symbol} ${CurrencyConstants.formatAmount(baseAmount, vm.baseCurrency.code)}",
                            style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
