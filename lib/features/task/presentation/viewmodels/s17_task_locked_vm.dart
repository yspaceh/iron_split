import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/models/record_model.dart';
import 'package:iron_split/core/models/settlement_model.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/core/utils/balance_calculator.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/record/data/record_repository.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:iron_split/features/task/presentation/viewmodels/balance_summary_state.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

enum LockedPageType { closed, settled }

class S17TaskLockedViewModel extends ChangeNotifier {
  final TaskRepository _taskRepo;
  final RecordRepository _recordRepo;
  final AuthRepository _authRepo;
  final String taskId;

  StreamSubscription? _taskSubscription;

  // UI State
  LoadStatus _initStatus = LoadStatus.initial;
  AppErrorCodes? _initErrorCode;
  LockedPageType _pageType = LockedPageType.closed;
  String _taskName = '';

  TaskModel? _task;
  String _currentUserId = '';

  // S17 Pending View 需要的資料
  bool _isCaptain = false;
  CurrencyConstants _baseCurrency = CurrencyConstants.defaultCurrencyConstants;
  BalanceSummaryState? _balanceState;
  List<SettlementMember> _pendingMembers = [];
  List<SettlementMember> _clearedMembers = [];
  int? _remainingDays;

  // Getters
  LockedPageType get pageType => _pageType;
  LoadStatus get initStatus => _initStatus;
  AppErrorCodes? get initErrorCode => _initErrorCode;
  String get taskName => _taskName;
  bool get isCaptain => _isCaptain;
  CurrencyConstants get baseCurrency => _baseCurrency;
  BalanceSummaryState? get balanceState => _balanceState;
  List<SettlementMember> get pendingMembers => _pendingMembers;
  List<SettlementMember> get clearedMembers => _clearedMembers;
  int? get remainingDays => _remainingDays;
  TaskModel? get task => _task;
  String get currentUserId => _currentUserId;
  bool get hasSeen =>
      _task?.settlement?['viewStatus']?[_currentUserId] ?? false;

  S17TaskLockedViewModel({
    required TaskRepository taskRepo,
    required RecordRepository recordRepo,
    required AuthRepository authRepo,
    required this.taskId,
  })  : _taskRepo = taskRepo,
        _recordRepo = recordRepo,
        _authRepo = authRepo;

  Future<void> init() async {
    _initStatus = LoadStatus.loading;
    _initErrorCode = null;
    notifyListeners();
    try {
      // 登入確認移到 VM
      final user = _authRepo.currentUser;
      if (user == null) {
        _initStatus = LoadStatus.error;
        _initErrorCode = AppErrorCodes.unauthorized;
        notifyListeners();
        return;
      }

      _currentUserId = user.uid;

      _taskSubscription = _taskRepo.streamTask(taskId).listen((task) {
        try {
          if (task == null) throw AppErrorCodes.dataNotFound;
          _task = task;
          _taskName = task.name;
          _baseCurrency =
              CurrencyConstants.getCurrencyConstants(task.baseCurrency);
          _isCaptain = task.createdBy == currentUserId;

          _determineStatusAndParseData(task);

          // 只有成功解析完資料才設為 success
          _initStatus = LoadStatus.success;
          notifyListeners();
        } on AppErrorCodes catch (code) {
          _initStatus = LoadStatus.error;
          _initErrorCode = code;
          notifyListeners();
        } catch (e) {
          _initStatus = LoadStatus.error;
          _initErrorCode = ErrorMapper.parseErrorCode(e);
          notifyListeners();
        }
      }, onError: (e) {
        _initStatus = LoadStatus.error;
        _initErrorCode = ErrorMapper.parseErrorCode(e);
        notifyListeners();
      });
    } catch (e) {
      _initStatus = LoadStatus.error;
      _initErrorCode = ErrorMapper.parseErrorCode(e);
      notifyListeners();
    }
  }

  void _determineStatusAndParseData(TaskModel task) {
    // 1. 決定大狀態
    if (task.status == 'closed') {
      _pageType = LockedPageType.closed;
      return;
    }

    final settlement = task.settlement ?? {};
    final finalizedAtRaw = settlement['finalizedAt'];

    if (finalizedAtRaw != null && finalizedAtRaw is Timestamp) {
      final finalizedDate = finalizedAtRaw.toDate();
      final deadlineDate = finalizedDate.add(const Duration(days: 30));
      final now = DateTime.now();

      // 計算差異天數 (只要還有時間都算 1 天，除非過期)
      final difference = deadlineDate.difference(now).inDays;

      // 如果 difference < 0 代表已過期，這裡取 max(0, diff) 防止負數
      _remainingDays = difference < 0 ? 0 : difference;
    } else {
      // 如果沒有結算時間 (舊資料)，給個預設值或不顯示
      _remainingDays = null;
    }

    // 2. 如果是 Pending，進行資料解析 (原本在 Page 裡的邏輯)
    _pageType = LockedPageType.settled;
    _parsePendingData(task, settlement);
  }

  void _parsePendingData(TaskModel task, Map<String, dynamic> settlement) {
    // A. 解析餘額得主
    final remainderWinnerId = settlement['remainderWinnerId'] as String?;
    String? remainderWinnerName;
    if (remainderWinnerId != null) {
      final winner = task.members[remainderWinnerId];
      if (winner != null) remainderWinnerName = winner['displayName'];
    }

    // 嘗試從 dashboardSnapshot 讀取，如果沒有(舊資料)則 fallback 到初始狀態
    final snapshotMap =
        settlement['dashboardSnapshot'] as Map<String, dynamic>?;

    if (snapshotMap != null) {
      // 1. 還原
      final loadedState = BalanceSummaryState.fromMap(snapshotMap);

      // 2. 覆蓋 (Override) S17 專屬設定
      // 雖然 Snapshot 裡可能已存了 locked=true，但為了保險起見我們再次強制鎖定
      // 並且使用最新的 member name (防止結算後有人改名，導致顯示舊名字)
      _balanceState = loadedState.copyWith(
        isLocked: true,
        absorbedBy: remainderWinnerName,
      );
    } else {
      // Fallback: 針對舊資料的防呆 (顯示全 0)
      _balanceState = BalanceSummaryState.initial().copyWith(
        currencyCode: task.baseCurrency,
        currencySymbol: _baseCurrency.symbol,
        isLocked: true,
        absorbedBy: remainderWinnerName,
      );
    }

    // C. 解析成員列表
    final allocations =
        Map<String, dynamic>.from(settlement['allocations'] ?? {});
    final memberStatus =
        Map<String, dynamic>.from(settlement['memberStatus'] ?? {});

    _pendingMembers = [];
    _clearedMembers = [];

    allocations.forEach((uid, amountRaw) {
      final memberData = task.members[uid];
      if (memberData == null) return;

      final double amount = (amountRaw as num).toDouble();
      final bool isCleared = memberStatus[uid] == true;

      final member = SettlementMember(
        id: uid,
        displayName: memberData['displayName'] ?? 'Unknown',
        avatar: memberData['avatar'],
        isLinked: memberData['isLinked'] ?? false,
        finalAmount: amount,
        baseAmount: amount,
        remainderAmount: 0,
        isRemainderAbsorber: uid == remainderWinnerId,
        isRemainderHidden: false,
      );

      if (isCleared) {
        _clearedMembers.add(member);
      } else {
        _pendingMembers.add(member);
      }
    });

    // 排序
    _pendingMembers
        .sort((a, b) => b.finalAmount.abs().compareTo(a.finalAmount.abs()));
    _clearedMembers
        .sort((a, b) => b.finalAmount.abs().compareTo(a.finalAmount.abs()));
  }

// [在 S17TaskLockedViewModel class 內]

  /// [重構] 下載專業版結算報表 (包含細項)
  Future<void> exportSettlementRecord() async {
    if (_task == null || _balanceState == null) return;

    try {
      // 1. 為了產生細項，必須先抓取所有 Records
      // (原本的 exportSettlementRecord 只有摘要，現在我們需要細節)
      final List<RecordModel> records =
          await _recordRepo.getRecordsOnce(taskId);
      // 按日期排序 (最新的在上面)
      records.sort((a, b) => b.date.compareTo(a.date));

      // 2. 產生專業格式 CSV 內容
      final String csvContent = _generateProfessionalCsv(records);

      // 3. 取得暫存路徑 & 存檔
      final directory = await getTemporaryDirectory();
      final dateStr = DateTime.now().toIso8601String().split('T').first;
      // 檔名: JapanTrip_Settlement_Report_20260211.csv
      final fileName = "${_taskName}_Settlement_Report_$dateStr.csv";
      final file = File('${directory.path}/$fileName');

      // 加入 BOM (\uFEFF) 解決 Excel 中文亂碼問題
      await file.writeAsString('\uFEFF$csvContent', flush: true);

      // 4. 分享檔案
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: '$_taskName Settlement Report',
      );
    } on AppErrorCodes {
      rethrow;
    } catch (e) {
      throw ErrorMapper.parseErrorCode(e); // 其他系統錯誤轉化後拋出
    }
  }

  /// 生成專業版 CSV 內容
  String _generateProfessionalCsv(List<RecordModel> records) {
    final buffer = StringBuffer();
    final baseSymbol = _baseCurrency.code;
    final allMembers = [..._pendingMembers, ..._clearedMembers];

    // ==========================================
    // Section 1: 報表概況 (Report Info)
    // ==========================================
    buffer.writeln('[Report Info]');
    buffer.writeln('Task Name,$_taskName');
    buffer.writeln('Export Time,${DateTime.now().toString().split('.')[0]}');
    buffer.writeln('Base Currency,$baseSymbol');
    buffer.writeln(''); // 空行分隔

    // ==========================================
    // Section 2: 結算總表 (Settlement Summary)
    // ==========================================
    buffer.writeln('[Settlement Summary]');
    buffer.writeln('Member,Role,Net Amount ($baseSymbol),Status');

    for (var m in allMembers) {
      final role =
          m.finalAmount > 0 ? 'Receiver' : (m.finalAmount < 0 ? 'Payer' : '-');
      final status = _clearedMembers.contains(m) ? 'Cleared' : 'Pending';
      final amount =
          BalanceCalculator.roundToPrecision(m.finalAmount, _baseCurrency);
      buffer.writeln('${m.displayName},$role,$amount,$status');
    }
    buffer.writeln('');

    // ==========================================
    // Section 3: 資金與零頭 (Fund Analysis)
    // ==========================================
    buffer.writeln('[Fund Analysis]');

    // 計算總數值
    final totalExp = BalanceCalculator.roundToPrecision(
        _balanceState!.totalExpense, _baseCurrency);
    final totalInc = BalanceCalculator.roundToPrecision(
        _balanceState!.totalIncome, _baseCurrency);
    // 零頭 (使用新版動態計算)
    final remainderBuffer = BalanceCalculator.calculateRemainderBuffer(records);

    buffer.writeln('Total Expense ($baseSymbol),$totalExp');
    buffer.writeln('Total Pool Income ($baseSymbol),$totalInc');
    buffer.writeln('Remainder Buffer ($baseSymbol),$remainderBuffer');
    if (_balanceState!.absorbedBy != null) {
      buffer.writeln('Remainder Absorbed By,${_balanceState!.absorbedBy}');
    }
    buffer.writeln('');

    // ==========================================
    // Section 4: 交易流水帳 (Transaction Details)
    // ==========================================
    buffer.writeln('[Transaction Details]');

    // Header Row
    // Header Row
    buffer.write(
        'Date,Title,Type,Payer,Original Amt,Currency,Rate,Base Amt ($baseSymbol),Net Remainder (Adj.)');
    // 動態加入成員欄位
    for (var m in allMembers) {
      buffer.write(',${m.displayName} (Net)');
    }
    buffer.writeln();

    // Data Rows
    for (var record in records) {
      // A. 基本欄位
      final date = record.date.toString().split(' ')[0];
      final title = record.title.replaceAll(',', ' '); // 避免 CSV 格式跑掉
      final type = record.type; // expense / income

      // 支付者名稱處理
      String payerName = '-';
      if (record.payerType == 'prepay') {
        payerName = 'Pool';
      } else if (record.payerType == 'mixed')
        // ignore: curly_braces_in_flow_control_structures
        payerName = 'Mixed';
      else if (record.payerType == 'member') {
        payerName = _task?.members[record.payerId]?['displayName'] ?? 'Unknown';
      }

      final originalAmt = record.originalAmount;
      final currency = record.currencyCode;
      final rate = record.exchangeRate;

      // Base Amount (四捨五入後的本幣金額)
      final baseAmt =
          BalanceCalculator.roundToPrecision(originalAmt * rate, _baseCurrency);

      // 使用 calculateDetailedRemainder 取得物件
      final remainderDetail =
          BalanceCalculator.calculateDetailedRemainder(record);

      // 取出淨零頭 (這是最終影響系統餘額的數字)
      // 如果 Consumer=1, Payer=1, Net=0 -> 這裡會顯示 0
      final netRemainder = remainderDetail.net;

      buffer.write(
          '$date,$title,$type,$payerName,$originalAmt,$currency,$rate,$baseAmt,$netRemainder');

      // B. 成員淨額 (Net Impact)
      for (var m in allMembers) {
        // 使用 BalanceCalculator 計算 Credit - Debit
        final credit = BalanceCalculator.calculatePersonalCredit(
                record, m.id, _baseCurrency)
            .base;
        final debit = BalanceCalculator.calculatePersonalDebit(
                record, m.id, _baseCurrency)
            .base;
        final net = credit - debit;

        final netStr = BalanceCalculator.floorToPrecision(net, _baseCurrency);
        buffer.write(',$netStr');
      }
      buffer.writeln();
    }

    return buffer.toString();
  }

  @override
  void dispose() {
    // [修正] 頁面銷毀時，務必取消訂閱！
    _taskSubscription?.cancel();
    super.dispose();
  }
}
