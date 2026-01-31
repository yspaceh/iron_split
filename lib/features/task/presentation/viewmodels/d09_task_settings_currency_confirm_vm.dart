import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/services/currency_service.dart';
import 'package:iron_split/features/record/data/record_repository.dart';
import 'package:iron_split/features/task/data/models/activity_log_model.dart';
import 'package:iron_split/features/task/data/services/activity_log_service.dart';
import 'package:iron_split/features/task/data/task_repository.dart';

class D09TaskSettingsCurrencyConfirmViewModel extends ChangeNotifier {
  final String taskId;
  final CurrencyConstants newCurrency;
  final TaskRepository _taskRepo;
  final RecordRepository _recordRepo;

  bool _isProcessing = false;

  bool get isProcessing => _isProcessing;

  D09TaskSettingsCurrencyConfirmViewModel({
    required this.taskId,
    required TaskRepository taskRepo,
    required RecordRepository recordRepo,
    required this.newCurrency,
  })  : _taskRepo = taskRepo,
        _recordRepo = recordRepo;

  /// 執行更新邏輯
  /// Returns: true if success, false if failed
  Future<bool> handleConfirm() async {
    _isProcessing = true;
    notifyListeners();

    try {
      final newBaseCode = newCurrency.code;

      // 1. 更新資料庫 (Tasks Collection)
      await _taskRepo.updateTask(taskId, {
        'baseCurrency': newBaseCode,
      });

      // 2. 準備匯率表 (Application Logic - 這是 VM 的職責)
      final records = await _recordRepo.streamRecords(taskId).first;

      if (records.isNotEmpty) {
        final uniqueRecordCurrencies = records
            .map((r) => r.currencyCode) // 注意: RecordModel 欄位名稱要對
            .toSet();

        final Map<String, double> rateMap = {};

        // 呼叫 API 準備匯率表
        for (final currencyCode in uniqueRecordCurrencies) {
          if (currencyCode == newBaseCode) {
            rateMap[currencyCode] = 1.0;
          } else {
            final rate = await CurrencyService.fetchRate(
                from: currencyCode, to: newBaseCode);
            rateMap[currencyCode] = rate ?? 1.0;
          }
        }

        // 執行批次寫入
        await _recordRepo.updateExchangeRates(taskId, rateMap);
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
