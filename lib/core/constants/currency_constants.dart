import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iron_split/gen/strings.g.dart';

class CurrencyOption {
  final String code; // ISO Code (USD)
  final String symbol; // 符號 ($)
  final String name; // 中文名稱 (美金)
  final bool decimal; // 是否顯示小數點

  const CurrencyOption(this.code, this.symbol, this.name,
      {this.decimal = true});

  /// 根據 decimal 屬性格式化金額
  String format(double amount) {
    if (decimal) {
      return NumberFormat("#,##0.00").format(amount);
    } else {
      // Round to nearest integer for zero-decimal currencies
      return NumberFormat("#,##0").format(amount.round());
    }
  }

  static const String defaultCode = 'USD';

  static String detectSystemCurrency(BuildContext context) {
    // 取得完整的 Locale (包含語言與地區，如 zh_TW, zh_CN)
    final Locale currentAppLocale =
        TranslationProvider.of(context).flutterLocale;

    // 根據完整 Locale 取得幣別名稱
    final String detected = NumberFormat.simpleCurrency(
          locale: currentAppLocale.toString(),
        ).currencyName ??
        '';

    // 檢查偵測到的幣別是否在我們的支援清單內
    final bool isSupported =
        kSupportedCurrencies.any((e) => e.code == detected);

    // 如果支援則回傳偵測值，不支援或抓不到則回傳美金
    return isSupported ? detected : defaultCode;
  }

  /// 靜態 helper：根據 currency code 查找設定並格式化
  static String formatAmount(double amount, String code) {
    // Find the option by code, default to USD if not found
    final option = kSupportedCurrencies.firstWhere(
      (e) => e.code == code,
      orElse: () =>
          kSupportedCurrencies.firstWhere((e) => e.code == defaultCode),
    );

    return option.format(amount);
  }
}

// 常用旅遊貨幣白名單
const List<CurrencyOption> kSupportedCurrencies = [
  CurrencyOption('TWD', '\$', '新台幣', decimal: false),
  CurrencyOption('JPY', '¥', '日圓', decimal: false),
  CurrencyOption('USD', '\$', '美金'),
  CurrencyOption('KRW', '₩', '韓元', decimal: false),
  CurrencyOption('CNY', '¥', '人民幣'),
  CurrencyOption('HKD', '\$', '港幣'),
  CurrencyOption('EUR', '€', '歐元'),
  CurrencyOption('GBP', '£', '英鎊'),
  CurrencyOption('THB', '฿', '泰銖'),
  CurrencyOption('SGD', '\$', '新加坡幣'),
  CurrencyOption('VND', '₫', '越南盾', decimal: false),
  CurrencyOption('MYR', 'RM', '馬來西亞林吉特'),
  CurrencyOption('AUD', '\$', '澳幣'),
  CurrencyOption('CAD', '\$', '加幣'),
  CurrencyOption('PHP', '₱', '菲律賓披索'),
  CurrencyOption('IDR', 'Rp', '印尼盾', decimal: false),
];
