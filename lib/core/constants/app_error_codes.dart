/// App 內部錯誤代碼常數表
/// 統一格式：UPPER_SNAKE_CASE
class AppErrorCodes {
  // 1. 邏輯阻擋類 (Blocking Logic)
  static const String incomeIsUsed = "INCOME_IS_USED";

  // 2. 資料同步類 (Data Sync)
  static const String recordNotFound = "RECORD_NOT_FOUND";

  // 3. 系統/Firebase 類 (System/Firebase Mapping)
  // 這些通常是 Firebase 原生拋出的，我們定義常數是為了 Mapper 比對方便，
  // 或者在我們自己 wrap 錯誤時使用
  static const String permissionDenied = "permission-denied"; // Firebase 原生格式保留
  static const String networkError =
      "network-request-failed"; // Firebase 原生格式保留
}
