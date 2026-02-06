import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/features/common/presentation/widgets/pickers/app_select_field.dart';
import 'package:iron_split/features/common/presentation/widgets/pickers/currency_picker_sheet.dart';
import 'package:iron_split/gen/strings.g.dart';

class TaskCurrencyInput extends StatelessWidget {
  const TaskCurrencyInput({
    super.key,
    required this.currency,
    required this.onCurrencyChanged,
    this.enabled = true,
  });

  final CurrencyConstants currency;
  final ValueChanged<CurrencyConstants> onCurrencyChanged;
  final bool enabled;

  void _showCurrencyPicker(BuildContext context) {
    if (!enabled) return; // 再次確保防呆

    CurrencyPickerSheet.show(
      context: context,
      initialCode: currency.code,
      onSelected: (currency) {
        onCurrencyChanged(currency);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    // [重構] 直接使用 AppSelectField
    return AppSelectField(
      // 標題：結算幣別
      labelText: t.S16_TaskCreate_Edit.field_currency,

      // 內容：顯示幣別代碼 (例如: TWD)
      // 小技巧：如果想顯示更豐富，可以改為 "${currency.code} (${currency.symbol})"
      text: currency.code,

      // 圖示：維持原本的交換圖示，AppSelectField 會自動幫你變成灰色
      prefixIcon: Icons.currency_exchange,

      // 點擊事件
      onTap: enabled ? () => _showCurrencyPicker(context) : () {},

      // 錯誤處理：目前幣別通常有預設值，不太會有 error，若有可傳 errorText
    );
  }
}
