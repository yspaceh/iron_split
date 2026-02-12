// app_error_codes.dart
enum AppErrorCodes {
  unauthorized, // 未登入 (unauthenticated)
  permissionDenied, // 權限不足 (permission-denied)
  initFailed, // 載入或初始化失敗 (所有 Page/VM/B03 的進入失敗)
  dataNotFound, // 找不到資料 (not-found)
  saveFailed, // 儲存/新增/更新失敗
  deleteFailed, // 刪除失敗
  rateFetchFailed, // 匯率取得失敗

  quotaExceeded, // Firebase 額度用完 (resource-exhausted)
  unavailable, // 伺服器不可用 (unavailable)
  timeout, // 請求逾時 (deadline-exceeded)
  networkError, // 網路連線失敗 (network-request-failed)

  incomeIsUsed, // 業務邏輯：款項已使用
  taskLocked, // 業務邏輯：房間已鎖定

  // 邀請流程 (因 UI 顯示內容高度特殊，保留專用碼)
  inviteTaskFull,
  inviteExpired,
  inviteInvalid,
  inviteAlreadyJoined,

  unknown,
}
