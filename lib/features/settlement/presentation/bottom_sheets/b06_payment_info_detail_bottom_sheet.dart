import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/models/payment_info_model.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/common_bottom_sheet.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:iron_split/features/settlement/presentation/bottom_sheets/b05_payment_info_edit_bottom_sheet.dart';
import 'package:iron_split/gen/strings.g.dart';

/// B06: 收款資訊詳情 (ReadOnly)
class B06PaymentInfoDetailBottomSheet extends StatelessWidget {
  final TaskModel task;
  final bool isCaptain;

  const B06PaymentInfoDetailBottomSheet({
    super.key,
    required this.task,
    required this.isCaptain,
  });

  static void show(BuildContext context,
      {required TaskModel task, required bool isCaptain}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) =>
          B06PaymentInfoDetailBottomSheet(task: task, isCaptain: isCaptain),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    // 從 Task 解析 ReceiverInfo
    PaymentInfoModel? info;
    try {
      if (task.settlement != null &&
          task.settlement!['receiverInfos'] != null) {
        info = PaymentInfoModel.fromJson(task.settlement!['receiverInfos']);
      }
    } catch (_) {
      // JSON 解析失敗視為無資料
    }

    // 判定是否為 Private 模式 (Mode 為 private 或全部沒填)
    final isPrivate = info == null || info.mode == PaymentMode.private;

    return CommonBottomSheet(
      title: t.S31_settlement_payment_info.title,
      bottomActionBar: StickyBottomActionBar.sheet(
        children: [
          if (isCaptain)
            AppButton(
              text: t.common.buttons.edit,
              type: AppButtonType.secondary,
              onPressed: () {
                context.pop(); // 關閉 B06
                // 開啟 B05
                B05PaymentinfoEditBottomSheet.show(context, task: task);
              },
            ),
          AppButton(
            text: t.common.buttons.close,
            type: AppButtonType.primary,
            onPressed: () => context.pop(),
          ),
        ],
      ),
      children: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isPrivate)
              Text(t.common.payment_info.mode_private)
            else
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (info.acceptCash) _buildCashTile(context, t),
                      if (info.bankAccount != null &&
                          info.bankAccount!.isNotEmpty)
                        _buildBankSection(context, info),
                      if (info.paymentApps.isNotEmpty)
                        _buildAppsSection(context, info.paymentApps),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCashTile(BuildContext context, Translations t) {
    return ListTile(
      leading: const Icon(Icons.money),
      title: Text(t.common.payment_info.type_cash),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildBankSection(BuildContext context, PaymentInfoModel info) {
    final theme = Theme.of(context);
    final copyText = "${info.bankName ?? ''}\n${info.bankAccount}".trim();

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(t.common.payment_info.type_bank,
                  style: theme.textTheme.labelLarge),
              IconButton(
                icon: const Icon(Icons.copy, size: 20),
                onPressed: () => _copyToClipboard(context, copyText),
                tooltip: t.B06_payment_info_detail.buttons.copy,
              ),
            ],
          ),
          const SizedBox(height: 4),
          if (info.bankName != null && info.bankName!.isNotEmpty)
            Text(info.bankName!, style: theme.textTheme.bodyMedium),
          Text(
            info.bankAccount!,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontFamily: 'RobotoMono',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppsSection(BuildContext context, List<PaymentAppInfo> apps) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        ...apps.map((app) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(Icons.apps_outlined),
              ),
              title: Text(app.name),
              subtitle: app.link.isNotEmpty ? Text(app.link) : null,
              trailing: IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () => _copyToClipboard(
                    context, app.link.isNotEmpty ? app.link : app.name),
              ),
            )),
      ],
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    final t = Translations.of(context);
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(t.B06_payment_info_detail.label_copied),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
