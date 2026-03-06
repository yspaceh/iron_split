import 'package:flutter_test/flutter_test.dart';
import 'package:iron_split/core/constants/currency_constants.dart';

void main() {
  group('CurrencyConstants.formatAmount', () {
    test('USD should keep 2 decimals with thousands separators', () {
      final formatted = CurrencyConstants.formatAmount(1234.5, 'USD');
      expect(formatted, '1,234.50');
    });

    test('JPY should use 0 decimals and round safely', () {
      final formatted = CurrencyConstants.formatAmount(1234.56, 'JPY');
      expect(formatted, '1,235');
    });

    test('large USD amount should remain grouped and rounded', () {
      final formatted =
          CurrencyConstants.formatAmount(1234567890123.987, 'USD');
      expect(formatted, '1,234,567,890,123.99');
    });

    test('large JPY amount should remain grouped with no decimals', () {
      final formatted =
          CurrencyConstants.formatAmount(1234567890123.987, 'JPY');
      expect(formatted, '1,234,567,890,124');
    });

    test('all supported currencies should respect decimal digit contract', () {
      const amount = 1234567890.9876;

      for (final currency in kSupportedCurrencies) {
        final formatted = CurrencyConstants.formatAmount(amount, currency.code);

        expect(
          formatted.contains(','),
          isTrue,
          reason: 'Missing thousands separator for ${currency.code}: $formatted',
        );

        final dotIndex = formatted.indexOf('.');
        if (currency.decimalDigits == 0) {
          expect(
            dotIndex,
            -1,
            reason: 'Unexpected decimal part for ${currency.code}: $formatted',
          );
        } else {
          expect(
            dotIndex > 0,
            isTrue,
            reason: 'Missing decimal point for ${currency.code}: $formatted',
          );
          final decimalPart = formatted.substring(dotIndex + 1);
          expect(
            decimalPart.length,
            currency.decimalDigits,
            reason:
                'Unexpected decimal length for ${currency.code}: $formatted',
          );
        }
      }
    });
  });

  group('CurrencyConstants.getCurrencyConstants', () {
    test('USD/JPY decimal digit contract should stay stable', () {
      final usd = CurrencyConstants.getCurrencyConstants('USD');
      final jpy = CurrencyConstants.getCurrencyConstants('JPY');
      expect(usd.decimalDigits, 2);
      expect(jpy.decimalDigits, 0);
    });

    test('unknown currency code should fallback to default USD', () {
      final currency = CurrencyConstants.getCurrencyConstants('UNKNOWN');
      expect(currency.code, CurrencyConstants.defaultCode);
      expect(currency.decimalDigits, 2);
    });
  });
}
