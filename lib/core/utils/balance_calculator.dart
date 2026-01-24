import 'package:iron_split/core/models/record_model.dart';

class BalanceCalculator {
  static double calculatePrepayBalance(List<RecordModel> records) {
    double balance = 0.0;

    for (var record in records) {
      if (record.type == 'income') {
        balance += record.amount;
      } else if (record.type == 'expense') {
        if (record.payerType == 'prepay') {
          balance -= record.amount;
        } else if (record.payerType == 'mixed') {
          final prepayAmount =
              (record.paymentDetails?['prepayAmount'] as num?)?.toDouble() ??
                  0.0;
          balance -= prepayAmount;
        }
      }
    }

    return balance;
  }
}
