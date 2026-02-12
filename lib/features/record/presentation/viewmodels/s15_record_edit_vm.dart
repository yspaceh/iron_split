import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/category_constants.dart';
import 'package:iron_split/core/constants/split_method_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/models/record_model.dart';
import 'package:iron_split/core/services/currency_service.dart';
import 'package:iron_split/core/services/preferences_service.dart';
import 'package:iron_split/core/utils/balance_calculator.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/record/application/record_service.dart';
import 'package:iron_split/features/record/data/record_repository.dart';
import 'package:iron_split/features/task/data/models/activity_log_model.dart';
import 'package:iron_split/features/task/data/services/activity_log_service.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:iron_split/gen/strings.g.dart';

class S15RecordEditViewModel extends ChangeNotifier {
  // Input Controllers (Keep in VM to manage text state)
  final amountController = TextEditingController();
  final exchangeRateController = TextEditingController(text: '1.0');
  final titleController = TextEditingController();
  final memoController = TextEditingController();
  final RecordRepository _recordRepo;
  final TaskRepository _taskRepo;
  late final RecordService _recordService;

  // Basic State
  late DateTime _selectedDate;
  late CurrencyConstants _selectedCurrencyConstants;
  String _selectedCategoryId = CategoryConstant.defaultCategory;
  int _recordTypeIndex = 0; // 0: expense, 1: income

  // Loading State
  bool _isRateLoading = false;
  bool _isSaving = false;

  LoadStatus _initStatus = LoadStatus.loading;
  AppErrorCodes? _initErrorCode;

  // Payment State
  String _payerType = 'prepay';
  String _payerId = '';
  Map<String, dynamic>? _complexPaymentData;

  // Members State
  List<Map<String, dynamic>> _taskMembers = [];

  // Split State
  final List<RecordDetail> _details = [];
  String _baseSplitMethod = SplitMethodConstant.defaultMethod;
  List<String> _baseMemberIds = [];
  Map<String, double> _baseRawDetails = {}; // For advanced split

  // Helper
  double _lastKnownAmount = 0.0;
  bool _isCurrencyInitialized = false;

  // 外部傳入參數
  final String taskId;
  final String? recordId;
  final RecordModel? _originalRecord;
  final CurrencyConstants baseCurrency;
  final Map<String, double> poolBalancesByCurrency;

  // Getters
  DateTime get selectedDate => _selectedDate;
  CurrencyConstants get selectedCurrencyConstants => _selectedCurrencyConstants;
  String get selectedCategoryId => _selectedCategoryId;
  int get recordTypeIndex => _recordTypeIndex;

  bool get isRateLoading => _isRateLoading;
  bool get isSaving => _isSaving;
  LoadStatus get initStatus => _initStatus;
  AppErrorCodes? get initErrorCode => _initErrorCode;

  String get payerType => _payerType;
  String get payerId => _payerId;
  Map<String, dynamic>? get complexPaymentData => _complexPaymentData;

  List<Map<String, dynamic>> get taskMembers => _taskMembers;
  List<RecordDetail> get details => _details;
  String get baseSplitMethod => _baseSplitMethod;
  List<String> get baseMemberIds => _baseMemberIds;
  Map<String, double> get baseRawDetails => _baseRawDetails;

  // Computed Properties
  double get totalAmount => double.tryParse(amountController.text) ?? 0.0;

  double get exchangeRateValue =>
      double.tryParse(exchangeRateController.text) ?? 1.0;

  double get amountToSplit =>
      _recordTypeIndex == 1 ? totalAmount : baseRemainingAmount;

  double get baseRemainingAmount {
    final subTotal = _details.fold(0.0, (prev, curr) => prev + curr.amount);
    final remaining = totalAmount - subTotal;
    return remaining > 0 ? remaining : 0.0;
  }

  /// 供 B07 使用的初始墊付資料
  Map<String, double> getInitialMemberAdvance() {
    if (_complexPaymentData?['memberAdvance'] != null) {
      return Map<String, double>.from(_complexPaymentData!['memberAdvance']);
    }
    return (_payerType == 'member' ? {_payerId: totalAmount} : {});
  }

  /// 取得所有成員的預設分帳比例 (供 B03/B02 使用)
  Map<String, double> get memberDefaultWeights {
    return {
      for (var m in _taskMembers)
        (m['id'] as String): (m['defaultSplitRatio'] as num? ?? 1.0).toDouble()
    };
  }

  bool get hasPaymentError {
    // 1. 如果不是選擇「全額公款支付」，則不在此處檢核 (Mixed 模式會有另外的檢核)
    if (_payerType != 'prepay') return false;

    final currentAmount = totalAmount;
    if (currentAmount <= 0) return false;

    // 2. 取得帳面餘額 (這是資料庫目前的餘額，已經扣除過此筆費用的舊金額)
    double availableBalance =
        poolBalancesByCurrency[_selectedCurrencyConstants.code] ?? 0.0;

    // 3. [修正邏輯] 校正可用餘額
    // 如果是「編輯模式」(_originalRecord != null)，
    // 且「原本就是用同幣別公款支付」，我們要先把舊的金額「加回來」視為可用額度。
    if (_originalRecord != null &&
        _originalRecord!.originalCurrencyCode ==
            _selectedCurrencyConstants.code) {
      // 情況 A: 原本這筆紀錄就是「全額公款」
      if (_originalRecord!.payerType == 'prepay') {
        availableBalance += _originalRecord!.originalAmount;
      }
      // 情況 B: 原本這筆紀錄是「混合支付」，且有使用到公款
      else if (_originalRecord!.payerType == 'mixed' &&
          _originalRecord!.paymentDetails != null) {
        final oldPrepayAmount =
            (_originalRecord!.paymentDetails!['prepayAmount'] as num?)
                    ?.toDouble() ??
                0.0;
        availableBalance += oldPrepayAmount;
      }
    }

    // 4. 判斷餘額是否足夠 (容許 0.01 誤差)
    // 現在 availableBalance 代表「如果我不付這筆錢，錢包裡會有多少錢」
    return availableBalance < (currentAmount - 0.01);
  }

  /// 提供給 UI 顯示的詳細零頭結構 (Consumer, Payer, Net)
  /// 完全委派給 BalanceCalculator 計算，確保邏輯單一
  RemainderDetail get remainderDetail {
    final double exchangeRate =
        double.tryParse(exchangeRateController.text) ?? 1.0;

    // 1. 建構一個暫時的 RecordModel 用於計算
    // 注意：這裡只填入計算所需的必要欄位
    final tempRecord = RecordModel(
      id: recordId ?? 'temp',
      date: _selectedDate,
      title: '',
      type: _recordTypeIndex == 1 ? 'income' : 'expense',
      categoryIndex: 0,
      categoryId: _selectedCategoryId,

      // 付款資訊
      payerType: _recordTypeIndex == 1 ? 'none' : _payerType,
      payerId:
          (_recordTypeIndex == 0 && _payerType == 'member') ? _payerId : null,
      paymentDetails: _recordTypeIndex == 1 ? null : _complexPaymentData,

      // 金額與匯率
      amount: totalAmount,
      currencyCode: _selectedCurrencyConstants.code,
      exchangeRate: exchangeRate,
      remainder: 0, // 暫時填 0，不影響計算

      // 分帳邏輯
      splitMethod: _baseSplitMethod,
      splitMemberIds: _baseMemberIds,
      splitDetails: _baseRawDetails,

      // 細項 (Income 沒有 details)
      details: _recordTypeIndex == 1 ? [] : _details,

      memo: '',
      createdAt: DateTime.now(),
      createdBy: '',
    );

    // 2. 呼叫 BalanceCalculator 的靜態方法
    // 這是我們剛剛在 BalanceCalculator 新增的方法
    return BalanceCalculator.calculateDetailedRemainder(tempRecord);
  }

  // Constructor
  S15RecordEditViewModel({
    required this.taskId,
    required RecordRepository recordRepo,
    required TaskRepository taskRepo,
    this.recordId,
    RecordModel? record,
    this.baseCurrency = CurrencyConstants.defaultCurrencyConstants,
    this.poolBalancesByCurrency = const {},
    DateTime? initialDate,
  })  : _recordRepo = recordRepo,
        _taskRepo = taskRepo,
        _originalRecord = record {
    _recordService = RecordService(_recordRepo, _taskRepo);
    _init(initialDate);
  }

  void _init(DateTime? initialDate) {
    // 1. 同步設定區 (Safe Zone) - 絕對不加 listener
    if (_originalRecord != null) {
      final r = _originalRecord!;
      _recordTypeIndex = r.type == 'income' ? 1 : 0;

      // 直接賦值，不觸發 listener
      amountController.text =
          r.originalAmount.truncateToDouble() == r.originalAmount
              ? r.originalAmount.toInt().toString()
              : r.originalAmount.toString();

      _selectedDate = r.date;
      _selectedCurrencyConstants =
          CurrencyConstants.getCurrencyConstants(r.originalCurrencyCode);
      exchangeRateController.text = r.exchangeRate.toString();

      if (r.type == 'expense') {
        titleController.text = r.title;
        _selectedCategoryId = r.categoryId;
      }
      memoController.text = r.memo ?? '';
      _payerType = r.payerType;
      _payerId = r.payerId ?? '';
      _complexPaymentData = r.paymentDetails;
      _baseSplitMethod = r.splitMethod;
      _baseMemberIds = List.from(r.splitMemberIds);
      _baseRawDetails = Map.from(r.splitDetails ?? {});
      _details.addAll(r.details);
    } else {
      _selectedDate = initialDate ?? DateTime.now();
      _selectedCurrencyConstants = baseCurrency;
    }

    _lastKnownAmount = totalAmount;

    // 2. 強制異步執行區 (Unsafe Zone)
    // 使用 Future.delayed(Duration.zero) 強制排程到下一個 Event Loop
    Future.delayed(Duration.zero, () {
      // A. 現在才加 Listener
      amountController.addListener(_onAmountChanged);
      // B. 執行資料載入
      if (_originalRecord == null) {
        _loadCurrencyPreference();
      }
      fetchTaskData();
    });
  }

  // Logic Methods

  Future<void> initCurrency() async {
    if (_originalRecord == null && !_isCurrencyInitialized) {
      _isCurrencyInitialized = true;
      final suggested = CurrencyConstants.detectSystemCurrency();
      if (suggested != CurrencyConstants.defaultCurrencyConstants) {
        _selectedCurrencyConstants = suggested;
        notifyListeners();
      }
    }
  }

  Future<void> _loadCurrencyPreference() async {
    final lastCurrency = await PreferencesService.getLastCurrency();
    if (lastCurrency != null) {
      _selectedCurrencyConstants =
          CurrencyConstants.getCurrencyConstants(lastCurrency);
      if (_selectedCurrencyConstants != baseCurrency) {
        updateCurrency(_selectedCurrencyConstants.code); // Trigger rate fetch
      } else {
        notifyListeners();
      }
    }
  }

  Future<void> fetchTaskData() async {
    try {
      if (_initStatus != LoadStatus.loading) {
        _initStatus = LoadStatus.loading;
        _initErrorCode = null;
        notifyListeners();
      }

      final task = await _taskRepo.streamTask(taskId).first;

      // 2. 判斷 task 是否存在 (取代 docSnapshot.exists)
      if (task != null) {
        // 3. 資料轉換: TaskModel -> List<Map>
        List<Map<String, dynamic>> realMembers = task.members.entries.map((e) {
          // 確保是深拷貝或新 Map，以免汙染 Model
          final memberMap = Map<String, dynamic>.from(e.value);

          // 補上 ID (因為 Firestore Map 的 Key 就是 ID)
          memberMap['id'] = e.key;

          // 防呆預設值
          if (memberMap['displayName'] == null) {
            memberMap['displayName'] =
                t.S53_TaskSettings_Members.member_default_name;
          }
          return memberMap;
        }).toList();

        // 4. 排序邏輯 (完全保留原樣，這是 UI 邏輯)
        realMembers.sort((a, b) {
          final bool aIsCaptain = a['role'] == 'captain';
          final bool bIsCaptain = b['role'] == 'captain';
          if (aIsCaptain && !bIsCaptain) return -1;
          if (!aIsCaptain && bIsCaptain) return 1;
          final bool aLinked = a['isLinked'] ?? false;
          final bool bLinked = b['isLinked'] ?? false;
          if (aLinked && !bLinked) return -1;
          if (!aLinked && bLinked) return 1;
          return (a['id'] as String).compareTo(b['id'] as String);
        });

        _taskMembers = realMembers;

        // 5. 初始化分帳成員 (保留原樣)
        if (_originalRecord == null) {
          _baseMemberIds = _taskMembers.map((m) => m['id'] as String).toList();
        }
        _initStatus = LoadStatus.success;
      } else {
        _initStatus = LoadStatus.error;
        _initErrorCode = AppErrorCodes.dataNotFound;
      }
    } catch (e) {
      _initStatus = LoadStatus.error;
      _initErrorCode = e is FirebaseException
          ? ErrorMapper.parseErrorCode(e)
          : AppErrorCodes.initFailed;
    } finally {
      notifyListeners();
    }
  }

  void _onAmountChanged() {
    final currentAmount = totalAmount;
    if ((currentAmount - _lastKnownAmount).abs() > 0.001) {
      _lastKnownAmount = currentAmount;
      // Reset Logic
      if (_details.isNotEmpty || _baseSplitMethod != SplitMethodConstant.even) {
        _details.clear();
        _baseSplitMethod = SplitMethodConstant.defaultMethod;
        if (_taskMembers.isNotEmpty) {
          _baseMemberIds = _taskMembers.map((m) => m['id'] as String).toList();
        }
        _baseRawDetails.clear();
      }
      notifyListeners();
    } else {
      notifyListeners(); // Update UI validation
    }
  }

  // --- UI Action Updates ---

  void setRecordType(int index) {
    _recordTypeIndex = index;
    notifyListeners();
  }

  void updateDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void updateCategory(String id) {
    _selectedCategoryId = id;
    notifyListeners();
  }

  Future<void> updateCurrency(String code) async {
    _selectedCurrencyConstants = CurrencyConstants.getCurrencyConstants(code);
    await PreferencesService.saveLastCurrency(code);
    await fetchExchangeRate(); // 呼叫下方的公開方法
    notifyListeners();
  }

  Future<void> fetchExchangeRate() async {
    if (_selectedCurrencyConstants == baseCurrency) {
      exchangeRateController.text = '1.0';
      return;
    }
    try {
      _isRateLoading = true;
      notifyListeners();

      final rate = await CurrencyService.fetchRate(
          from: _selectedCurrencyConstants.code, to: baseCurrency.code);
      if (rate != null) {
        exchangeRateController.text = rate.toString();
      }
    } catch (e) {
      throw AppErrorCodes.rateFetchFailed;
    } finally {
      _isRateLoading = false; // 確保 Loading 結束
      notifyListeners();
    }
  }

  // Split & Payment Data Updates (Called after bottom sheets)

  void updateBaseSplit(Map<String, dynamic> result) {
    _baseSplitMethod = result['splitMethod'];
    _baseMemberIds = List<String>.from(result['memberIds']);
    _baseRawDetails = Map<String, double>.from(result['details']);
    notifyListeners();
  }

  void addItem(RecordDetail item) {
    _details.add(item);
    notifyListeners();
  }

  void updateItem(RecordDetail item) {
    final index = _details.indexWhere((e) => e.id == item.id);
    if (index != -1) {
      _details[index] = item;
      notifyListeners();
    }
  }

  void deleteItem(String itemId) {
    _details.removeWhere((e) => e.id == itemId);
    notifyListeners();
  }

  void updatePaymentMethod(Map<String, dynamic> result) {
    _complexPaymentData = result;
    final bool usePrepay = result['usePrepay'];
    final bool useAdvance = result['useAdvance'];
    final Map<String, double> advances = result['memberAdvance'];

    if (usePrepay && !useAdvance) {
      _payerType = 'prepay';
    } else if (!usePrepay && useAdvance) {
      _payerType = 'member';
      final payers = advances.entries.where((e) => e.value > 0).toList();
      if (payers.length == 1) {
        _payerId = payers.first.key;
      } else {
        _payerId = 'multiple';
      }
    } else {
      _payerType = 'mixed';
    }
    notifyListeners();
  }

  // --- Save & Delete ---

  // --- Save Logic ---

  Future<void> saveRecord(Translations t) async {
    if (_isSaving) return;
    _isSaving = true;
    notifyListeners();

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      final isIncome = _recordTypeIndex == 1;

      // 1. 準備必要的資料
      // 如果是編輯模式，保留原始建立時間；如果是新增，使用現在時間
      final now = DateTime.now();
      final createdAt = _originalRecord?.createdAt ?? now;

      final double exchangeRate =
          double.tryParse(exchangeRateController.text) ?? 1.0;
      final netRemainder = remainderDetail.net;

      // 2. 建構 RecordModel 物件 (完全對應您的 Model 定義)
      final newRecord = RecordModel(
        id: recordId, // 編輯時有值，新增時為 null

        // 基本資訊
        date: _selectedDate,
        title: isIncome
            ? t.S15_Record_Edit.type_income_title
            : titleController.text,
        type: isIncome ? 'income' : 'expense',

        // 分類
        categoryIndex:
            kAppCategories.indexWhere((c) => c.id == _selectedCategoryId),
        categoryId: _selectedCategoryId,

        // 付款資訊
        payerType: isIncome ? 'none' : _payerType,
        payerId: (!isIncome && _payerType == 'member') ? _payerId : null,
        paymentDetails: isIncome ? null : _complexPaymentData,

        // 金額與匯率 (根據您的 Model，這就是最終金額)
        amount: totalAmount,
        currencyCode: _selectedCurrencyConstants.code,
        exchangeRate: exchangeRate,
        remainder: netRemainder,

        // 分帳邏輯
        splitMethod: _baseSplitMethod,
        splitMemberIds: _baseMemberIds,
        splitDetails: _baseRawDetails, // Map<String, double> 符合型別

        // 細項
        details: isIncome ? [] : _details, // 直接傳 List<RecordDetail>

        // 其他
        memo: memoController.text,
        createdAt: createdAt,
        createdBy: uid ?? _originalRecord?.createdBy, // 編輯時保留原作者，新增時用当前 UID
      );

      // 3. 準備 Log 資料 (這是輔助顯示用的，邏輯不變)
      final logDetails = _buildLogDetails(t, isIncome);

      // 4. 呼叫 Repository
      if (recordId == null) {
        // 新增
        await _recordService.createRecord(
            taskId: taskId, draftRecord: newRecord);

        await ActivityLogService.log(
          taskId: taskId,
          action: LogAction.createRecord,
          details: logDetails,
        );
      } else {
        // 更新
        await _recordService.updateRecord(
            taskId: taskId, oldRecord: _originalRecord!, newRecord: newRecord);

        await ActivityLogService.log(
          taskId: taskId,
          action: LogAction.updateRecord,
          details: logDetails,
        );
      }
    } catch (e) {
      // 捕捉錯誤並轉拋 AppErrorCode (如果它還不是 Code)
      // 其他未知錯誤，包裝成 SAVE_FAILED
      throw e is FirebaseException
          ? ErrorMapper.parseErrorCode(e)
          : AppErrorCodes.saveFailed;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  /// 私有 Helper: 組裝 Activity Log 的詳細資料
  Map<String, dynamic> _buildLogDetails(Translations t, bool isIncome) {
    // A. 建構 Payment Log Info
    Map<String, dynamic> paymentLogData = {};

    if (isIncome) {
      paymentLogData = {'type': 'income', 'contributors': []};
    } else if (_payerType == 'prepay') {
      paymentLogData = {'type': 'pool', 'contributors': []};
    } else if (_payerType == 'member') {
      final name = _getMemberName(_payerId, t);
      paymentLogData = {
        'type': 'single',
        'contributors': [
          {'displayName': name, 'amount': totalAmount}
        ]
      };
    } else if (_payerType == 'multiple') {
      // 嘗試從 complexPaymentData 解析多位付款人
      List<Map<String, dynamic>> contributors = [];
      if (_complexPaymentData != null &&
          _complexPaymentData!['memberAdvance'] is Map) {
        final advances =
            _complexPaymentData!['memberAdvance'] as Map<String, dynamic>;
        contributors = advances.entries
            .where((e) => (e.value as num) > 0)
            .map((e) =>
                {'displayName': _getMemberName(e.key, t), 'amount': e.value})
            .toList();
      }
      paymentLogData = {'type': 'multiple', 'contributors': contributors};
    }

    // B. 建構 Allocation Log Info (簡化版)
    // 這裡通常需要根據 splitMethod 顯示 "均分"、"比例" 或 "詳細"
    // 因為這部分邏輯很長，這裡先保留基礎結構
    final allocationLogData = {
      'mode': _baseSplitMethod,
      // 若需要更詳細的 groups 資訊可在此擴充
      'groups': []
    };

    return {
      'recordName':
          isIncome ? t.S15_Record_Edit.type_income_title : titleController.text,
      'amount': totalAmount,
      'currency': _selectedCurrencyConstants.code,
      'recordType': isIncome ? 'income' : 'expense',
      'payment': paymentLogData,
      'allocation': allocationLogData,
    };
  }

  Future<bool> deleteRecord(Translations t) async {
    try {
      if (recordId == null) return false;

      final isIncome = _recordTypeIndex == 1; // 假設 Tab Index 1 = Income

      if (isIncome) {
        // A. 檢查資料庫是否有其他紀錄明確指向此 ID
        final isReferenced =
            await _recordRepo.isRecordReferenced(taskId, recordId!);
        if (isReferenced) return false;

        // B. 檢查餘額 (Pool Balance)
        // 如果刪除這筆收入，餘額是否會變成負數？
        // poolBalancesByCurrency 是 "包含" 此筆收入的當前餘額
        double currentBalance =
            poolBalancesByCurrency[_selectedCurrencyConstants.code] ?? 0.0;

        // 如果當前餘額小於此筆收入金額 (容許 0.01 誤差)，代表已經花掉了
        if (currentBalance < (totalAmount - 0.01)) {
          return false;
        }
      }

      await _recordService.deleteRecord(taskId, _originalRecord!);

      ActivityLogService.log(
          taskId: taskId,
          action: LogAction.deleteRecord,
          details: {
            'recordName': titleController.text,
            'amount': totalAmount,
            'currency': _selectedCurrencyConstants.code
          });
      return true;
    } catch (e) {
      throw e is FirebaseException
          ? ErrorMapper.parseErrorCode(e)
          : AppErrorCodes.saveFailed;
    }
  }

  bool hasUnsavedChanges() {
    // 1. 新增模式 (Create Mode)
    if (_originalRecord == null) {
      if (totalAmount > 0) return true;
      // 只有在支出模式下，才檢查標題是否有字
      if (_recordTypeIndex == 0) {
        return titleController.text.trim().isNotEmpty;
      }
      return false;
    }

    // 2. 編輯模式 (Edit Mode)
    final r = _originalRecord!;
    final currentType = _recordTypeIndex == 0 ? 'expense' : 'income';

    // 檢查類型變更
    if (currentType != r.type) return true;

    // 檢查金額變更
    if ((totalAmount - r.originalAmount).abs() > 0.001) return true;

    // 檢查標題變更 (✅ 修正重點)
    // 只有當「現在是支出」且「資料庫原本也是支出」時，才比對標題
    // 因為 Income 的 Controller 通常是空的，比對會出錯
    if (_recordTypeIndex == 0 && r.type == 'expense') {
      if (titleController.text != r.title) return true;
    }

    // 檢查日期變更
    if (!_isSameDay(_selectedDate, r.date)) return true;

    // (建議) 檢查分類是否變更 (防止改了分類卻沒警告)
    if (_recordTypeIndex == 0 && _selectedCategoryId != r.categoryId) {
      return true;
    }

    // (建議) 檢查付款人/成員是否變更 (防止改了付款人卻沒警告)
    // 簡單檢查 payerType 或 payerId
    if (_payerType != r.payerType) return true;
    if (_payerType == 'member' && _payerId != r.payerId) return true;

    return false;
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _getMemberName(String id, Translations t) {
    final m = _taskMembers.firstWhere((e) => e['id'] == id, orElse: () => {});
    return m['displayName'] ?? t.S53_TaskSettings_Members.member_default_name;
  }

  /// 取得「校正後」的公款餘額
  /// 用途：在編輯模式下，需把「原本這筆單據佔用的公款額度」加回來，
  /// 這樣 B07 彈窗和 UI 顯示的餘額才會是「如果我不付這筆錢，錢包裡會有多少錢」。
  Map<String, double> get adjustedPoolBalances {
    // 1. 複製目前的餘額表
    final Map<String, double> adjusted = Map.from(poolBalancesByCurrency);

    // 2. 如果是新增模式 (沒有原始紀錄)，直接回傳當前餘額
    if (_originalRecord == null) return adjusted;

    // 3. 如果是編輯模式，檢查原單據是否使用了公款
    final r = _originalRecord!;
    final code = r.originalCurrencyCode;
    double amountToAddBack = 0.0;

    if (r.payerType == 'prepay') {
      amountToAddBack = r.originalAmount;
    } else if (r.payerType == 'mixed' && r.paymentDetails != null) {
      amountToAddBack =
          (r.paymentDetails!['prepayAmount'] as num?)?.toDouble() ?? 0.0;
    }

    // 4. 加回餘額
    if (amountToAddBack > 0) {
      final current = adjusted[code] ?? 0.0;
      adjusted[code] = current + amountToAddBack;
    }

    return adjusted;
  }

  @override
  void dispose() {
    amountController.dispose();
    exchangeRateController.dispose();
    titleController.dispose();
    memoController.dispose();
    super.dispose();
  }
}
