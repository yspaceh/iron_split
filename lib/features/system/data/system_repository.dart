// lib/features/system/data/system_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iron_split/core/base/base_repository.dart'; // 參照 RecordRepository
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/models/payment_info_model.dart';
import 'package:iron_split/core/services/preferences_service.dart';

class SystemRepository extends BaseRepository {
  final PreferencesService _prefsService;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  SystemRepository(this._prefsService);

  /// 讀取預設收款資訊
  Future<PaymentInfoModel?> getDefaultPaymentInfo() async {
    // 使用 safeRun 包裹，確保錯誤都被轉成 AppErrorCodes.initFailed 或自定義代碼
    return await safeRun(() async {
      final jsonStr = await _prefsService.getDefaultPaymentInfo();
      if (jsonStr == null) return null;

      try {
        return PaymentInfoModel.fromJson(jsonStr);
      } catch (e) {
        // 雖然 PreferencesService 讀取成功，但如果 JSON 解析失敗，視為初始化失敗
        throw AppErrorCodes.initFailed;
      }
    }, AppErrorCodes.initFailed);
  }

  /// 儲存預設收款資訊
  Future<void> saveDefaultPaymentInfo(PaymentInfoModel info) async {
    // 儲存失敗時，統一轉為 AppErrorCodes.saveFailed
    await safeRun(() async {
      await _prefsService.saveDefaultPaymentInfo(info.toJson());
    }, AppErrorCodes.saveFailed);
  }

  /// 檢查法律條款版本狀態
  /// 回傳內容包含：是否需要更新 TOS、是否需要更新 Privacy
  Future<({bool tosOutdated, bool privacyOutdated})> checkLegalVersionStatus(
      String uid) async {
    return await safeRun(() async {
      final results = await Future.wait([
        _firestore.collection('config').doc('legal').get(),
        _firestore.collection('users').doc(uid).get(),
      ]);

      final sysData = results[0].data();
      final userData = results[1].data();

      final int sysTos = sysData?['latest_tos_version'] ?? 1;
      final int sysPrivacy = sysData?['latest_privacy_version'] ?? 1;

      final int userTos = userData?['agreed_tos_version'] ?? 0;
      final int userPrivacy = userData?['agreed_privacy_version'] ?? 0;

      return (
        tosOutdated: userTos < sysTos,
        privacyOutdated: userPrivacy < sysPrivacy,
      );
    }, AppErrorCodes.initFailed);
  }
}
