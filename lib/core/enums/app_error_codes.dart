// app_error_codes.dart
enum AppErrorCodes {
  unauthorized, // 未登入 (unauthenticated)
  permissionDenied, // 權限不足 (permission-denied)
  initFailed, // 載入或初始化失敗 (所有 Page/VM/B03 的進入失敗)
  dataNotFound, // 找不到資料 (not-found)
  saveFailed, // 儲存/新增/更新失敗
  deleteFailed, // 刪除失敗
  rateFetchFailed, // 匯率取得失敗
  taskCloseFailed,

  quotaExceeded, // Firebase 額度用完 (resource-exhausted)
  unavailable, // 伺服器不可用 (unavailable)
  timeout, // 請求逾時 (deadline-exceeded)
  networkError, // 網路連線失敗 (network-request-failed)

  incomeIsUsed, // 業務邏輯：款項已使用
  dataIsUsed,
  taskLocked, // 業務邏輯：房間已鎖定

  // 邀請流程 (因 UI 顯示內容高度特殊，保留專用碼)
  inviteTaskFull,
  inviteExpired,
  inviteInvalid,
  inviteAlreadyJoined,
  joinFailed,
  inviteCreateFailed,

  nameLengthExceeded, // 長度超過限制
  invalidChar, // 包含無效字元
  fieldRequired, // 必填欄位為空

  dataConflict, // 資料版本衝突 (原本的 SettlementDataConflictException)
  taskStatusError, // 房間狀態異常 (原本的 SettlementStatusInvalidException)
  settlementFailed,

  exportFailed,
  shareFailed,
  logoutFailed,

  unknown,
}
