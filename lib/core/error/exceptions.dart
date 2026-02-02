// [Base Exception] 所有結算相關的異常基類
abstract class SettlementException implements Exception {}

/// [1. 資料不一致]
/// 場景：Checkpoint 檢查失敗 (S30 看到的金額 != S31 執行時的金額)
/// 處理：請使用者返回刷新
class SettlementDataConflictException extends SettlementException {}

/// [2. 狀態無效]
/// 場景：Task 狀態已經不是 'ongoing' (可能別人已經結算完了)
/// 處理：阻擋操作，強制刷新或跳轉
class SettlementStatusInvalidException extends SettlementException {
  final String currentStatus;
  SettlementStatusInvalidException(this.currentStatus);
}

/// [3. 權限不足]
/// 場景：非隊長嘗試執行結算 (雖然 UI 會擋，但後端邏輯須再次防護)
/// 處理：顯示錯誤提示
class SettlementPermissionDeniedException extends SettlementException {}

/// [4. 鎖定失敗/並發錯誤]
/// 場景：Firestore Transaction 失敗
class SettlementTransactionFailedException extends SettlementException {
  final String originalError;
  SettlementTransactionFailedException(this.originalError);
}
