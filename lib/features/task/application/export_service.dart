// features/task/application/export_service.dart

import 'package:intl/intl.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/models/record_model.dart';
import 'package:iron_split/core/models/settlement_model.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/core/utils/balance_calculator.dart';
import 'package:iron_split/features/task/data/models/activity_log_model.dart';

class ExportService {
  /// 生成 S17 專業版結算報表 (格式完全依照原始需求)
  String generateProfessionalSettlementCsv({
    required List<RecordModel> records,
    required String taskName,
    required CurrencyConstants baseCurrency,
    required List<SettlementMember> allMembers,
    required List<SettlementMember> clearedMembers,
    required double totalExpense,
    required double totalIncome,
    required double remainderBuffer,
    required String? absorbedBy,
    required Map<String, String> labels, // 由 Page 傳入翻譯好的標籤
    required Map<String, TaskMember> taskMembers, // 用於查詢成員名稱
  }) {
    final buffer = StringBuffer();
    final baseSymbol = baseCurrency.code;
    final String exportTime =
        DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.now());

    // ==========================================
    // Section 1: 報表概況 (Report Info)
    // ==========================================
    buffer.writeln('[${labels['reportInfo']}]');
    buffer.writeln('${labels['taskName']},$taskName');
    buffer.writeln('${labels['exportTime']},$exportTime');
    buffer.writeln('${labels['baseCurrency']},$baseSymbol');
    buffer.writeln('');

    // ==========================================
    // Section 2: 結算總表 (Settlement Summary)
    // ==========================================
    buffer.writeln('[${labels['settlementSummary']}]');
    buffer.writeln(
        '${labels['member']},${labels['role']},${labels['netAmount']} ($baseSymbol),${labels['status']}');

    for (var m in allMembers) {
      final role = m.finalAmount > 0
          ? labels['receiver']
          : (m.finalAmount < 0 ? labels['payer'] : '-');
      final status =
          clearedMembers.contains(m) ? labels['cleared'] : labels['pending'];
      final amount =
          BalanceCalculator.roundToPrecision(m.finalAmount, baseCurrency);
      buffer.writeln(
          '${_escape(m.memberData.displayName)},$role,$amount,$status');
    }
    buffer.writeln('');

    // ==========================================
    // Section 3: 資金與零頭 (Fund Analysis)
    // ==========================================
    buffer.writeln('[${labels['fundAnalysis']}]');
    buffer.writeln(
        '${labels['totalExpense']} ($baseSymbol),${BalanceCalculator.roundToPrecision(totalExpense, baseCurrency)}');
    buffer.writeln(
        '${labels['totalIncome']} ($baseSymbol),${BalanceCalculator.roundToPrecision(totalIncome, baseCurrency)}');
    buffer
        .writeln('${labels['remainderBuffer']} ($baseSymbol),$remainderBuffer');
    if (absorbedBy != null) {
      buffer.writeln('${labels['remainderAbsorbedBy']},$absorbedBy');
    }
    buffer.writeln('');

    // ==========================================
    // Section 4: 交易流水帳 (Transaction Details)
    // ==========================================
    buffer.writeln('[${labels['transactionDetails']}]');

    // Header Row
    buffer.write(
        '${labels['date']},${labels['title']},${labels['type']},${labels['payer']},'
        '${labels['origAmt']},${labels['currency']},${labels['rate']},'
        '${labels['baseAmt']} ($baseSymbol),${labels['netRemainder']}');

    for (var m in allMembers) {
      buffer.write(',${_escape(m.memberData.displayName)} (Net)');
    }
    buffer.writeln();

    // Data Rows
    for (var record in records) {
      final date = record.date.toString().split(' ')[0];
      final title = record.title;
      final type = record.type;

      String payerName = '-';
      if (record.payerType == PayerType.prepay) {
        payerName = labels['pool'] ?? 'Pool';
      } else if (record.payerType == PayerType.mixed) {
        payerName = labels['mixed'] ?? 'Mixed';
      } else if (record.payerType == PayerType.member) {
        if (record.payersId.isEmpty) {
          payerName = 'Unknown Member';
        } else if (record.payersId.length == 1) {
          // 單一付款人：直接取第一個 ID 去找名字
          payerName = taskMembers[record.payersId.first]?.displayName ??
              'Unknown Member';
        } else {
          // 複數付款人：找出所有人的名字並用 ' & ' 串接
          payerName = record.payersId
              .map((id) => taskMembers[id]?.displayName ?? 'Unknown Member')
              .join(' & ');
        }
      }

      final baseAmt = BalanceCalculator.roundToPrecision(
          record.originalAmount * record.exchangeRate, baseCurrency);
      final netRemainder =
          BalanceCalculator.calculateDetailedRemainder(record).net;

      buffer.write('$date,${_escape(title)},$type,${_escape(payerName)},'
          '${record.originalAmount},${record.currencyCode},${record.exchangeRate},'
          '$baseAmt,$netRemainder');

      for (var m in allMembers) {
        final credit = BalanceCalculator.calculatePersonalCredit(
                record, m.memberData.id, baseCurrency)
            .base;
        final debit = BalanceCalculator.calculatePersonalDebit(
                record, m.memberData.id, baseCurrency)
            .base;
        final net = credit - debit;
        buffer
            .write(',${BalanceCalculator.floorToPrecision(net, baseCurrency)}');
      }
      buffer.writeln();
    }

    return buffer.toString();
  }

  /// 專門生成 ActivityLog 的 CSV 內容
  String generateActivityLogCsv({
    required List<ActivityLogModel> logs,
    required String header,
    required String Function(ActivityLogModel) getAction,
    required String Function(ActivityLogModel) getDetails,
    required String Function(String uid) getMemberName,
  }) {
    final buffer = StringBuffer();
    final dateFormat = DateFormat('yyyy/MM/dd HH:mm');

    // 1. 寫入 Header
    buffer.writeln(header);

    // 2. 寫入每一行日誌，保證不簡化任何欄位
    for (final log in logs) {
      final List<String> cells = [
        dateFormat.format(log.createdAt), // 時間
        getMemberName(log.operatorUid), // 使用者
        getAction(log), // 動作
        getDetails(log), // 細節
      ];

      // 使用完整轉義邏輯
      final escapedRow = cells.map(_escape).join(',');
      buffer.writeln(escapedRow);
    }

    return buffer.toString();
  }

  /// 完整保留您的 escape 轉義邏輯
  String _escape(String s) {
    if (s.contains(',') || s.contains('"') || s.contains('\n')) {
      return '"${s.replaceAll('"', '""')}"';
    }
    return s;
  }
}
