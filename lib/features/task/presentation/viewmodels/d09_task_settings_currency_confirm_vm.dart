import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/services/currency_service.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/record/application/record_service.dart';
import 'package:iron_split/features/record/data/record_repository.dart';
import 'package:iron_split/features/task/data/models/activity_log_model.dart';
import 'package:iron_split/features/task/data/services/activity_log_service.dart';
import 'package:iron_split/features/task/data/task_repository.dart';

class D09TaskSettingsCurrencyConfirmViewModel extends ChangeNotifier {
  final String taskId;
  final CurrencyConstants newCurrency;
  final TaskRepository _taskRepo;
  final RecordRepository _recordRepo;
  final RecordService _recordService;

  LoadStatus _confirmStatus = LoadStatus.initial;

  LoadStatus get confirmStatus => _confirmStatus;

  D09TaskSettingsCurrencyConfirmViewModel({
    required this.taskId,
    required TaskRepository taskRepo,
    required RecordRepository recordRepo,
    required RecordService recordService,
    required this.newCurrency,
  })  : _taskRepo = taskRepo,
        _recordRepo = recordRepo,
        _recordService = recordService;

  /// 執行更新邏輯
  /// Returns: true if success, false if failed
  Future<void> confirm() async {
    if (_confirmStatus == LoadStatus.loading) return;
    _confirmStatus = LoadStatus.loading;
    notifyListeners();

    try {
      final newBaseCode = newCurrency.code;

      // 1. 更新資料庫 (Tasks Collection)
      await _taskRepo.updateTask(taskId, {
        'baseCurrency': newBaseCode,
      });

      // 2. 準備匯率表 (Application Logic - 這是 VM 的職責)
      final records = await _recordRepo.getRecordsOnce(taskId);

      if (records.isNotEmpty) {
        final uniqueRecordCurrencies = records
            .map((r) => r.currencyCode) // 注意: RecordModel 欄位名稱要對
            .toSet();

        final Map<String, double> rateMap = {};
        final List<Future<void>> rateFutures = []; // 準備一個清單裝任務

        for (final currencyCode in uniqueRecordCurrencies) {
          if (currencyCode == newBaseCode) {
            rateMap[currencyCode] = 1.0;
          } else {
            // 把任務丟進清單，讓它們同時跑
            rateFutures.add(() async {
              final rate = await CurrencyService.fetchRate(
                  from: currencyCode, to: newBaseCode);
              rateMap[currencyCode] = rate;
            }());
          }
        }
        await Future.wait(rateFutures);

        // Service 會負責：更新匯率 + 重新計算 Remainder + 批次存檔
        await _recordService.updateTaskExchangeRates(
            taskId: taskId, newRates: rateMap, newCurrency: newCurrency);
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

      _confirmStatus = LoadStatus.success;
      notifyListeners();
    } on AppErrorCodes {
      _confirmStatus = LoadStatus.error;
      notifyListeners();
      rethrow;
    } catch (e) {
      _confirmStatus = LoadStatus.error;
      notifyListeners();
      throw ErrorMapper.parseErrorCode(e);
    }
  }
}
