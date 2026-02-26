import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar.dart';
import 'package:iron_split/features/common/presentation/bottom_sheets/common_bottom_sheet.dart';
import 'package:iron_split/features/common/presentation/widgets/form/app_keyboard_actions_wrapper.dart';
import 'package:iron_split/features/common/presentation/widgets/form/compact_amount_input.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_amount_input.dart';
import 'package:iron_split/features/common/presentation/widgets/selection_card.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/record/presentation/viewmodels/b07_payment_method_edit_vm.dart';
import 'package:iron_split/features/settlement/presentation/widgets/summary_row.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:provider/provider.dart';

class B07PaymentMethodEditBottomSheet extends StatelessWidget {
  final double totalAmount; // 該筆費用的總金額
  final Map<String, double> poolBalancesByCurrency;
  final List<TaskMember> members; // 成員清單
  final CurrencyConstants selectedCurrency;
  final CurrencyConstants baseCurrency;

  // 初始狀態
  final bool initialUsePrepay;
  final double initialPrepayAmount;
  final Map<String, double> initialMemberAdvance; // 成員代墊明細 {id: amount}

  const B07PaymentMethodEditBottomSheet({
    super.key,
    required this.totalAmount,
    required this.poolBalancesByCurrency,
    required this.members,
    this.initialUsePrepay = true,
    this.initialPrepayAmount = 0.0,
    this.initialMemberAdvance = const {},
    required this.selectedCurrency,
    required this.baseCurrency,
  });

  static Future<Map<String, dynamic>?> show(BuildContext context,
      {required double totalAmount, // 該筆費用的總金額
      required Map<String, double> poolBalancesByCurrency,
      required List<TaskMember> members, // 成員清單
      required CurrencyConstants selectedCurrency,
      required CurrencyConstants baseCurrency,
      bool initialUsePrepay = true,
      double initialPrepayAmount = 0.0,
      Map<String, double> initialMemberAdvance = const {}}) {
    return showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      enableDrag: true,
      builder: (context) => B07PaymentMethodEditBottomSheet(
        totalAmount: totalAmount,
        poolBalancesByCurrency: poolBalancesByCurrency,
        selectedCurrency: selectedCurrency,
        baseCurrency: baseCurrency,
        members: members,
        initialUsePrepay: initialUsePrepay,
        initialPrepayAmount: initialPrepayAmount,
        initialMemberAdvance: initialMemberAdvance,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => B07PaymentMethodEditViewModel(
        authRepo: context.read<AuthRepository>(),
        totalAmount: totalAmount,
        poolBalancesByCurrency: poolBalancesByCurrency,
        members: members,
        selectedCurrency: selectedCurrency,
      )..init(
          initialUsePrepay: initialUsePrepay,
          initialPrepayAmount: initialPrepayAmount,
          initialMemberAdvance: initialMemberAdvance,
        ),
      child: const _B07Content(),
    );
  }
}

class _B07Content extends StatefulWidget {
  const _B07Content();

  @override
  State<_B07Content> createState() => _B07ContentState();
}

class _B07ContentState extends State<_B07Content> {
  late FocusNode _prepayFocusNode;
  final Map<String, FocusNode> _memberFocusNodes = {}; // 用 Map 對應每個成員 ID

  @override
  void initState() {
    super.initState();
    _prepayFocusNode = FocusNode();
    final vm = context.read<B07PaymentMethodEditViewModel>();
    for (var m in vm.members) {
      _memberFocusNodes[m.id] = FocusNode();
    }
  }

  @override
  void dispose() {
    _prepayFocusNode.dispose();
    for (var node in _memberFocusNodes.values) {
      node.dispose();
    }
    super.dispose();
  }

  // --- UI 建構 ---

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final vm = context.watch<B07PaymentMethodEditViewModel>();
    final displayState = context.watch<DisplayState>();
    final isEnlarged = displayState.isEnlarged;

    final allNodes = [
      _prepayFocusNode,
      ..._memberFocusNodes.values, // 把 Map 裡所有的 Node 攤平加進來
    ];

    return AppKeyboardActionsWrapper(
      focusNodes: allNodes,
      child: CommonBottomSheet(
        title: t.B07_PaymentMethod_Edit.title,
        bottomActionBar: StickyBottomActionBar.sheet(
          children: [
            AppButton(
              text: t.common.buttons.cancel,
              type: AppButtonType.secondary,
              onPressed: () => context.pop(),
            ),
            AppButton(
              text: t.common.buttons.confirm,
              type: AppButtonType.primary,
              onPressed:
                  vm.isValid ? () => context.pop(vm.prepareResult()) : null,
            ),
          ],
        ),
        children: Column(
          children: [
            // 1. 固定高度的 Header
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  SummaryRow(
                    label: t.B07_PaymentMethod_Edit.label.amount,
                    amount: vm.totalAmount,
                    currencyConstants: vm.selectedCurrency,
                  ),
                  const SizedBox(height: AppLayout.spaceS),
                  // 即使金額為0也顯示，保持高度穩定
                  SummaryRow(
                    label: t.B07_PaymentMethod_Edit.label.prepay,
                    amount: vm.usePrepay ? vm.prepayAmount : 0.0,
                    currencyConstants: vm.selectedCurrency,
                  ),
                  const SizedBox(height: 4),
                  SummaryRow(
                    label: t.B07_PaymentMethod_Edit.label.total_advance,
                    amount: vm.useAdvance ? vm.currentAdvanceTotal : 0.0,
                    currencyConstants: vm.selectedCurrency,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(
                      height: 1,
                      color:
                          colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
                    ),
                  ),
                  SummaryRow(
                    label: vm.isValid
                        ? t.B07_PaymentMethod_Edit.status.balanced
                        : t.B07_PaymentMethod_Edit.status.remaining(
                            amount: CurrencyConstants.formatAmount(
                                vm.remaining.abs(), vm.selectedCurrency.code)),
                    amount: vm.remaining,
                    currencyConstants: vm.selectedCurrency,
                    hideAmount: true,
                    valueColor:
                        vm.isValid ? colorScheme.tertiary : colorScheme.error,
                    customValueText: vm.isValid ? "OK" : null,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppLayout.spaceL),

            // 2. 選擇區域
            Expanded(
              child: ListView(
                children: [
                  // A. 公款支付卡片
                  SelectionCard(
                    title: t.common.payment_method.prepay,
                    isSelected: vm.usePrepay,
                    isRadio: false,
                    onToggle: vm.onPrepayToggle,
                    // 如果收合時也想顯示金額在右側，可在此傳入 trailing
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 餘額提示
                        Text(
                          t.B07_PaymentMethod_Edit.prepay_balance(
                              amount:
                                  "${vm.selectedCurrency.code}${vm.selectedCurrency.symbol} ${CurrencyConstants.formatAmount(vm.currentCurrencyPoolBalance, vm.selectedCurrency.code)}"),
                          style: TextStyle(
                            color: vm.currentCurrencyPoolBalance <
                                        vm.totalAmount &&
                                    vm.usePrepay
                                ? colorScheme.error
                                : colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: AppLayout.spaceS),
                        TaskAmountInput(
                          amountController: vm.prepayController,
                          selectedCurrencyConstants: vm.selectedCurrency,
                          focusNode: _prepayFocusNode,
                          showCurrencyPicker: false, // 隱藏幣別選擇器
                          externalValidator: (val) {
                            if (val > vm.currentCurrencyPoolBalance) {
                              return t.B07_PaymentMethod_Edit.status.not_enough;
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppLayout.spaceL),

                  // B. 成員墊付卡片
                  SelectionCard(
                    title: t.common.payment_method.member,
                    isSelected: vm.useAdvance,
                    isRadio: false,
                    onToggle: vm.onAdvanceToggle,
                    child: Column(
                      children: vm.members.map((m) {
                        final id = m.id;
                        final avatar = CommonAvatar(
                          avatarId: m.avatar,
                          name: m.displayName,
                          radius: 18,
                          fontSize: 14,
                          isLinked: m.isLinked,
                        );
                        final name =
                            Text(m.displayName, style: textTheme.bodyLarge);
                        final amountInput = CompactAmountInput(
                          controller: vm.memberControllers[id],
                          focusNode: _memberFocusNodes[id],
                          onChanged: (val) =>
                              vm.onMemberAdvanceChanged(id, val),
                          hintText: '0',
                          currencyConstants: vm.selectedCurrency,
                        );
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: isEnlarged
                                  ? AppLayout.spaceL
                                  : AppLayout.spaceS),
                          child: isEnlarged
                              ? Column(
                                  children: [
                                    Row(children: [
                                      avatar,
                                      const SizedBox(width: AppLayout.spaceS),
                                      Expanded(
                                        child: name,
                                      ),
                                    ]),
                                    const SizedBox(height: AppLayout.spaceL),
                                    // 使用 Compact Input
                                    amountInput,
                                  ],
                                )
                              : Row(
                                  children: [
                                    avatar,
                                    const SizedBox(width: AppLayout.spaceS),
                                    Expanded(
                                      child: name,
                                    ),
                                    const SizedBox(width: AppLayout.spaceS),
                                    // 使用 Compact Input
                                    SizedBox(
                                      width: 120, // 限制寬度
                                      child: amountInput,
                                    ),
                                  ],
                                ),
                        );
                      }).toList(),
                    ),
                  ),

                  // 底部留白
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
