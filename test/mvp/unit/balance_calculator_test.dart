import 'package:flutter_test/flutter_test.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/split_method_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/models/record_model.dart';
import 'package:iron_split/core/utils/balance_calculator.dart';

void main() {
  group('BalanceCalculator.calculateSplit', () {
    test('even: allocated base + remainder == total base (handles non-terminating split)', () {
      final result = BalanceCalculator.calculateSplit(
        totalAmount: 100.0,
        exchangeRate: 1.0,
        splitMethod: SplitMethodConstant.even,
        memberIds: const ['u1', 'u2', 'u3'],
        details: const {},
        baseCurrency: CurrencyConstants.getCurrencyConstants('USD'),
      );

      final allocatedBase =
          result.memberAmounts.values.fold(0.0, (sum, m) => sum + m.base);
      final conserved = allocatedBase + result.remainder;

      expect(result.totalAmount.base, closeTo(100.0, 1e-9));
      expect(conserved, closeTo(result.totalAmount.base, 1e-9));
      expect(result.remainder, closeTo(0.01, 1e-9));
    });

    test('percent: weighted split keeps conservation with rounding remainder', () {
      final result = BalanceCalculator.calculateSplit(
        totalAmount: 100.0,
        exchangeRate: 1.0,
        splitMethod: SplitMethodConstant.percent,
        memberIds: const ['u1', 'u2', 'u3'],
        details: const {'u1': 1, 'u2': 2, 'u3': 3},
        baseCurrency: CurrencyConstants.getCurrencyConstants('USD'),
      );

      final allocatedBase =
          result.memberAmounts.values.fold(0.0, (sum, m) => sum + m.base);
      final conserved = allocatedBase + result.remainder;

      expect(result.totalAmount.base, closeTo(100.0, 1e-9));
      expect(conserved, closeTo(result.totalAmount.base, 1e-9));
      expect(result.remainder, closeTo(0.01, 1e-9));
    });

    test('exact: exact detail amounts still keep conservation', () {
      final result = BalanceCalculator.calculateSplit(
        totalAmount: 123.45,
        exchangeRate: 1.0,
        splitMethod: SplitMethodConstant.exact,
        memberIds: const ['u1', 'u2', 'u3'],
        details: const {'u1': 10.11, 'u2': 20.22, 'u3': 93.12},
        baseCurrency: CurrencyConstants.getCurrencyConstants('USD'),
      );

      final allocatedBase =
          result.memberAmounts.values.fold(0.0, (sum, m) => sum + m.base);
      final conserved = allocatedBase + result.remainder;

      final allocatedOriginal =
          result.memberAmounts.values.fold(0.0, (sum, m) => sum + m.original);

      expect(allocatedOriginal, closeTo(result.totalAmount.original, 1e-9));
      expect(conserved, closeTo(result.totalAmount.base, 1e-9));
      expect(result.remainder, closeTo(0.0, 1e-9));
    });

    test('zero-decimal currency edge (JPY): remainder step is integer-safe', () {
      final result = BalanceCalculator.calculateSplit(
        totalAmount: 100.0,
        exchangeRate: 1.0,
        splitMethod: SplitMethodConstant.even,
        memberIds: const ['u1', 'u2', 'u3'],
        details: const {},
        baseCurrency: CurrencyConstants.getCurrencyConstants('JPY'),
      );

      final allocatedBase =
          result.memberAmounts.values.fold(0.0, (sum, m) => sum + m.base);
      final conserved = allocatedBase + result.remainder;

      expect(result.totalAmount.base, closeTo(100.0, 1e-9));
      expect(conserved, closeTo(result.totalAmount.base, 1e-9));
      expect(result.remainder, closeTo(1.0, 1e-9));
    });

    test('percent with zero total weight: no allocation, full amount becomes remainder', () {
      final result = BalanceCalculator.calculateSplit(
        totalAmount: 88.88,
        exchangeRate: 1.0,
        splitMethod: SplitMethodConstant.percent,
        memberIds: const ['u1', 'u2'],
        details: const {'u1': 0, 'u2': 0},
        baseCurrency: CurrencyConstants.getCurrencyConstants('USD'),
      );

      final allocatedBase =
          result.memberAmounts.values.fold(0.0, (sum, m) => sum + m.base);
      final conserved = allocatedBase + result.remainder;

      expect(allocatedBase, closeTo(0.0, 1e-9));
      expect(conserved, closeTo(result.totalAmount.base, 1e-9));
      expect(result.remainder, closeTo(result.totalAmount.base, 1e-9));
    });
  });

  group('BalanceCalculator.isPoolBalanceSufficient', () {
    test('edit mode (prepay): adds back original full prepay amount in same currency', () {
      final originalRecord = _record(
        payerType: PayerType.prepay,
        currencyCode: 'USD',
        amount: 10.0,
      );

      final ok = BalanceCalculator.isPoolBalanceSufficient(
        amountToCheck: 25.0,
        currency: 'USD',
        currentPoolBalances: const {'USD': 20.0},
        originalRecord: originalRecord,
      );

      expect(ok, isTrue); // 20 + 10 >= 25
    });

    test('edit mode (mixed): adds back only prepayAmount (not member advance)', () {
      final originalRecord = _record(
        payerType: PayerType.mixed,
        currencyCode: 'USD',
        amount: 100.0,
        paymentDetails: const {
          'prepayAmount': 6.0,
          'memberAdvance': {'u1': 94.0}
        },
      );

      final ok = BalanceCalculator.isPoolBalanceSufficient(
        amountToCheck: 15.0,
        currency: 'USD',
        currentPoolBalances: const {'USD': 9.0},
        originalRecord: originalRecord,
      );

      expect(ok, isTrue); // 9 + 6 >= 15
    });

    test('edit mode with different currency: should NOT add back old record amount', () {
      final originalRecord = _record(
        payerType: PayerType.prepay,
        currencyCode: 'JPY',
        amount: 1000.0,
      );

      final ok = BalanceCalculator.isPoolBalanceSufficient(
        amountToCheck: 25.0,
        currency: 'USD',
        currentPoolBalances: const {'USD': 20.0},
        originalRecord: originalRecord,
      );

      expect(ok, isFalse); // no add-back, remains 20 < 24.99
    });

    test('tolerance edge: amount-0.01 rule should pass exact threshold', () {
      final ok = BalanceCalculator.isPoolBalanceSufficient(
        amountToCheck: 100.0,
        currency: 'USD',
        currentPoolBalances: const {'USD': 99.99},
      );

      expect(ok, isTrue);
    });
  });
}

RecordModel _record({
  required PayerType payerType,
  required String currencyCode,
  required double amount,
  Map<String, dynamic>? paymentDetails,
}) {
  return RecordModel(
    date: DateTime(2026, 1, 1),
    title: 'test',
    type: RecordType.expense,
    payerType: payerType,
    amount: amount,
    currencyCode: currencyCode,
    paymentDetails: paymentDetails,
    splitMethod: SplitMethodConstant.even,
    splitMemberIds: const ['u1'],
  );
}
