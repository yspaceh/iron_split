import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:share_plus/share_plus.dart';

class TaskShareHelper {
  /// 分享任務邀請連結
  /// [existingCode]: 如果已經有邀請碼 (如 S16)，直接傳入可跳過 API 呼叫
  static Future<void> inviteMember({
    required BuildContext context,
    required String taskId,
    required String taskName,
    String? existingCode, // ✅ 新增選填參數
  }) async {
    final t = Translations.of(context);
    String code;

    // 1. 判斷是否需要呼叫 Cloud Function
    if (existingCode != null && existingCode.isNotEmpty) {
      code = existingCode;
    } else {
      // S53 情境：沒有 Code，去雲端拿
      try {
        final callable =
            FirebaseFunctions.instance.httpsCallable('createInviteCode');
        final res = await callable.call({'taskId': taskId});
        final data = Map<String, dynamic>.from(res.data);
        code = data['code'];
      } catch (e) {
        // TODO: 建議：這裡可以 throw 出去讓 UI 決定怎麼顯示錯誤，或是直接顯示 SnackBar
        rethrow;
      }
    }

    // 2. 統一組裝連結 (Single Source of Truth)
    // 確保這裡的 schema 全 App 只有一個地方定義
    final inviteLink = 'iron-split://join?code=$code';

    // 3. 觸發原生 Share Sheet
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
