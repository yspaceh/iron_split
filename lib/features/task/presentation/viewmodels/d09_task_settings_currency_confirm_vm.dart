import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/services/currency_service.dart';
import 'package:iron_split/features/task/data/models/activity_log_model.dart';
import 'package:iron_split/features/task/data/services/activity_log_service.dart';

class D09TaskSettingsCurrencyConfirmViewModel extends ChangeNotifier {
  final String taskId;
  final CurrencyOption newCurrency;

  bool _isProcessing = false;

  bool get isProcessing => _isProcessing;

  D09TaskSettingsCurrencyConfirmViewModel({
    required this.taskId,
    required this.newCurrency,
  });

  /// 執行更新邏輯
  /// Returns: true if success, false if failed
  Future<bool> handleConfirm() async {
    _isProcessing = true;
    notifyListeners();

    try {
      final firestore = FirebaseFirestore.instance;
      final taskRef = firestore.collection('tasks').doc(taskId);
      final newBaseCode = newCurrency.code;

      // 1. 更新資料庫 (Tasks Collection)
      await taskRef.update({
        'baseCurrency': newBaseCode,
      });

      // 2. 批次更新所有紀錄的匯率 (Re-calculate Exchange Rates)
      final recordsSnapshot = await taskRef.collection('records').get();

      if (recordsSnapshot.docs.isNotEmpty) {
        // 優化：先找出所有出現過的幣別，一次查完匯率
        final uniqueRecordCurrencies = recordsSnapshot.docs
            .map((doc) => doc.data()['currency'] as String? ?? 'TWD')
            .toSet();

        final Map<String, double> rateMap = {};

        for (final currencyCode in uniqueRecordCurrencies) {
          if (currencyCode == newBaseCode) {
            rateMap[currencyCode] = 1.0;
          } else {
            // 呼叫 API 取得最新匯率 (Record Currency -> New Base Currency)
            final rate = await CurrencyService.fetchRate(
                from: currencyCode, to: newBaseCode);
            rateMap[currencyCode] = rate ?? 1.0;
          }
        }

        // 執行批次寫入
        final batch = firestore.batch();

        for (final doc in recordsSnapshot.docs) {
          final data = doc.data();
          final recordCurrency =
              data['currency'] as String? ?? CurrencyOption.defaultCode;
          final newRate = rateMap[recordCurrency] ?? 1.0;

          // 只有當匯率真的不同時才更新 (節省寫入)
          if ((data['exchangeRate'] as num? ?? 0) != newRate) {
            batch.update(doc.reference, {'exchangeRate': newRate});
          }
        }

        await batch.commit();
      }

      // 3. 寫入 Activity Log
      await ActivityLogService.log(
        taskId: taskId,
        action: LogAction.updateSettings,
        details: {
          'settingType': 'currency',
          'newValue': newCurrency.code,
        },
      );

      return true;
    } catch (e) {
      debugPrint('Failed to update currency: $e');
      return false;
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }
}
