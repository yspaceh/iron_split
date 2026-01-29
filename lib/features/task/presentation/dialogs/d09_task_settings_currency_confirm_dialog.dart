import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/services/currency_service.dart';
import 'package:iron_split/features/task/domain/models/activity_log_model.dart';
import 'package:iron_split/features/task/domain/service/activity_log_service.dart';
import 'package:iron_split/gen/strings.g.dart';

/// Page Key: D09_TaskSettings.CurrencyConfirm
/// 負責執行：防呆確認 -> 更新資料庫(含紀錄匯率重算) -> 寫入 Log -> 回傳 true
class D09TaskSettingsCurrencyConfirmDialog extends StatefulWidget {
  final String taskId;
  final CurrencyOption newCurrency;

  const D09TaskSettingsCurrencyConfirmDialog({
    super.key,
    required this.taskId,
    required this.newCurrency,
  });

  @override
  State<D09TaskSettingsCurrencyConfirmDialog> createState() =>
      _D09TaskSettingsCurrencyConfirmDialogState();
}

class _D09TaskSettingsCurrencyConfirmDialogState
    extends State<D09TaskSettingsCurrencyConfirmDialog> {
  bool _isProcessing = false;

  Future<void> _handleConfirm() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      final firestore = FirebaseFirestore.instance;
      final taskRef = firestore.collection('tasks').doc(widget.taskId);
      final newBaseCode = widget.newCurrency.code;

      // 1. 更新資料庫 (Tasks Collection)
      await taskRef.update({
        'baseCurrency': newBaseCode,
      });

      // 2. [關鍵修正] 批次更新所有紀錄的匯率 (Re-calculate Exchange Rates)
      final recordsSnapshot = await taskRef.collection('records').get();

      if (recordsSnapshot.docs.isNotEmpty) {
        // 優化：先找出所有出現過的幣別，一次查完匯率，避免迴圈內瘋狂打 API
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
            rateMap[currencyCode] = rate ?? 1.0; // 若 API 失敗則暫定 1.0
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

      // 2. 寫入 Activity Log
      // 這裡集中管理 Log，符合 DRY
      await ActivityLogService.log(
        taskId: widget.taskId,
        action: LogAction.updateSettings,
        details: {
          'settingType': 'currency',
          'newValue': widget.newCurrency.code,
        },
      );

      if (mounted) {
        context.pop(true); // 回傳 true 代表更新成功
      }
    } catch (e) {
      debugPrint('Failed to update currency: $e');
      if (mounted) {
        // 發生錯誤時，可以選擇 pop(false) 或顯示錯誤提示
        context.pop(false);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(t.D09_TaskSettings_CurrencyConfirm.title),
      content: Text(
          "${t.D09_TaskSettings_CurrencyConfirm.content}\n\n-> ${widget.newCurrency.code} (${widget.newCurrency.symbol})"),
      actions: [
        // 取消按鈕
        TextButton(
          onPressed: _isProcessing ? null : () => context.pop(false),
          child: Text(t.common.cancel),
        ),
        // 確認按鈕
        TextButton(
          onPressed: _isProcessing ? null : _handleConfirm,
          style: TextButton.styleFrom(
            foregroundColor: theme.colorScheme.error,
          ),
          child: _isProcessing
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(t.common.confirm),
        ),
      ],
    );
  }
}
