// core/services/share_service.dart
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';

class ShareService {
  /// [純文字分享] 用於邀請碼、文字報表
  Future<void> shareText(String text, {String? subject}) async {
    try {
      await SharePlus.instance.share(
        ShareParams(
          text: text,
          subject: subject,
        ),
      );
    } catch (e) {
      throw AppErrorCodes.shareFailed;
    }
  }

  /// [檔案分享] 用於 CSV、PDF
  /// 它負責處理「寫入臨時檔」與「加 BOM」等實體操作
  Future<void> shareFile({
    required String content,
    required String fileName,
    String? subject,
  }) async {
    try {
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/$fileName');

      // 統一加上 BOM (UTF-8) 確保 Excel 不會亂碼
      await file.writeAsString('\uFEFF$content', flush: true);

      await SharePlus.instance.share(
        ShareParams(
          subject: subject,
          files: [XFile(file.path)],
        ),
      );
    } catch (e) {
      throw AppErrorCodes.shareFailed;
    }
  }
}
