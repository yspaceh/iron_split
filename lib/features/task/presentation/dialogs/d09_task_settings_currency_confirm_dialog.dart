import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/features/task/domain/models/activity_log_model.dart';
import 'package:iron_split/features/task/domain/service/activity_log_service.dart';
import 'package:iron_split/gen/strings.g.dart';

/// Page Key: D09_TaskSettings.CurrencyConfirm
/// 負責執行：防呆確認 -> 更新資料庫 -> 寫入 Log -> 回傳 true
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
      // 1. 更新資料庫 (Tasks Collection)
      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(widget.taskId)
          .update({
        'currency': widget.newCurrency.code, // 或 'baseCurrency'，請確認您的資料庫欄位
      });

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
