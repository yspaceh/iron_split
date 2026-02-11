import 'package:flutter/material.dart';
import 'package:iron_split/core/services/deep_link_service.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:share_plus/share_plus.dart';

class TaskShareHelper {
  /// 分享任務邀請連結
  /// [inviteCode]: 強制由外部傳入，Helper 不再負責呼叫 API
  static Future<void> inviteMember({
    required BuildContext context,
    required String taskName,
    required String inviteCode,
  }) async {
    final t = Translations.of(context);
    final link = DeepLinkService().generateJoinLink(inviteCode);

    // 3. 觸發原生 Share Sheet
    await SharePlus.instance.share(
      ShareParams(
        text: t.common.share.invite.message(
          taskName: taskName,
          code: inviteCode,
          link: link,
        ),
        subject: t.common.share.invite.subject,
      ),
    );
  }

  /// 分享結算通知 (S17/S32 使用)
  static Future<void> shareSettlement({
    required BuildContext context,
    required String taskId,
    required String taskName,
  }) async {
    final t = Translations.of(context);
    final link = DeepLinkService().generateTaskLink(taskId);

    // 3. 呼叫原生分享
    await SharePlus.instance.share(
      ShareParams(
        text: t.common.share.settlement.message(
          taskName: taskName,
          link: link,
        ),
        subject: t.common.share.settlement.subject,
      ),
    );
  }
}
