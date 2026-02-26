import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/models/settlement_model.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:iron_split/features/common/presentation/view/common_state_view.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar.dart';
import 'package:iron_split/features/common/presentation/bottom_sheets/common_bottom_sheet.dart';
import 'package:iron_split/features/common/presentation/widgets/selection_tile.dart'; //
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/settlement/presentation/viewmodels/b04_payment_merge_vm.dart';
import 'package:iron_split/features/settlement/presentation/widgets/summary_row.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:provider/provider.dart';

class B04PaymentMergeBottomSheet extends StatelessWidget {
  final SettlementMember headMember;
  final List<SettlementMember> candidateMembers;
  final List<String> initialMergedIds;
  final CurrencyConstants baseCurrency;

  const B04PaymentMergeBottomSheet({
    super.key,
    required this.headMember,
    required this.candidateMembers,
    required this.initialMergedIds,
    required this.baseCurrency,
  });

  static Future<List<String>?> show(
    BuildContext context, {
    required SettlementMember headMember,
    required List<SettlementMember> candidateMembers,
    required List<String> initialMergedIds,
    required CurrencyConstants baseCurrency,
  }) {
    return showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      enableDrag: true,
      builder: (context) => B04PaymentMergeBottomSheet(
        headMember: headMember,
        candidateMembers: candidateMembers,
        initialMergedIds: initialMergedIds,
        baseCurrency: baseCurrency,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => B04PaymentMergeViewModel(
        authRepo: context.read<AuthRepository>(),
        headMember: headMember,
        candidateMembers: candidateMembers,
        baseCurrency: baseCurrency,
        initialMergedIds: initialMergedIds,
      )..init(),
      child: const _B04Content(),
    );
  }
}

class _B04Content extends StatelessWidget {
  const _B04Content();

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final vm = context.watch<B04PaymentMergeViewModel>();
    final title = t.B04_payment_merge.title;

    return CommonStateView(
      status: vm.initStatus,
      errorCode: vm.initErrorCode,
      title: title,
      isSheetMode: true,
      child: CommonBottomSheet(
        title: title, // "合併成員款項"
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
              onPressed: () => context.pop(vm.getResult()),
            ),
          ],
        ),
        children: ListView(
          padding: const EdgeInsets.symmetric(vertical: AppLayout.spaceL),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppLayout.spaceS),
              child: Column(
                children: [
                  SummaryRow(
                    label: t.B04_payment_merge.label.merge_amount,
                    amount: vm.totalAmount,
                    currencyConstants: vm.baseCurrency,
                    valueColor: vm.headMember.finalAmount > 0
                        ? colorScheme.tertiary
                        : colorScheme.primary,
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(
                height: 1,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
              ),
            ),

            //  1. 代表成員 (Head Member) - 放在列表最上面，鎖定
            SelectionTile(
              isSelected: true, // 永遠選中
              isRadio: false,
              onTap: null, // 禁止點擊 (鎖定狀態)
              // 為了讓鎖定的 checkbox 看起來不同，可以考慮給一個 disabled 的顏色
              // 但如果 SelectionTile 內部有處理 null onTap 的樣式則不必
              leading: CommonAvatar(
                avatarId: vm.headMember.memberData.avatar,
                name: vm.headMember.memberData.displayName,
                isLinked: vm.headMember.memberData.isLinked,
                radius: 20,
              ),
              // [修改] 標題加上 "(代表成員)"
              title:
                  "${vm.headMember.memberData.displayName} - ${t.B04_payment_merge.label.head_member}",
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${vm.baseCurrency.symbol} ${CurrencyConstants.formatAmount(vm.headMember.finalAmount.abs(), vm.baseCurrency.code)}",
                    style: textTheme.bodyMedium?.copyWith(
                      color: vm.headMember.finalAmount > 0
                          ? colorScheme.tertiary
                          : colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'RobotoMono',
                    ),
                  ),
                ],
              ),
            ),

            // 2. Candidates List (候選名單)
            // 這裡顯示 VM 傳過來的完整候選名單 (包含已合併)
            if (vm.candidateMembers.isEmpty)
              Container()
            else
              ...vm.candidateMembers.map((member) {
                final isSelected =
                    vm.isSelected(member.memberData.id); // 從 VM 判斷
                final amountStr = CurrencyConstants.formatAmount(
                    member.finalAmount.abs(), vm.baseCurrency.code);

                return SelectionTile(
                  isSelected: isSelected,
                  isRadio: false, // Checkbox 樣式
                  onTap: () => vm.toggleSelection(member.memberData.id),
                  leading: CommonAvatar(
                    avatarId: member.memberData.avatar,
                    name: member.memberData.displayName,
                    isLinked: member.memberData.isLinked,
                    radius: 20,
                  ),
                  title: member.memberData.displayName,
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${vm.baseCurrency.symbol} $amountStr",
                        style: textTheme.bodyMedium?.copyWith(
                          color: member.finalAmount > 0
                              ? colorScheme.tertiary
                              : colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'RobotoMono',
                        ),
                      ),
                    ],
                  ),
                );
              }),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
