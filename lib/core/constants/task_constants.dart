class TaskConstants {
  // 私有建構子，防止這個類別被意外實例化 (instantiated)
  TaskConstants._();

  static const int minMembers = 1;
  static const int maxMembers = 15;

  // 未來如果有其他與 Task 相關的限制也可以放這
  static const int maxTaskNameLength = 20;
  static const int inviteCodeExpiryMinutes = 15;
}
