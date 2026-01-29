import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:share_plus/share_plus.dart';

class TaskShareHelper {
  /// 生成邀請碼並呼叫原生分享
  /// 回傳 void，若發生錯誤會拋出 exception 讓 UI 層處理 (例如顯示 Snackbar)
  static Future<void> inviteMember({
    required BuildContext context,
    required String taskId,
    required String taskName,
  }) async {
    final t = Translations.of(context);

    // 1. 呼叫 Cloud Function 取得邀請碼
    // 注意：這裡假設 network 正常，UI 層應在呼叫前顯示 Loading 指示器
    final callable =
        FirebaseFunctions.instance.httpsCallable('createInviteCode');

    // 執行 Cloud Function
    final res = await callable.call({'taskId': taskId});

    // 解析回傳資料
    final data = Map<String, dynamic>.from(res.data);
    final code = data['code'];

    // 2. 組裝連結
    // 請確認這與 D03 的邏輯一致，通常 schema 是 iron-split:// 或 https://
    final inviteLink = 'iron-split://join?code=$code';

    // 3. 觸發原生 Share Sheet
    // 使用 share_plus 的標準靜態方法
    await SharePlus.instance.share(
      ShareParams(
        text: t.D03_TaskCreate_Confirm.share_message(
          taskName: taskName,
          code: code,
          link: inviteLink,
        ),
        subject: t.D03_TaskCreate_Confirm.share_subject,
      ),
    );
  }
}
