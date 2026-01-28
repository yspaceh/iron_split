// Currency options
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:iron_split/gen/strings.g.dart';

class CurrencyOption {
  final String code;
  final String symbol;
  final int decimalDigits;

  const CurrencyOption({
    required this.code,
    required this.symbol,
    this.decimalDigits = 2, // Default to 2 decimal places
  });

  static const String defaultCode = 'USD';
  static const CurrencyOption defaultCurrencyOption =
      CurrencyOption(code: 'USD', symbol: '\$', decimalDigits: 2);

  static CurrencyOption getCurrencyOption(String currencyCode) {
    final currency = kSupportedCurrencies.firstWhere(
      (e) => e.code == currencyCode,
      orElse: () => kSupportedCurrencies.first,
    );

    return currency;
  }

  static String formatAmount(double amount, String currencyCode) {
    final currency = getCurrencyOption(currencyCode);

    final decimalDigits = currency.decimalDigits;

    return NumberFormat.currency(
      customPattern:
          '#,##0${decimalDigits > 0 ? '.' + '0' * decimalDigits : ''}',
      decimalDigits: decimalDigits,
    ).format(amount);
  }

  static CurrencyOption detectSystemCurrency() {
    String systemLocale = Platform.localeName;
    if (kDebugMode) {
      print('System Locale: $systemLocale');
    }
    // Extract the currency code from the locale
    String currencyCode = systemLocale.split('_').last;
    if (kDebugMode) {
      print('Detected Currency Code: $currencyCode');
    }
    final baseOption = kSupportedCurrencies.firstWhere(
        (e) => e.code == currencyCode,
        orElse: () => kSupportedCurrencies.first);
    return baseOption;
  }
}

const List<CurrencyOption> kSupportedCurrencies = [
  CurrencyOption(code: 'USD', symbol: '\$', decimalDigits: 2),
  CurrencyOption(code: 'JPY', symbol: '¥', decimalDigits: 0),
  CurrencyOption(code: 'TWD', symbol: '\$', decimalDigits: 0),
  CurrencyOption(code: 'EUR', symbol: '€', decimalDigits: 2),
  CurrencyOption(code: 'KRW', symbol: '₩', decimalDigits: 0),
  CurrencyOption(code: 'CNY', symbol: '¥', decimalDigits: 2),
  CurrencyOption(code: 'GBP', symbol: '£', decimalDigits: 2),
  CurrencyOption(code: 'CAD', symbol: '\$', decimalDigits: 2),
  CurrencyOption(code: 'AUD', symbol: '\$', decimalDigits: 2),
  CurrencyOption(code: 'CHF', symbol: 'CHF', decimalDigits: 2),
  CurrencyOption(code: 'DKK', symbol: 'kr.', decimalDigits: 2),
  CurrencyOption(code: 'HKD', symbol: '\$', decimalDigits: 2),
  CurrencyOption(code: 'NOK', symbol: 'kr', decimalDigits: 2),
  CurrencyOption(code: 'NZD', symbol: '\$', decimalDigits: 2),
  CurrencyOption(code: 'SGD', symbol: '\$', decimalDigits: 2),
  CurrencyOption(code: 'THB', symbol: '฿', decimalDigits: 2),
  CurrencyOption(code: 'ZAR', symbol: 'R', decimalDigits: 2),
  CurrencyOption(code: 'RUB', symbol: '₽', decimalDigits: 2),
  CurrencyOption(code: 'VND', symbol: '₫', decimalDigits: 0),
  CurrencyOption(code: 'IDR', symbol: 'Rp', decimalDigits: 0),
  CurrencyOption(code: 'MYR', symbol: 'RM', decimalDigits: 2),
  CurrencyOption(code: 'PHP', symbol: '₱', decimalDigits: 2),
  CurrencyOption(code: 'MOP', symbol: '\$', decimalDigits: 2),
  CurrencyOption(code: 'SEK', symbol: 'kr', decimalDigits: 2),
  CurrencyOption(code: 'AED', symbol: 'د.إ', decimalDigits: 2),
  CurrencyOption(code: 'SAR', symbol: '﷼', decimalDigits: 2),
  CurrencyOption(code: 'TRY', symbol: '₺', decimalDigits: 2),
  CurrencyOption(code: 'INR', symbol: '₹', decimalDigits: 2),
];

/// 這是新增的擴充方法，用來取得多國語言名稱
extension CurrencyOptionExt on CurrencyOption {
  String getLocalizedName(BuildContext context) {
    final t = Translations.of(context);

    // 建立代碼與翻譯的對照表
    // 這裡的 key 對應 kSupportedCurrencies 裡的 code
    // 這裡的 value 對應 strings.i18n.json 裡的 t.currency.xxx
    Map<String, String> nameMap = {
      'TWD': t.currency.twd,
      'JPY': t.currency.jpy,
      'USD': t.currency.usd,
      'EUR': t.currency.eur,
      'KRW': t.currency.krw,
      'CNY': t.currency.cny,
      'GBP': t.currency.gbp,
      'CAD': t.currency.cad,
      'AUD': t.currency.aud,
      'CHF': t.currency.chf,
      'DKK': t.currency.dkk,
      'HKD': t.currency.hkd,
      'NOK': t.currency.nok,
      'NZD': t.currency.nzd,
      'SGD': t.currency.sgd,
      'THB': t.currency.thb,
      'ZAR': t.currency.zar,
      'RUB': t.currency.rub,
      'VND': t.currency.vnd,
      'IDR': t.currency.idr,
      'MYR': t.currency.myr,
      'PHP': t.currency.php,
      'MOP': t.currency.mop,
      'SEK': t.currency.sek,
      'AED': t.currency.aed,
      'SAR': t.currency.sar,
      'INR': t.currency.inr,
      'TRY': t.currency.try_,
    };

    return nameMap[code] ?? '';
  }
}
