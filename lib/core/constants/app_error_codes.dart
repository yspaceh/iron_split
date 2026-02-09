class AppErrorCodes {
  // 1. 邏輯阻擋類 (Blocking Logic)
  static const String incomeIsUsed = "INCOME_IS_USED";

  // 2. 資料同步類 (Data Sync)
  static const String recordNotFound = "RECORD_NOT_FOUND";
  static const String taskNotFound = "TASK_NOT_FOUND";

  //  3. 載入失敗類 (Load Failed)
  static const String taskLoadFailed = "TASK_LOAD_FAILED";

  // 4. 系統/Firebase 類 (System/Firebase Mapping)
  static const String permissionDenied = "permission-denied";
  static const String networkError = "network-request-failed";

  // 儲存與刪除類
  static const String saveFailed = "SAVE_FAILED";
  static const String deleteFailed = "DELETE_FAILED";

  // 匯率類
  static const String rateFetchFailed = "RATE_FETCH_FAILED";
}
