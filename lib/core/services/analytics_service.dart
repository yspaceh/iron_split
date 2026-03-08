// lib/core/services/analytics_service.dart
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:iron_split/core/constants/app_constants.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/services/logger_service.dart';
import 'package:iron_split/features/onboarding/application/onboarding_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- 定義 Enums 防止參數輸入錯誤 ---

enum InviteEntryPoint { autoAfterCreate, manual }

enum DismissSpeed {
  lt1s('lt_1s'),
  from1sTo3s('1s_to_3s'),
  from3sTo10s('3s_to_10s'),
  gt10s('gt_10s');

  // 定義要送往 Firebase 的字串值
  final String analyticsValue;
  const DismissSpeed(this.analyticsValue);
}

class AnalyticsService {
  AnalyticsService._();
  static final AnalyticsService instance = AnalyticsService._();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  final LoggerService _loggerService = LoggerService.instance;

  // 內部共用的 log 方法，攔截例外避免影響主要業務邏輯
  Future<void> _logEvent(String name, [Map<String, Object>? parameters]) async {
    try {
      await _analytics.logEvent(name: name, parameters: parameters);
      if (kDebugMode) {
        print('📊 [Analytics] Event: $name, Params: $parameters');
      }
    } catch (e, stackTrace) {
      _loggerService.recordError(
        e,
        stackTrace,
        reason: 'AnalyticsService: Failed to log event: $name',
      );
    }
  }

  // ==========================================
  // User Properties
  // ==========================================
  Future<void> setUserProperties({
    required String languageCode,
    required DisplayMode displayMode,
    required bool isEnlarged,
    required String defaultCurrency,
  }) async {
    try {
      await _analytics.setUserProperty(name: 'language', value: languageCode);
      await _analytics.setUserProperty(
          name: 'is_enlarged', value: isEnlarged.toString());
      await _analytics.setUserProperty(
          name: 'display_mode', value: displayMode.name);
      await _analytics.setUserProperty(
          name: 'default_currency', value: defaultCurrency);
    } catch (e, stackTrace) {
      _loggerService.recordError(
        e,
        stackTrace,
        reason: 'AnalyticsService: Failed to set user properties',
      );
    }
  }

  // ==========================================
  // Core Events: A. 任務生命週期
  // ==========================================
  Future<void> logTaskCreate({
    required int expectedDays,
    required int memberTotal,
  }) async {
    await _logEvent('task_create', {
      'expected_days': expectedDays,
      'member_total': memberTotal,
    });
  }

  Future<void> logTaskJoin({
    required InviteMethod method,
  }) async {
    await _logEvent('task_join', {
      'method': method.name,
    });
  }

  Future<void> logTaskDeleteManual({
    required int durationDays,
  }) async {
    await _logEvent('task_delete_manual', {
      'duration_days': durationDays,
    });
  }

  // ==========================================
  // Core Events: B. 記帳與無障礙設定
  // ==========================================
  Future<void> logExpenseAdd({
    required String splitMethod,
    required int subItemsLength,
    required PayerType payerType,
    required String category,
    required bool hasNote,
  }) async {
    await _logEvent('expense_add', {
      'split_method': splitMethod,
      'sub_items_length': subItemsLength.toString(),
      'payer_type': payerType.name,
      'category': category,
      'has_note': hasNote.toString(),
    });
  }

  // ==========================================
  // Core Events: C. 邀請體驗
  // ==========================================
  Future<void> logInviteEntryOpen({
    required InviteEntryPoint entryPoint,
  }) async {
    await _logEvent('invite_entry_open', {
      'entry_point': entryPoint.name,
    });
  }

  Future<void> logInviteSend({
    required InviteMethod method,
    required InviteEntryPoint entryPoint,
  }) async {
    await _logEvent('invite_send', {
      'method': method.name,
      'entry_point': entryPoint.name,
    });
  }

  Future<void> logInviteDismiss({
    required Duration duration,
  }) async {
    await _logEvent('invite_dismiss', {
      'dismiss_speed': _calculateDismissSpeed(duration).analyticsValue,
    });
  }

  // ==========================================
  // Core Events: D. 結算與報表留存
  // ==========================================
  Future<void> logExecuteSettlement({
    required int actualDays,
    required int expenseCount,
    required int memberCount,
    required String remainderRule,
    required int linkedMemberCount,
  }) async {
    await _logEvent('settlement_generate', {
      'actual_days': actualDays,
      'expense_count': expenseCount,
      'member_count': memberCount,
      'remainder_rule': remainderRule,
      'linked_member_count': linkedMemberCount,
    });
  }

  Future<void> logReportExport() async {
    await _logEvent('report_export');
  }

  Future<void> syncUserProperties() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // 1. 抓取語言
      final savedLocale = prefs.getString('app_locale');
      final languageCode =
          savedLocale ?? PlatformDispatcher.instance.locale.languageCode;

      // 2. 抓取預設幣別
      final defaultCurrency =
          prefs.getString('default_currency') ?? CurrencyConstants.defaultCode;

      // 3. 抓取顯示模式
      final savedDisplayMode = prefs.getString('display_mode') ??
          DisplayConstants.defaultDisplay.toString();
      final analyticsDisplayMode =
          DisplayConstants.stringConvertToDisplayMode(savedDisplayMode);

      // 計算 isEnlarged (重現 main.dart 邏輯，不需要從外部傳入)
      bool isEnlarged = false;
      if (analyticsDisplayMode == DisplayMode.enlarged) {
        isEnlarged = true;
      } else if (analyticsDisplayMode == DisplayMode.system) {
        final systemScale = PlatformDispatcher.instance.textScaleFactor;
        if (systemScale > AppConstants.enlargedScale) {
          isEnlarged = true;
        }
      }

      // 4. 送出設定給 Firebase
      await setUserProperties(
        // 呼叫你原本寫好的 setUserProperties
        languageCode: languageCode,
        displayMode: analyticsDisplayMode,
        isEnlarged: isEnlarged,
        defaultCurrency: defaultCurrency,
      );
    } catch (e, stackTrace) {
      _loggerService.recordError(
        e,
        stackTrace,
        reason: 'AnalyticsService: Failed to sync user properties',
      );
    }
  }

  // 輔助方法：將 Duration 轉為你定義的 Enum
  DismissSpeed _calculateDismissSpeed(Duration duration) {
    final seconds = duration.inSeconds;
    if (seconds < 1) return DismissSpeed.lt1s;
    if (seconds < 3) return DismissSpeed.from1sTo3s;
    if (seconds < 10) return DismissSpeed.from3sTo10s;
    return DismissSpeed.gt10s;
  }
}
