// Currency options
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:iron_split/gen/strings.g.dart';

class CurrencyConstants {
  final String code;
  final String symbol;
  final int decimalDigits;

  const CurrencyConstants({
    required this.code,
    required this.symbol,
    this.decimalDigits = 2, // Default to 2 decimal places
  });

  static const String defaultCode = 'USD';
  static const CurrencyConstants defaultCurrencyConstants =
      CurrencyConstants(code: 'USD', symbol: '\$', decimalDigits: 2);

  static CurrencyConstants getCurrencyConstants(String currencyCode) {
    final currency = kSupportedCurrencies.firstWhere(
      (e) => e.code == currencyCode,
      orElse: () => kSupportedCurrencies.first,
    );

    return currency;
  }

  static String formatAmount(double amount, String currencyCode) {
    final currency = getCurrencyConstants(currencyCode);

    final decimalDigits = currency.decimalDigits;

    return NumberFormat.currency(
      customPattern:
          '#,##0${decimalDigits > 0 ? '.' + '0' * decimalDigits : ''}',
      decimalDigits: decimalDigits,
    ).format(amount);
  }

  static CurrencyConstants detectSystemCurrency() {
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

const List<CurrencyConstants> kSupportedCurrencies = [
  CurrencyConstants(code: 'USD', symbol: '\$', decimalDigits: 2),
  CurrencyConstants(code: 'JPY', symbol: '¥', decimalDigits: 0),
  CurrencyConstants(code: 'TWD', symbol: '\$', decimalDigits: 0),
  CurrencyConstants(code: 'EUR', symbol: '€', decimalDigits: 2),
  CurrencyConstants(code: 'KRW', symbol: '₩', decimalDigits: 0),
  CurrencyConstants(code: 'CNY', symbol: '¥', decimalDigits: 2),
  CurrencyConstants(code: 'GBP', symbol: '£', decimalDigits: 2),
  CurrencyConstants(code: 'CAD', symbol: '\$', decimalDigits: 2),
  CurrencyConstants(code: 'AUD', symbol: '\$', decimalDigits: 2),
  CurrencyConstants(code: 'CHF', symbol: 'CHF', decimalDigits: 2),
  CurrencyConstants(code: 'DKK', symbol: 'kr.', decimalDigits: 2),
  CurrencyConstants(code: 'HKD', symbol: '\$', decimalDigits: 2),
  CurrencyConstants(code: 'NOK', symbol: 'kr', decimalDigits: 2),
  CurrencyConstants(code: 'NZD', symbol: '\$', decimalDigits: 2),
  CurrencyConstants(code: 'SGD', symbol: '\$', decimalDigits: 2),
  CurrencyConstants(code: 'THB', symbol: '฿', decimalDigits: 2),
  CurrencyConstants(code: 'ZAR', symbol: 'R', decimalDigits: 2),
  CurrencyConstants(code: 'RUB', symbol: '₽', decimalDigits: 2),
  CurrencyConstants(code: 'VND', symbol: '₫', decimalDigits: 0),
  CurrencyConstants(code: 'IDR', symbol: 'Rp', decimalDigits: 0),
  CurrencyConstants(code: 'MYR', symbol: 'RM', decimalDigits: 2),
  CurrencyConstants(code: 'PHP', symbol: '₱', decimalDigits: 2),
  CurrencyConstants(code: 'MOP', symbol: '\$', decimalDigits: 2),
  CurrencyConstants(code: 'SEK', symbol: 'kr', decimalDigits: 2),
  CurrencyConstants(code: 'AED', symbol: 'د.إ', decimalDigits: 2),
  CurrencyConstants(code: 'SAR', symbol: '﷼', decimalDigits: 2),
  CurrencyConstants(code: 'TRY', symbol: '₺', decimalDigits: 2),
  CurrencyConstants(code: 'INR', symbol: '₹', decimalDigits: 2),
];

/// 這是新增的擴充方法，用來取得多國語言名稱
extension CurrencyConstantsExt on CurrencyConstants {
  String getLocalizedName(BuildContext context) {
    final t = Translations.of(context);

    // 建立代碼與翻譯的對照表
    // 這裡的 key 對應 kSupportedCurrencies 裡的 code
    // 這裡的 value 對應 strings.i18n.json 裡的 t.common.currency.xxx
    Map<String, String> nameMap = {
      'TWD': t.common.currency.twd,
      'JPY': t.common.currency.jpy,
      'USD': t.common.currency.usd,
      'EUR': t.common.currency.eur,
      'KRW': t.common.currency.krw,
      'CNY': t.common.currency.cny,
      'GBP': t.common.currency.gbp,
      'CAD': t.common.currency.cad,
      'AUD': t.common.currency.aud,
      'CHF': t.common.currency.chf,
      'DKK': t.common.currency.dkk,
      'HKD': t.common.currency.hkd,
      'NOK': t.common.currency.nok,
      'NZD': t.common.currency.nzd,
      'SGD': t.common.currency.sgd,
      'THB': t.common.currency.thb,
      'ZAR': t.common.currency.zar,
      'RUB': t.common.currency.rub,
      'VND': t.common.currency.vnd,
      'IDR': t.common.currency.idr,
      'MYR': t.common.currency.myr,
      'PHP': t.common.currency.php,
      'MOP': t.common.currency.mop,
      'SEK': t.common.currency.sek,
      'AED': t.common.currency.aed,
      'SAR': t.common.currency.sar,
      'INR': t.common.currency.inr,
      'TRY': t.common.currency.try_,
    };

    return nameMap[code] ?? '';
  }
}
