import 'package:iron_split/core/models/record_model.dart';

class DailyStatisticsHelper {
  /// Calculates the total expense for a list of daily records.
  /// Only considers records with type 'expense'.
  /// Converts amount using exchangeRate.
  static double calculateDailyExpense(List<RecordModel> dailyRecords) {
    double total = 0.0;
    for (var record in dailyRecords) {
      if (record.type == 'expense') {
        total += record.amount * record.exchangeRate;
      }
    }
    return total;
  }
}
