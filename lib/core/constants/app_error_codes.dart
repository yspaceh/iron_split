class AppErrorCodes {
  // 1. 邏輯阻擋類 (Blocking Logic)
  static const String incomeIsUsed = "INCOME_IS_USED";

  // 2. 資料同步類 (Data Sync)
  static const String recordNotFound = "RECORD_NOT_FOUND";

  // [新增] 3. 載入失敗類 (Load Failed)
  static const String taskLoadFailed = "TASK_LOAD_FAILED";

  // 4. 系統/Firebase 類 (System/Firebase Mapping)
  static const String permissionDenied = "permission-denied";
  static const String networkError = "network-request-failed";
}
