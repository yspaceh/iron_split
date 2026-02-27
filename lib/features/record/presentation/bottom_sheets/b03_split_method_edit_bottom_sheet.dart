import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/constants/split_method_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:iron_split/core/utils/split_ratio_helper.dart';
import 'package:iron_split/features/common/presentation/view/common_state_view.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/app_stepper.dart';
import 'package:iron_split/features/common/presentation/widgets/form/app_keyboard_actions_wrapper.dart';
import 'package:iron_split/features/common/presentation/widgets/form/compact_amount_input.dart';
import 'package:iron_split/features/common/presentation/widgets/selection_tile.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar.dart';
import 'package:iron_split/features/common/presentation/bottom_sheets/common_bottom_sheet.dart';
import 'package:iron_split/features/common/presentation/widgets/custom_sliding_segment.dart';
import 'package:iron_split/features/common/presentation/widgets/info_bar.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/record/presentation/viewmodels/b03_split_method_edit_vm.dart';
import 'package:iron_split/features/settlement/presentation/widgets/summary_row.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:provider/provider.dart';

class B03SplitMethodEditBottomSheet extends StatelessWidget {
  final double totalAmount;
  final CurrencyConstants selectedCurrency;
  final List<TaskMember> allMembers;
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
    required List<TaskMember> allMembers,
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
        authRepo: context.read<AuthRepository>(),
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

class _B03Content extends StatefulWidget {
  const _B03Content();

  @override
  State<_B03Content> createState() => _B03ContentState();
}

class _B03ContentState extends State<_B03Content> {
  final Map<String, FocusNode> _focusNodes = {};
  @override
  void dispose() {
    //  2. [新增] 釋放所有 Node
    for (var node in _focusNodes.values) {
      node.dispose();
    }
    super.dispose();
  }

  //  3. [新增] Helper 方法：取得或建立 Node
  FocusNode _getFocusNode(String memberId) {
    if (!_focusNodes.containsKey(memberId)) {
      _focusNodes[memberId] = FocusNode();
    }
    return _focusNodes[memberId]!;
  }

  void _handleSwitchSegmentedIndex(B03SplitMethodEditViewModel vm, int index) {
    vm.setSegmentedIndex(SplitMethodConstant.allRules[index]);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<B03SplitMethodEditViewModel>();
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final result = vm.getSplitResult();
    final int selectedIndex =
        SplitMethodConstant.allRules.indexOf(vm.splitMethod);
    final title = t.b03_split_method_edit.title;
    final activeNodes = vm.allMembers.map((m) => _getFocusNode(m.id)).toList();
    final displayState = context.read<DisplayState>();
    final isEnlarged = displayState.isEnlarged;

    //  使用 CommonBottomSheet
    return AppKeyboardActionsWrapper(
      focusNodes: activeNodes,
      child: CommonStateView(
        status: vm.initStatus,
        title: title,
        errorCode: vm.initErrorCode,
        isSheetMode: true,
        child: CommonBottomSheet(
          title: title,
          // 底部按鈕區：使用 .sheet 建構子
          bottomActionBar: vm.initStatus == LoadStatus.success
              ? StickyBottomActionBar.sheet(
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
                )
              : null,

          // 內容區：改為 Column 結構，實現「上方固定，下方捲動」
          children: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppLayout.spaceS),
                child: CustomSlidingSegment<int>(
                  selectedValue: selectedIndex,
                  isSheetMode: true,
                  onValueChanged: (val) => _handleSwitchSegmentedIndex(vm, val),
                  segments: {
                    0: SplitMethodConstant.getLabel(
                        context, SplitMethodConstant.even, t),
                    1: SplitMethodConstant.getLabel(
                        context, SplitMethodConstant.exact, t),
                    2: SplitMethodConstant.getLabel(
                        context, SplitMethodConstant.percent, t),
                  },
                ),
              ),
              // 1. Info Bar (金額 & 方式) - 固定在上方
              Padding(
                padding: EdgeInsets.only(top: AppLayout.spaceS),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SummaryRow(
                        label: t.common.label.amount,
                        amount: vm.totalAmount,
                        currencyConstants: vm.selectedCurrency),
                    if (vm.exchangeRate != 1.0) ...[
                      const SizedBox(height: AppLayout.spaceXS),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppLayout.spaceS),
                        child: Text(
                          "≈ ${vm.baseCurrency.code}${vm.baseCurrency.symbol} ${CurrencyConstants.formatAmount(result.totalAmount.base, vm.baseCurrency.code)}",
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: AppLayout.spaceL),
                    Divider(
                      height: 1,
                      color:
                          colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
                    ),
                    InfoBar(
                      icon: Icons.savings_outlined,
                      backgroundColor: colorScheme.surface,
                      text: Text(
                        t.common.remainder_rule.message.remainder(
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
                      _buildEvenSection(vm, colorScheme, textTheme),
                    if (vm.splitMethod == SplitMethodConstant.percent)
                      _buildPercentSection(
                          vm, colorScheme, textTheme, isEnlarged),
                    if (vm.splitMethod == SplitMethodConstant.exact)
                      _buildExactSection(
                          vm, t, colorScheme, textTheme, isEnlarged),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Method 1: Even (平分) ---
  Widget _buildEvenSection(B03SplitMethodEditViewModel vm,
      ColorScheme colorScheme, TextTheme textTheme) {
    // 使用新的計算邏輯
    final result = vm.getSplitResult();
    final memberAmounts = result.memberAmounts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...vm.allMembers.map((m) {
          final id = m.id;
          final isSelected = vm.selectedMemberIds.contains(id);
          final amount = memberAmounts[id]?.original ?? 0.0;
          final baseAmount = memberAmounts[id]?.base ?? 0.0;

          return SelectionTile(
            isSelected: isSelected,
            isRadio: false,
            onTap: () => vm.toggleMember(id),
            leading: CommonAvatar(
                avatarId: m.avatar, name: m.displayName, isLinked: m.isLinked),
            title: m.displayName,
            trailing: Visibility(
              visible: isSelected,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${vm.selectedCurrency.symbol} ${CurrencyConstants.formatAmount(amount, vm.selectedCurrency.code)}",
                    style: textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  if (vm.exchangeRate != 1.0)
                    Builder(builder: (context) {
                      final baseCurrency =
                          CurrencyConstants.getCurrencyConstants(
                              vm.baseCurrency.code);
                      return Text(
                        "≈ ${baseCurrency.code}${baseCurrency.symbol} ${CurrencyConstants.formatAmount(baseAmount, baseCurrency.code)}",
                        style: textTheme.bodySmall
                            ?.copyWith(color: colorScheme.onSurfaceVariant),
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
  Widget _buildPercentSection(B03SplitMethodEditViewModel vm,
      ColorScheme colorScheme, TextTheme textTheme, bool isEnlarged) {
    final result = vm.getSplitResult();
    final memberAmounts = result.memberAmounts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...vm.allMembers.map((m) {
          final id = m.id;
          final weight = vm.details[id] ?? 0.0;
          final isSelected = weight > 0;
          final amount = memberAmounts[id]?.original ?? 0.0;
          final baseAmount = memberAmounts[id]?.base ?? 0.0;
          final displayState = context.watch<DisplayState>();
          final isEnglarged = displayState.isEnlarged;

          return SelectionTile(
            isSelected: isSelected,
            isRadio: false,
            onTap: () => vm.toggleMember(id),
            leading: CommonAvatar(
                avatarId: m.avatar, name: m.displayName, isLinked: m.isLinked),
            title: m.displayName,
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: isEnglarged
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    if (isSelected) ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${vm.selectedCurrency.symbol} ${CurrencyConstants.formatAmount(amount, vm.selectedCurrency.code)}",
                            style: textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          if (vm.exchangeRate != 1.0)
                            Builder(builder: (context) {
                              final baseCurrency =
                                  CurrencyConstants.getCurrencyConstants(
                                      vm.baseCurrency.code);
                              return Text(
                                "≈ ${baseCurrency.code}${baseCurrency.symbol} ${CurrencyConstants.formatAmount(baseAmount, baseCurrency.code)}",
                                style: textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant),
                              );
                            }),
                        ],
                      ),
                    ]
                  ],
                ),
                SizedBox(
                    height: isEnlarged ? AppLayout.spaceL : AppLayout.spaceS),
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
  Widget _buildExactSection(B03SplitMethodEditViewModel vm, Translations t,
      ColorScheme colorScheme, TextTheme textTheme, bool isEnlarged) {
    final currentSum = vm.details.values.fold(0.0, (sum, v) => sum + v);
    final isMatched = (vm.totalAmount - currentSum).abs() < 0.1;
    final result = vm.getSplitResult();
    final memberAmounts = result.memberAmounts;

    return Column(
      children: [
        const SizedBox(height: AppLayout.spaceM),
        SummaryRow(
          label: t.b03_split_method_edit.label.total(
              current: CurrencyConstants.formatAmount(
                  currentSum, vm.selectedCurrency.code),
              target: CurrencyConstants.formatAmount(
                  vm.totalAmount, vm.selectedCurrency.code)),
          amount: 0,
          currencyConstants: vm.selectedCurrency,
          customValueText: isMatched ? "OK" : t.b03_split_method_edit.mismatch,
          valueColor: isMatched ? colorScheme.tertiary : colorScheme.error,
        ),
        SizedBox(height: isEnlarged ? AppLayout.spaceL : AppLayout.spaceS),
        ...vm.allMembers.map((m) {
          final id = m.id;
          final isSelected = vm.selectedMemberIds.contains(id);
          final baseAmount = memberAmounts[id]?.base ?? 0.0;

          return SelectionTile(
            isSelected: isSelected,
            isRadio: false,
            onTap: () => vm.toggleMember(id),
            leading: CommonAvatar(
                avatarId: m.avatar, name: m.displayName, isLinked: m.isLinked),
            title: m.displayName,
            trailing: SizedBox(
              width: 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CompactAmountInput(
                    controller: vm.amountControllers[id],
                    focusNode: _getFocusNode(id),
                    onChanged: (val) => vm.updateAmount(id, val),
                    hintText: '0',
                    currencyConstants: vm.selectedCurrency,
                  ),
                  if (isSelected && vm.exchangeRate != 1.0)
                    Builder(
                      builder: (context) {
                        return Padding(
                          padding:
                              const EdgeInsets.only(top: AppLayout.spaceXS),
                          child: Text(
                            "≈ ${vm.baseCurrency.code}${vm.baseCurrency.symbol} ${CurrencyConstants.formatAmount(baseAmount, vm.baseCurrency.code)}",
                            style: textTheme.bodySmall
                                ?.copyWith(color: colorScheme.onSurfaceVariant),
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
