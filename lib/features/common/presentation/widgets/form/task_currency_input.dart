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
    this.fillColor,
  });

  final CurrencyConstants currency;
  final ValueChanged<CurrencyConstants> onCurrencyChanged;
  final bool enabled;
  final Color? fillColor;

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
        labelText: t.common.label.currency,
        text: currency.code,
        onTap: enabled ? () => _showCurrencyPicker(context) : null,
        fillColor: fillColor);
  }
}
