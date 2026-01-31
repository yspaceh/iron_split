import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/gen/strings.g.dart';

enum LogAction {
  createTask,
  updateSettings,
  addMember,
  removeMember,
  createRecord,
  updateRecord,
  deleteRecord,
  settleUp,
  closeTask,
  unknown,
}

class LogDisplayInfo {
  final String title; // e.g. "新增記帳：[支出]"
  final String mainLine; // e.g. "晚餐 (3000) • 支付：多人(2)"
  final String? subLine; // e.g. "- drink (1000...) - base (2000...)" (Nullable)

  LogDisplayInfo(this.title, this.mainLine, this.subLine);
}

class ActivityLogModel {
  final String id;
  final String operatorUid;
  final LogAction actionType;
  final Map<String, dynamic> details;
  final DateTime createdAt;

  ActivityLogModel({
    required this.id,
    required this.operatorUid,
    required this.actionType,
    required this.details,
    required this.createdAt,
  });

  factory ActivityLogModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ActivityLogModel(
      id: doc.id,
      operatorUid: data['operatorUid'] ?? '',
      actionType: _parseAction(data['actionType']),
      details: data['details'] as Map<String, dynamic>? ?? {},
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  static LogAction _parseAction(String? type) {
    switch (type) {
      case 'create_task':
        return LogAction.createTask;
      case 'update_settings':
        return LogAction.updateSettings;
      case 'add_member':
        return LogAction.addMember;
      case 'remove_member':
        return LogAction.removeMember;
      case 'create_record':
        return LogAction.createRecord;
      case 'update_record':
        return LogAction.updateRecord;
      case 'delete_record':
        return LogAction.deleteRecord;
      case 'settle_up':
        return LogAction.settleUp;
      default:
        return LogAction.unknown;
    }
  }

  String getLocalizedAction(BuildContext context) {
    switch (actionType) {
      case LogAction.createTask:
        return t.log_action.create_task;
      case LogAction.updateSettings:
        return t.log_action.update_settings;
      case LogAction.addMember:
        return t.log_action.add_member;
      case LogAction.removeMember:
        return t.log_action.remove_member;
      case LogAction.createRecord:
        return t.log_action.create_record;
      case LogAction.updateRecord:
        return t.log_action.update_record;
      case LogAction.deleteRecord:
        return t.log_action.delete_record;
      case LogAction.settleUp:
        return t.log_action.settle_up;
      case LogAction.closeTask:
        return t.log_action.close_task;
      case LogAction.unknown:
        return t.log_action.unknown;
    }
  }

  /// 將詳細資訊轉為單行字串 (用於舊資料相容或非記帳類 Log)
  String getFormattedDetails(BuildContext context) {
    final t = Translations.of(context);
    final buffer = StringBuffer();

    // --- Helper Functions (與 getDisplayInfo 共用邏輯，但在這裡局部定義也可) ---
    String getSplitMethodName(String code) {
      switch (code) {
        case 'even':
          return t.S15_Record_Edit.method_even;
        case 'exact':
          return t.S15_Record_Edit.method_exact;
        case 'percent':
          return t.S15_Record_Edit.method_percent;
        case 'share':
          return t.S15_Record_Edit.method_share;
        case 'adjustment':
          return t.S15_Record_Edit.method_adjustment;
        default:
          return code;
      }
    }

    String getPayerName(String nameOrCode) {
      if (nameOrCode == 'multiple') return t.S15_Record_Edit.payer_multiple;
      if (nameOrCode == 'none') return '';
      return nameOrCode;
    }

    String getRecordTypeTag(String type) {
      if (type == 'income') {
        return "[${t.S52_TaskSettings_Log.type_income}]"; // 使用 S52 Key
      }
      if (type == 'expense') {
        return "[${t.S52_TaskSettings_Log.type_expense}]"; // 使用 S52 Key
      }
      return "";
    }
    // ------------------------------------------

    // 1. 處理「設定變更」 (S14, S16) - 保持不變，這是正確的
    if (details.containsKey('settingType')) {
      final type = details['settingType'];
      final val = details['newValue'];

      switch (type) {
        case 'task_name':
          return "${t.S16_TaskCreate_Edit.label_name}: $val";
        case 'date_range':
          return "${t.S16_TaskCreate_Edit.label_date}: $val";
        case 'currency':
          return "${t.S16_TaskCreate_Edit.label_currency}: $val";
        case 'remainder_rule':
          String ruleName = val.toString();
          if (val == 'random') ruleName = t.S13_Task_Dashboard.rule_random;
          if (val == 'order') ruleName = t.S13_Task_Dashboard.rule_order;
          if (val == 'member') ruleName = t.S13_Task_Dashboard.rule_member;
          return "${t.S14_Task_Settings.section_remainder}: $ruleName";
        default:
          return "$val";
      }
    }

    // 2. 處理「舊格式的記帳資料」 (Fallback)

    // [標籤]
    if (details.containsKey('recordType')) {
      buffer.write("${getRecordTypeTag(details['recordType'])} ");
    }

    // [名稱]
    if (details.containsKey('recordName')) {
      buffer.write(details['recordName']);
    }

    // [金額]
    if (details.containsKey('currency') && details.containsKey('amount')) {
      if (buffer.isNotEmpty) buffer.write(" ");
      final currency = details['currency'];
      final amount = CurrencyOption.formatAmount(details['amount'], currency);

      if (details.containsKey('oldAmount')) {
        final oldAmt =
            CurrencyOption.formatAmount(details['oldAmount'], currency);
        buffer.write("($currency $oldAmt -> $amount)");
      } else {
        buffer.write("($currency $amount)");
      }
    }

    // [日期範圍 (Create Task)]
    if (details.containsKey('dateRange')) {
      buffer.write(" (${details['dateRange']})");
    }

    // [舊版付款人]
    if (details.containsKey('payerName') && details['payerName'] != 'none') {
      final translatedPayer = getPayerName(details['payerName']);
      buffer.write(" • $translatedPayer");
    }

    // [舊版分帳資訊]
    if (details.containsKey('splitCount')) {
      // [修正] 使用 i18n key 取代 "ppl"
      final unit = t.S52_TaskSettings_Log.unit_members;
      buffer.write(" • ${details['splitCount']} $unit");

      if (details.containsKey('splitMethod')) {
        final method = getSplitMethodName(details['splitMethod']);
        buffer.write(" ($method)");
      }
    }

    // [舊版細項數量]
    if (details.containsKey('itemCount') && (details['itemCount'] as int) > 0) {
      // [修正] 使用 i18n key 取代 "items"
      final unit = t.S52_TaskSettings_Log.unit_items;
      buffer.write(" • ${details['itemCount']} $unit");
    }

    // 兜底
    if (buffer.isEmpty && details.isNotEmpty) {
      return details.values.first.toString();
    }

    return buffer.toString();
  }

  LogDisplayInfo getDisplayInfo(BuildContext context) {
    final t = Translations.of(context);

    // Helper: 翻譯分帳方式
    String getSplitMethodName(String code) {
      switch (code) {
        case 'even':
          return t.S15_Record_Edit.method_even;
        case 'exact':
          return t.S15_Record_Edit.method_exact;
        case 'percent':
          return t.S15_Record_Edit.method_percent;
        case 'share':
          return t.S15_Record_Edit.method_share;
        case 'adjustment':
          return t.S15_Record_Edit.method_adjustment;
        default:
          return code;
      }
    }

    // 1. 標題 (Title)
    // 格式: "新增記帳：[支出]"
    String title = getLocalizedAction(context);
    if (details.containsKey('recordType')) {
      final typeStr = details['recordType'] == 'income'
          ? t.S52_TaskSettings_Log.type_income // "預收"
          : t.S52_TaskSettings_Log.type_expense; // "支出"
      title += "：[$typeStr]";
    }

    // 2. 內容 (Main & Sub Lines)
    final bufferMain = StringBuffer();
    final bufferSub = StringBuffer();

    if (details.containsKey('allocation') && details.containsKey('payment')) {
      final allocation = details['allocation'] as Map<String, dynamic>;
      final payment = details['payment'] as Map<String, dynamic>;
      final groups =
          (allocation['groups'] as List).cast<Map<String, dynamic>>();
      final mode = allocation['mode'];

      final currency = details['currency'];
      final totalAmt = CurrencyOption.formatAmount(details['amount'], currency);
      final recordName = details['recordName'];

      // --- A. 主行 (名稱 + 金額 + 分帳簡述) ---
      // 格式: "晚餐 (JPY 3,000"
      bufferMain.write("$recordName ($currency $totalAmt");

      // 基本模式顯示簡略分帳
      if (mode == 'basic' && groups.isNotEmpty) {
        final g = groups.first;
        final method = getSplitMethodName(g['method']);
        final unit = t.S52_TaskSettings_Log.unit_members;
        bufferMain.write(" / ${g['count']}$unit $method");
      }
      bufferMain.write(")");

      // --- B. 支付資訊 ---
      // 格式: " • 支付：xxx"
      bufferMain.write(" • ${t.S52_TaskSettings_Log.label_payment}：");

      final payType = payment['type'];
      if (payType == 'income') {
        bufferMain.write(t.S52_TaskSettings_Log.payment_income); // "預收款"
      } else if (payType == 'pool') {
        bufferMain.write(t.S52_TaskSettings_Log.payment_pool); // "公款支付"
      } else if (payType == 'single') {
        final contributors = (payment['contributors'] as List);
        if (contributors.isNotEmpty) {
          // "Alice代墊"
          bufferMain.write(
              "${contributors.first['displayName']}${t.S52_TaskSettings_Log.payment_single_suffix}");
        }
      } else if (payType == 'multiple') {
        final list = payment['contributors'] as List;
        final unit = t.S52_TaskSettings_Log.unit_members;
        // "多人代墊(2人)"
        bufferMain.write(
            "${t.S52_TaskSettings_Log.payment_multiple}(${list.length}$unit)");
      }

      // --- C. 子行 (詳細分拆) ---
      // 只有混合模式才顯示
      if (mode == 'hybrid') {
        final subItems = groups.map((g) {
          final label = g['label'];
          final amt = CurrencyOption.formatAmount(g['amount'], currency);
          final count = g['count'];
          final method = getSplitMethodName(g['method']);
          final unit = t.S52_TaskSettings_Log.unit_members;
          // 格式: "- drink (JPY 1,000 / 2人 平分)"
          return "- $label ($currency $amt / $count$unit $method)";
        }).join("\n");

        bufferSub.write(subItems);
      }
    } else {
      // Fallback
      bufferMain.write(getFormattedDetails(context));
    }

    return LogDisplayInfo(title, bufferMain.toString(),
        bufferSub.isNotEmpty ? bufferSub.toString() : null);
  }
}
