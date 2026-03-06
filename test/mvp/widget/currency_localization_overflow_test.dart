import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/models/settlement_model.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/features/settlement/presentation/widgets/settlement_member_item.dart';
import 'package:iron_split/gen/strings_en_US.g.dart';
import 'package:iron_split/gen/strings_ja_JP.g.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:provider/provider.dart';

void main() {
  group('Currency localization', () {
    test('JPY key should be correct in en-US locale bundle', () {
      final en = TranslationsEnUs();
      expect(en.common.currency.jpy, 'Japanese Yen');
    });

    test('JPY key should be correct in ja-JP locale bundle', () {
      final ja = TranslationsJaJp();
      expect(ja.common.currency.jpy, '日本円');
    });

    test('JPY key should be correct in zh-TW locale bundle', () {
      final zh = TranslationsZhTw();
      expect(zh.common.currency.jpy, '日圓');
    });

    test('all supported currency labels should be non-empty in en-US', () {
      final en = TranslationsEnUs();
      for (final currency in kSupportedCurrencies) {
        final name = _localizedNameFor(en, currency.code);
        expect(name.trim().isNotEmpty, isTrue, reason: 'Missing en-US name for ${currency.code}');
      }
    });

    test('all supported currency labels should be non-empty in zh-TW', () {
      final zh = TranslationsZhTw();
      for (final currency in kSupportedCurrencies) {
        final name = _localizedNameFor(zh, currency.code);
        expect(name.trim().isNotEmpty, isTrue, reason: 'Missing zh-TW name for ${currency.code}');
      }
    });

    test('all supported currency labels should be non-empty in ja-JP', () {
      final ja = TranslationsJaJp();
      for (final currency in kSupportedCurrencies) {
        final name = _localizedNameFor(ja, currency.code);
        expect(name.trim().isNotEmpty, isTrue, reason: 'Missing ja-JP name for ${currency.code}');
      }
    });
  });

  group('Currency overflow guard', () {
    Future<void> pumpSettlementMemberItem(
      WidgetTester tester, {
      required String currencyCode,
      required double amount,
      double width = 190,
    }) async {
      final now = DateTime(2026, 1, 1);
      final member = SettlementMember(
        memberData: TaskMember(
          id: 'u1',
          displayName: 'Captain',
          isLinked: true,
          role: 'captain',
          joinedAt: now,
          createdAt: now,
        ),
        finalAmount: amount,
        baseAmount: 0,
        remainderAmount: 0,
        isRemainderAbsorber: false,
      );

      await tester.pumpWidget(
        TranslationProvider(
          child: MultiProvider(
            providers: [
              Provider<DisplayState>.value(
                value: DisplayState(isEnlarged: false, scale: 1.0),
              ),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: Center(
                  child: SizedBox(
                    width: width,
                    child: SettlementMemberItem(
                      member: member,
                      baseCurrency:
                          CurrencyConstants.getCurrencyConstants(currencyCode),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
    }

    testWidgets('large amount on narrow width should not throw overflow', (tester) async {
      await pumpSettlementMemberItem(
        tester,
        currencyCode: 'USD',
        amount: 1234567890123.99,
      );

      expect(tester.takeException(), isNull);
      expect(find.textContaining('1,234,567,890,123.99'), findsOneWidget);
    });

    testWidgets('JPY on narrow width should render 0 decimal format', (tester) async {
      await pumpSettlementMemberItem(
        tester,
        currencyCode: 'JPY',
        amount: 1234567890123.99,
      );

      expect(tester.takeException(), isNull);
      expect(find.textContaining('1,234,567,890,124'), findsOneWidget);
    });

    testWidgets('all supported currencies should render on narrow width without overflow',
        (tester) async {
      for (final currency in kSupportedCurrencies) {
        await pumpSettlementMemberItem(
          tester,
          currencyCode: currency.code,
          amount: 9876543210.987,
          width: 190,
        );

        expect(
          tester.takeException(),
          isNull,
          reason: 'Overflow/render exception for ${currency.code}',
        );
      }
    });
  });
}

String _localizedNameFor(Translations t, String code) {
  switch (code) {
    case 'TWD':
      return t.common.currency.twd;
    case 'JPY':
      return t.common.currency.jpy;
    case 'USD':
      return t.common.currency.usd;
    case 'EUR':
      return t.common.currency.eur;
    case 'KRW':
      return t.common.currency.krw;
    case 'CNY':
      return t.common.currency.cny;
    case 'GBP':
      return t.common.currency.gbp;
    case 'CAD':
      return t.common.currency.cad;
    case 'AUD':
      return t.common.currency.aud;
    case 'CHF':
      return t.common.currency.chf;
    case 'DKK':
      return t.common.currency.dkk;
    case 'HKD':
      return t.common.currency.hkd;
    case 'NOK':
      return t.common.currency.nok;
    case 'NZD':
      return t.common.currency.nzd;
    case 'SGD':
      return t.common.currency.sgd;
    case 'THB':
      return t.common.currency.thb;
    case 'ZAR':
      return t.common.currency.zar;
    case 'RUB':
      return t.common.currency.rub;
    case 'VND':
      return t.common.currency.vnd;
    case 'IDR':
      return t.common.currency.idr;
    case 'MYR':
      return t.common.currency.myr;
    case 'PHP':
      return t.common.currency.php;
    case 'MOP':
      return t.common.currency.mop;
    case 'SEK':
      return t.common.currency.sek;
    case 'AED':
      return t.common.currency.aed;
    case 'SAR':
      return t.common.currency.sar;
    case 'TRY':
      return t.common.currency.try_;
    case 'INR':
      return t.common.currency.inr;
    default:
      return '';
  }
}
