import 'package:flutter/material.dart';
import 'package:iron_split/core/models/payment_info_model.dart';
import 'package:iron_split/features/common/presentation/widgets/add_outlined_button.dart';
import 'package:iron_split/gen/strings.g.dart';

/// [Controller] 用於管理 PaymentInfoForm 的狀態
/// 讓 S31VM 和 B05VM 都可以直接操作表單數據
class PaymentInfoFormController extends ChangeNotifier {
  PaymentMode _mode = PaymentMode.private;
  bool _acceptCash = true;
  bool _enableBank = false;
  bool _enableApps = false;

  final TextEditingController bankNameCtrl = TextEditingController();
  final TextEditingController bankAccountCtrl = TextEditingController();
  final List<PaymentAppEditingController> appControllers = [];

  PaymentInfoFormController({
    PaymentInfoModel? initialData,
  }) {
    if (initialData != null) {
      _mode = initialData.mode;

      if (_mode == PaymentMode.specific) {
        _acceptCash = initialData.acceptCash;

        if (initialData.bankAccount != null &&
            initialData.bankAccount!.isNotEmpty) {
          _enableBank = true;
          bankNameCtrl.text = initialData.bankName ?? '';
          bankAccountCtrl.text = initialData.bankAccount!;
        }

        if (initialData.paymentApps.isNotEmpty) {
          _enableApps = true;
          for (var app in initialData.paymentApps) {
            appControllers.add(
                PaymentAppEditingController(name: app.name, link: app.link));
          }
        }
      }
    }
  }

  // Getters
  PaymentMode get mode => _mode;
  bool get acceptCash => _acceptCash;
  bool get enableBank => _enableBank;
  bool get enableApps => _enableApps;

  // Setters
  void setMode(PaymentMode value) {
    _mode = value;
    notifyListeners();
  }

  void toggleAcceptCash(bool? value) {
    _acceptCash = value ?? false;
    notifyListeners();
  }

  void toggleEnableBank(bool? value) {
    _enableBank = value ?? false;
    notifyListeners();
  }

  void toggleEnableApps(bool? value) {
    _enableApps = value ?? false;
    if (_enableApps && appControllers.isEmpty) {
      addApp();
    }
    notifyListeners();
  }

  void addApp() {
    appControllers.add(PaymentAppEditingController());
    notifyListeners();
  }

  void removeApp(int index) {
    appControllers[index].dispose();
    appControllers.removeAt(index);
    notifyListeners();
  }

  PaymentInfoModel buildModel() {
    // 如果是 Private 模式，回傳預設物件
    if (_mode == PaymentMode.private) {
      return const PaymentInfoModel(mode: PaymentMode.private);
    }

    final apps = _enableApps
        ? appControllers
            .where((c) => c.nameCtrl.text.isNotEmpty)
            .map((c) =>
                PaymentAppInfo(name: c.nameCtrl.text, link: c.linkCtrl.text))
            .toList()
        : <PaymentAppInfo>[];

    return PaymentInfoModel(
      mode: PaymentMode.specific,
      acceptCash: _acceptCash,
      bankName: _enableBank ? bankNameCtrl.text : null,
      bankAccount: _enableBank ? bankAccountCtrl.text : null,
      paymentApps: apps,
    );
  }

  @override
  void dispose() {
    bankNameCtrl.dispose();
    bankAccountCtrl.dispose();
    for (var c in appControllers) {
      c.dispose();
    }
    super.dispose();
  }
}

class PaymentAppEditingController {
  final TextEditingController nameCtrl;
  final TextEditingController linkCtrl;

  PaymentAppEditingController({String name = '', String link = ''})
      : nameCtrl = TextEditingController(text: name),
        linkCtrl = TextEditingController(text: link);

  void dispose() {
    nameCtrl.dispose();
    linkCtrl.dispose();
  }
}

/// [Widget] 共用的付款資訊表單
class PaymentInfoForm extends StatelessWidget {
  final PaymentInfoFormController controller;

  const PaymentInfoForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // 使用 ListenableBuilder 監聽 controller 變化
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Mode Selection
            _buildRadioOption(
              context,
              value: PaymentMode.private,
              groupValue: controller.mode,
              label: t.common.payment_info.mode_private, // "私訊聯絡"
              desc:
                  t.common.payment_info.mode_private_desc, // "不顯示收款資訊，請成員直接詢問"
              onChanged: (v) => controller.setMode(v!),
            ),
            _buildRadioOption(
              context,
              value: PaymentMode.specific,
              groupValue: controller.mode,
              label: t.common.payment_info.mode_public, // "提供收款資訊"
              desc: t.common.payment_info.mode_public_desc, // "顯示銀行帳號或支付連結"
              onChanged: (v) => controller.setMode(v!),
            ),

            if (controller.mode == PaymentMode.specific) ...[
              const Divider(height: 32),

              CheckboxListTile(
                value: controller.acceptCash,
                onChanged: controller.toggleAcceptCash,
                title: Text(t.common.payment_info.type_cash),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),

              CheckboxListTile(
                value: controller.enableBank,
                onChanged: controller.toggleEnableBank,
                title: Text(t.common.payment_info.type_bank),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              if (controller.enableBank) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 40, bottom: 16),
                  child: Column(
                    children: [
                      TextField(
                        controller: controller.bankNameCtrl,
                        decoration: InputDecoration(
                          labelText: t.common.payment_info
                              .bank_name_hint, // "銀行代碼 / 名稱"
                          isDense: true,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: controller.bankAccountCtrl,
                        decoration: InputDecoration(
                          labelText:
                              t.common.payment_info.bank_account_hint, // "帳號"
                          isDense: true,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // C. 其他支付 App
              CheckboxListTile(
                value: controller.enableApps,
                onChanged: controller.toggleEnableApps,
                title: Text(t.common.payment_info.type_apps),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              if (controller.enableApps) ...[
                ...controller.appControllers.asMap().entries.map((entry) {
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
                          crossAxisAlignment: CrossAxisAlignment.center, // 對齊中心
                          children: [
                            Expanded(
                              child: TextField(
                                controller: ctrl.nameCtrl,
                                decoration: InputDecoration(
                                  labelText: t
                                      .common.payment_info.app_name, // "App 名稱"
                                  hintText: "e.g. LinePay", // 可選：給個提示
                                  isDense: true,
                                  // M3: 在有背景色的容器內，可以使用 filled: true + fillColors.surface
                                  // 或者保持 outline，這裡維持 outline 比較清爽
                                  border: const OutlineInputBorder(),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 12),
                                ),
                              ),
                            ),
                            // 刪除按鈕 (緊跟在名稱旁邊)
                            IconButton(
                              icon: const Icon(Icons.close),
                              // 使用 onSurfaceVariant 顏色比較不那麼刺眼，除非要強調危險
                              color: colorScheme.onSurfaceVariant,
                              onPressed: () => controller.removeApp(index),
                              tooltip: t.common.buttons.delete,
                            ),
                          ],
                        ),

                        const SizedBox(height: 12), // 上下行的間距

                        // 第二行：連結/ID (獨佔一行，顯示完整內容)
                        TextField(
                          controller: ctrl.linkCtrl,
                          decoration: InputDecoration(
                            labelText:
                                t.common.payment_info.app_link, // "連結 / ID"
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
                    onPressed: controller.addApp,
                  ),
                ),
              ]
            ],
            // 底部留白，避免鍵盤遮擋
            const SizedBox(height: 80),
          ],
        );
      },
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
