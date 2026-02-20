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
  static const String defaultSymbol = '\$';
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
          '#,##0${decimalDigits > 0 ? '.${'0' * decimalDigits}' : ''}',
      decimalDigits: decimalDigits,
    ).format(amount);
  }

  // 在 currency_constants.dart 中

  static CurrencyConstants detectSystemCurrency() {
    String systemLocale =
        Platform.localeName; // e.g., 'zh_TW', 'en_US', 'ja_JP'

    // 1. 取得國家代碼 (Country Code)
    // 通常 locale 格式為 'lang_COUNTRY'，例如 'zh_TW' -> 'TW'
    String countryCode = '';
    if (systemLocale.contains('_')) {
      countryCode = systemLocale.split('_').last.toUpperCase();
    } else {
      // 如果只有語言代碼 (例如 'ja')，嘗試推斷預設國家
      // 這裡可以做一些簡單的 fallback，或者直接讓它失敗回傳預設值
      countryCode = systemLocale.toUpperCase();
    }

    if (kDebugMode) {
      print('System Locale: $systemLocale, Country Code: $countryCode');
    }

    // 2. 定義國家 -> 幣別對照表 (Country -> Currency)
    // 這是一個手動維護的 Map，涵蓋常見國家
    const Map<String, String> countryToCurrency = {
      // East Asia
      'TW': 'TWD', // 台灣 -> 新台幣
      'JP': 'JPY', // 日本 -> 日圓
      'KR': 'KRW', // 韓國 -> 韓元
      'CN': 'CNY', // 中國 -> 人民幣
      'HK': 'HKD', // 香港 -> 港幣
      'MO': 'MOP', // 澳門 -> 澳門幣

      // Southeast Asia
      'SG': 'SGD', // 新加坡 -> 新幣
      'TH': 'THB', // 泰國 -> 泰銖
      'VN': 'VND', // 越南 -> 越南盾
      'MY': 'MYR', // 馬來西亞 -> 馬幣
      'ID': 'IDR', // 印尼 -> 印尼盾
      'PH': 'PHP', // 菲律賓 -> 披索

      // South Asia
      'IN': 'INR', // 印度 -> 盧比

      // Europe
      'GB': 'GBP', // 英國 -> 英鎊
      'FR': 'EUR', // 法國 -> 歐元
      'DE': 'EUR', // 德國 -> 歐元
      'IT': 'EUR', // 義大利 -> 歐元
      'ES': 'EUR', // 西班牙 -> 歐元
      'CH': 'CHF', // 瑞士 -> 瑞士法郎
      'DK': 'DKK', // 丹麥 -> 丹麥克朗
      'NO': 'NOK', // 挪威 -> 挪威克朗
      'SE': 'SEK', // 瑞典 -> 瑞典克朗
      'RU': 'RUB', // 俄羅斯 -> 盧布
      'TR': 'TRY', // 土耳其 -> 里拉

      // North America
      'US': 'USD', // 美國 -> 美金
      'CA': 'CAD', // 加拿大 -> 加幣

      // Oceania
      'AU': 'AUD', // 澳洲 -> 澳幣
      'NZ': 'NZD', // 紐西蘭 -> 紐幣

      // Middle East
      'AE': 'AED', // 阿聯酋 -> 迪拉姆
      'SA': 'SAR', // 沙烏地阿拉伯 -> 里亞爾

      // Africa
      'ZA': 'ZAR', // 南非 -> 蘭特
    };

    // 3. 查找對應的幣別代碼
    String targetCurrencyCode = countryToCurrency[countryCode] ?? 'USD';

    // 4. 從支援列表中找出該幣別物件
    final currency = kSupportedCurrencies.firstWhere(
      (e) => e.code == targetCurrencyCode,
      // 如果找不到 (例如對照表漏了)，回退到預設值 (USD)
      orElse: () => kSupportedCurrencies.first,
    );

    if (kDebugMode) {
      print('Detected Currency: ${currency.code}');
    }

    return currency;
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
