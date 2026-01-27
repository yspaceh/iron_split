// Currency options
import 'package:intl/intl.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

class CurrencyOption {
  final String code;
  final String symbol;
  final int decimalDigits;
  final String name;

  const CurrencyOption({
    required this.code,
    required this.symbol,
    required this.name,
    this.decimalDigits = 2, // Default to 2 decimal places
  });

  static const String defaultCode = 'USD';
  static const CurrencyOption defaultCurrencyOption = CurrencyOption(
      code: 'USD', symbol: '\$', decimalDigits: 2, name: 'US Dollar');

  static String formatAmount(double amount, String currencyCode) {
    final currency = kSupportedCurrencies.firstWhere(
      (e) => e.code == currencyCode,
      orElse: () => kSupportedCurrencies.first,
    );

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
  CurrencyOption(
      code: 'USD', symbol: '\$', decimalDigits: 2, name: 'US Dollar'),
  CurrencyOption(
      code: 'JPY', symbol: '¥', decimalDigits: 0, name: 'Japanese Yen'),
  CurrencyOption(
      code: 'TWD', symbol: '\$', decimalDigits: 0, name: 'Taiwan Dollar'),
  CurrencyOption(code: 'EUR', symbol: '€', decimalDigits: 2, name: 'Euro'),
  CurrencyOption(
      code: 'KRW', symbol: '₩', decimalDigits: 0, name: 'South Korean Won'),
  CurrencyOption(
      code: 'CNY', symbol: '¥', decimalDigits: 2, name: 'Chinese Yuan'),
  CurrencyOption(
      code: 'GBP', symbol: '£', decimalDigits: 2, name: 'British Pound'),
  CurrencyOption(
      code: 'CAD', symbol: '\$', decimalDigits: 2, name: 'Canadian Dollar'),
];
