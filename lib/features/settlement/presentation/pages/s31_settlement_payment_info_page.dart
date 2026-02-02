// lib/features/settlement/presentation/pages/s31_settlement_payment_info_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/features/common/presentation/widgets/add_outlined_button.dart';
import 'package:provider/provider.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:iron_split/core/models/payment_info_model.dart';

// ViewModels & Widgets
import 'package:iron_split/features/settlement/presentation/viewmodels/s31_settlement_payment_info_vm.dart';
import 'package:iron_split/features/settlement/presentation/widgets/step_dots.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';

// [NOTE]: 這裡需要一個簡化版的摘要卡片，或者沿用 GroupBalanceCard
// 為了 DRY，這裡假設您可以傳入 totalAmount 等資訊，或是直接顯示靜態文字
// 實際專案中請引用 S30 的 ViewModel 或參數

class S31SettlementPaymentInfoPage extends StatelessWidget {
  final String taskId;

  // 實務上 S30 轉場時會把摘要資料傳過來 (extra)，這裡簡化處理
  const S31SettlementPaymentInfoPage({
    super.key,
    required this.taskId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => S31SettlementPaymentInfoViewModel(taskId: taskId)..init(),
      child: const _S31Content(),
    );
  }
}

class _S31Content extends StatelessWidget {
  const _S31Content();

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final vm = context.watch<S31SettlementPaymentInfoViewModel>();

    void onSubmit() async {
      final info = await vm.submit();
      if (context.mounted) {
        // 前往 D06 確認，並帶上 PaymentInfo
        // context.pushNamed('D06', extra: info);
        // [Demo]: 僅印出資料
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data ready: ${info.mode.name}')));
      }
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(t.s31_settlement_payment_info.title), // 需新增 i18n
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          StepDots(currentStep: 2, totalSteps: 2), // Step 2/2
          const SizedBox(width: 24),
        ],
      ),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. 頂部摘要 (Placeholder)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      // [M3]: 使用 surfaceContainer (或 surfaceContainerLow) 作為容器背景
                      // 這比 secondaryContainer 更中性，適合這種「提示資訊」
                      color: colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // 讓 Icon 對齊文字頂部
                      children: [
                        // 1. 左側 Icon (隱私/安全相關)
                        Icon(
                          Icons
                              .privacy_tip_outlined, // 或 verified_user_outlined
                          size: 24,
                          color: colorScheme.primary, // 使用主色調來傳遞「系統保證」的信任感
                        ),
                        const SizedBox(width: 16), // M3 標準間距

                        // 2. 右側說明文字
                        Expanded(
                          child: Text(
                            t.s31_settlement_payment_info
                                .setup_instruction, // 剛修訂過的精簡文案
                            style: textTheme.bodyMedium?.copyWith(
                              color:
                                  colorScheme.onSurfaceVariant, // M3 建議的次要內容文字色
                              height: 1.5, // 增加行高，提升閱讀舒適度
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 2. 模式選擇 (Radio Group)
                  Text(t.common.payment_info.method_label,
                      style: textTheme.titleMedium),
                  const SizedBox(height: 8),

                  _buildRadioOption(
                    context,
                    value: PaymentMode.private,
                    groupValue: vm.mode,
                    label: t.common.payment_info.mode_private, // "私訊聯絡"
                    desc: t.common.payment_info
                        .mode_private_desc, // "不顯示收款資訊，請成員直接詢問"
                    onChanged: (v) => vm.setMode(v!),
                  ),
                  _buildRadioOption(
                    context,
                    value: PaymentMode.specific,
                    groupValue: vm.mode,
                    label: t.common.payment_info.mode_public, // "提供收款資訊"
                    desc:
                        t.common.payment_info.mode_public_desc, // "顯示銀行帳號或支付連結"
                    onChanged: (v) => vm.setMode(v!),
                  ),

                  // 3. 詳細輸入區 (Condition)
                  if (vm.mode == PaymentMode.specific) ...[
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),

                    // A. 現金
                    CheckboxListTile(
                      value: vm.acceptCash,
                      onChanged: vm.toggleAcceptCash,
                      title: Text(t.common.payment_info.type_cash),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),

                    // B. 銀行轉帳
                    CheckboxListTile(
                      value: vm.enableBank,
                      onChanged: vm.toggleEnableBank,
                      title: Text(t.common.payment_info.type_bank),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                    if (vm.enableBank)
                      Padding(
                        padding: const EdgeInsets.only(left: 40, bottom: 16),
                        child: Column(
                          children: [
                            TextField(
                              controller: vm.bankNameCtrl,
                              decoration: InputDecoration(
                                labelText: t.common.payment_info
                                    .bank_name_hint, // "銀行代碼 / 名稱"
                                isDense: true,
                                border: const OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: vm.bankAccountCtrl,
                              decoration: InputDecoration(
                                labelText: t.common.payment_info
                                    .bank_account_hint, // "帳號"
                                isDense: true,
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // C. 其他支付 App
                    CheckboxListTile(
                      value: vm.enableApps,
                      onChanged: vm.toggleEnableApps,
                      title: Text(t.common.payment_info.type_apps),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                    if (vm.enableApps) ...[
                      ...vm.appControllers.asMap().entries.map((entry) {
                        final index = entry.key;
                        final ctrl = entry.value;
                        return Container(
                          // [視覺分組關鍵]: 使用 Container 包裹，並給予淺色背景
                          margin: const EdgeInsets.only(left: 40, bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            // M3: 使用 surfaceContainerLow (或 lowest) 來做為區塊背景
                            borderRadius: BorderRadius.circular(12),
                            // 選用：加個極細邊框讓邊界更清晰
                            border: Border.all(
                                color: colorScheme.outlineVariant
                                    .withValues(alpha: 0.5)),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // 第一行：App 名稱 + 刪除按鈕
                              Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment.center, // 對齊中心
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: ctrl.nameCtrl,
                                      decoration: InputDecoration(
                                        labelText: t.common.payment_info
                                            .app_name, // "App 名稱"
                                        hintText: "e.g. LinePay", // 可選：給個提示
                                        isDense: true,
                                        // M3: 在有背景色的容器內，可以使用 filled: true + fillColors.surface
                                        // 或者保持 outline，這裡維持 outline 比較清爽
                                        border: const OutlineInputBorder(),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 12),
                                      ),
                                    ),
                                  ),
                                  // 刪除按鈕 (緊跟在名稱旁邊)
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    // 使用 onSurfaceVariant 顏色比較不那麼刺眼，除非要強調危險
                                    color: colorScheme.onSurfaceVariant,
                                    onPressed: () => vm.removeApp(index),
                                    tooltip: t.common.buttons.delete,
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12), // 上下行的間距

                              // 第二行：連結/ID (獨佔一行，顯示完整內容)
                              TextField(
                                controller: ctrl.linkCtrl,
                                decoration: InputDecoration(
                                  labelText: t.common.payment_info
                                      .app_link, // "連結 / ID"
                                  isDense: true,
                                  border: const OutlineInputBorder(),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 12),
                                  // 可選：加上連結圖示，強化語意
                                  prefixIcon: const Icon(Icons.link, size: 20),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      // 新增按鈕
                      Padding(
                        padding: const EdgeInsets.only(left: 40),
                        child: AddOutlinedButton(
                          onPressed: vm.addApp,
                        ),
                      ),
                    ],
                  ],

                  // 底部留白，避免鍵盤遮擋
                  const SizedBox(height: 80),
                ],
              ),
            ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Sync Checkbox (Smart Display)
          if (vm.showSyncOption && vm.mode == PaymentMode.specific)
            Container(
              color: colorScheme.surfaceContainerLow,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: CheckboxListTile(
                value: vm.isSyncChecked,
                onChanged: vm.toggleSync,
                title: Text(
                  vm.isUpdate
                      ? t.s31_settlement_payment_info
                          .sync_update // "更新我的預設收款資訊"
                      : t.s31_settlement_payment_info.sync_save, // "儲存為預設收款資訊"
                  style: textTheme.bodySmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                dense: true,
                contentPadding: EdgeInsets.zero,
                activeColor: colorScheme.primary,
              ),
            ),

          StickyBottomActionBar(
            children: [
              AppButton(
                text: t.s31_settlement_payment_info.buttons.prev_step,
                type: AppButtonType.secondary,
                onPressed: () => context.pop(),
              ),
              AppButton(
                text: t.s31_settlement_payment_info.buttons.settle, // "結算"
                type: AppButtonType.primary,
                onPressed: onSubmit,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption(
    BuildContext context, {
    required PaymentMode value,
    required PaymentMode groupValue,
    required String label,
    required String desc,
    required ValueChanged<PaymentMode?> onChanged,
  }) {
    final theme = Theme.of(context);
    final isSelected = value == groupValue;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.1)
            : null,
        border: Border.all(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.outlineVariant,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: RadioListTile<PaymentMode>(
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
        title: Text(
          label,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: theme.colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          desc,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        activeColor: theme.colorScheme.primary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }
}
