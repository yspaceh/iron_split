import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/category_constants.dart';
import 'package:iron_split/core/constants/split_method_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/models/record_model.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/core/services/currency_service.dart';
import 'package:iron_split/core/services/preferences_service.dart';
import 'package:iron_split/core/utils/balance_calculator.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
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
  final AuthRepository _authRepo;
  final PreferencesService _prefsService;
  late final RecordService _recordService;

  // Basic State
  late DateTime _selectedDate;
  late CurrencyConstants _selectedCurrencyConstants;
  String _selectedCategoryId = CategoryConstant.defaultCategory;
  int _recordTypeIndex = 0; // 0: expense, 1: income

  // Loading State
  LoadStatus _rateLoadStatus = LoadStatus.initial;
  LoadStatus _saveStatus = LoadStatus.initial;
  LoadStatus _deleteStatus = LoadStatus.initial;

  LoadStatus _initStatus = LoadStatus.initial;
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

  LoadStatus get rateLoadStatus => _rateLoadStatus;
  LoadStatus get saveStatus => _saveStatus;
  LoadStatus get deleteStatus => _deleteStatus;
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
    // 1. 基本 UI 條件檢查
    if (_payerType != 'prepay') return false;
    if (totalAmount <= 0) return false;

    // 2. 呼叫 Service 執行業務檢查
    // VM 只需要提供數據，不需要知道「怎麼算」
    return !BalanceCalculator.isPoolBalanceSufficient(
      amountToCheck: totalAmount,
      currency: _selectedCurrencyConstants.code,
      currentPoolBalances: poolBalancesByCurrency,
      originalRecord: _originalRecord,
    );
  }

  // 解決 saveRecord 和 remainderDetail 代碼重複的問題
  RecordModel _buildDraftRecord() {
    final double exchangeRate =
        double.tryParse(exchangeRateController.text) ?? 1.0;
    final isIncome = _recordTypeIndex == 1;

    return RecordModel(
      id: recordId, // 新增時為 null
      date: _selectedDate,
      title: isIncome ? '' : titleController.text, // 標題由外部決定或這裡暫空
      type: isIncome ? 'income' : 'expense',
      categoryIndex: 0, // 簡化，以 ID 為準
      categoryId: _selectedCategoryId,

      // 付款資訊
      payerType: isIncome ? 'none' : _payerType,
      payerId: (!isIncome && _payerType == 'member') ? _payerId : null,
      paymentDetails: isIncome ? null : _complexPaymentData,

      // 金額
      amount: totalAmount,
      currencyCode: _selectedCurrencyConstants.code,
      exchangeRate: exchangeRate,
      remainder: 0, // 暫時填 0，由 Service 計算

      // 分帳
      splitMethod: _baseSplitMethod,
      splitMemberIds: _baseMemberIds,
      splitDetails: _baseRawDetails,
      details: isIncome ? [] : _details,

      memo: memoController.text,
      createdAt: _originalRecord?.createdAt ?? DateTime.now(),
      createdBy: '', // 由 Service 或 Repo 補
    );
  }

  /// 提供給 UI 顯示的詳細零頭結構 (Consumer, Payer, Net)
  /// 完全委派給 BalanceCalculator 計算，確保邏輯單一
  RemainderDetail get remainderDetail {
    final tempRecord = _buildDraftRecord();
    return BalanceCalculator.calculateDetailedRemainder(tempRecord);
  }

  // Constructor
  S15RecordEditViewModel({
    required this.taskId,
    required RecordRepository recordRepo,
    required TaskRepository taskRepo,
    required AuthRepository authRepo,
    required PreferencesService prefsService,
    this.recordId,
    RecordModel? record,
    this.baseCurrency = CurrencyConstants.defaultCurrencyConstants,
    this.poolBalancesByCurrency = const {},
    DateTime? initialDate,
  })  : _recordRepo = recordRepo,
        _taskRepo = taskRepo,
        _authRepo = authRepo,
        _prefsService = prefsService,
        _originalRecord = record {
    _recordService = RecordService(_recordRepo, _taskRepo);
    _setupForm(initialDate);
  }

  void _setupForm(DateTime? initialDate) {
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

    amountController.addListener(_onAmountChanged);
  }

  // Logic Methods

  void _loadCurrencyPreference() {
    final lastCurrency = _prefsService.getLastCurrency();
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

  Future<void> init() async {
    if (_initStatus == LoadStatus.loading) return;
    _initStatus = LoadStatus.loading;
    _initErrorCode = null;
    notifyListeners();
    try {
      // (1) 登入檢查
      final user = _authRepo.currentUser;
      if (user == null) throw AppErrorCodes.unauthorized;

      // (2) 載入幣別偏好 (原本在 _init 的 Future.delayed 裡)
      if (_originalRecord == null) {
        _loadCurrencyPreference();
      }

      // (3) 撈取任務資料 (原 fetchTaskData 邏輯)
      final task = await _taskRepo.streamTask(taskId).first;

      // 2. 判斷 task 是否存在 (取代 docSnapshot.exists)
      if (task == null) throw AppErrorCodes.dataNotFound;

      final sortedEntries = task.sortedMembers;
      // 3. 資料轉換: TaskModel -> List<Map>
      _taskMembers = sortedEntries.map((entry) {
        final memberData = Map<String, dynamic>.from(entry.value);
        memberData['id'] = entry.key; // 補上 ID

        // 確保 displayName 有值
        if (memberData['displayName'] == null ||
            memberData['displayName'].isEmpty) {
          // 這裡無法直接取得 translations，通常用預設字串或在 UI 層處理
          // 但為了相容舊邏輯，我們可以暫時給一個 key 或空值
          memberData['displayName'] = 'Unknown Member';
        }
        return memberData;
      }).toList();

      // 5. 初始化分帳成員 (保留原樣)
      if (_originalRecord == null) {
        _baseMemberIds = _taskMembers.map((m) => m['id'] as String).toList();
      }
      _initStatus = LoadStatus.success;
      notifyListeners();
    } on AppErrorCodes catch (code) {
      _initStatus = LoadStatus.error;
      _initErrorCode = code;
      notifyListeners();
    } catch (e) {
      _initStatus = LoadStatus.error;
      _initErrorCode = e is FirebaseException
          ? ErrorMapper.parseErrorCode(e)
          : AppErrorCodes.initFailed;
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
    await _prefsService.saveLastCurrency(code);
    await fetchExchangeRate(); // 呼叫下方的公開方法
    notifyListeners();
  }

  Future<void> fetchExchangeRate() async {
    if (_selectedCurrencyConstants == baseCurrency) {
      exchangeRateController.text = '1.0';
      return;
    }
    try {
      if (_rateLoadStatus == LoadStatus.loading) return;
      _rateLoadStatus = LoadStatus.loading;
      notifyListeners();

      final rate = await CurrencyService.fetchRate(
          from: _selectedCurrencyConstants.code, to: baseCurrency.code);
      exchangeRateController.text = rate.toString();
      _rateLoadStatus = LoadStatus.success;
      notifyListeners();
    } on AppErrorCodes {
      _rateLoadStatus = LoadStatus.error;
      notifyListeners();
      rethrow;
    } catch (e) {
      _rateLoadStatus = LoadStatus.error;
      notifyListeners();
      throw AppErrorCodes.rateFetchFailed;
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
    if (_saveStatus == LoadStatus.loading) return;
    _saveStatus = LoadStatus.loading;
    notifyListeners();

    try {
      final user = _authRepo.currentUser;
      if (user == null) throw AppErrorCodes.unauthorized;

      final isIncome = _recordTypeIndex == 1;

      var draftRecord = _buildDraftRecord();

      draftRecord = draftRecord.copyWith(
        title: _recordTypeIndex == 1
            ? t.S15_Record_Edit.type_income_title
            : titleController.text,
        createdBy: _originalRecord?.createdBy ?? user.uid,
      );

      // 3. 準備 Log 資料 (這是輔助顯示用的，邏輯不變)
      final logDetails = _buildLogDetails(t, isIncome);

      // 4. 呼叫 Repository
      if (recordId == null) {
        // 新增
        await _recordService.createRecord(
            taskId: taskId, draftRecord: draftRecord);

        await ActivityLogService.log(
          taskId: taskId,
          action: LogAction.createRecord,
          details: logDetails,
        );
      } else {
        // 更新
        await _recordService.updateRecord(
            taskId: taskId,
            oldRecord: _originalRecord!,
            newRecord: draftRecord);

        await ActivityLogService.log(
          taskId: taskId,
          action: LogAction.updateRecord,
          details: logDetails,
        );
      }
      _saveStatus = LoadStatus.success;
      notifyListeners();
    } on AppErrorCodes {
      _saveStatus = LoadStatus.error;
      notifyListeners();
      rethrow;
    } on FirebaseException catch (e) {
      _saveStatus = LoadStatus.error;
      notifyListeners();
      throw ErrorMapper.parseErrorCode(e);
    } catch (e) {
      _saveStatus = LoadStatus.error;
      notifyListeners();
      throw AppErrorCodes.saveFailed;
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

  /// 刪除紀錄
  Future<void> deleteRecord(Translations t) async {
    // 1. 防止重複點擊
    if (_deleteStatus == LoadStatus.loading) return;

    _deleteStatus = LoadStatus.loading;
    notifyListeners();

    try {
      // 2. 防呆檢查：只有編輯模式 (_originalRecord 存在) 才能刪除
      if (_originalRecord == null) throw AppErrorCodes.dataNotFound;

      // ✅ [修正] 核心邏輯：委派給 Service，與 S13 保持 100% 一致
      // Service 內部會自動處理：
      //   a. 檢查是否為收入 (Income)
      //   b. 檢查是否被其他紀錄引用 (checkRecordReferenced)
      //   c. 檢查公款餘額是否足夠 (incomeIsUsed)
      //   d. 執行刪除與餘額撤銷 (undo)
      await _recordService.validateAndDelete(
        taskId,
        _originalRecord!,
        poolBalancesByCurrency, // 使用進入 S15 時傳入的最新餘額
      );

      // 3. 寫入 Activity Log (保持與 S13 一致的 Log 格式)
      await ActivityLogService.log(
        taskId: taskId,
        action: LogAction.deleteRecord,
        details: {
          'recordName': _originalRecord!.title,
          'amount': _originalRecord!.amount,
          'currency': _originalRecord!.currencyCode,
        },
      );

      _deleteStatus = LoadStatus.success;
    } on AppErrorCodes {
      _deleteStatus = LoadStatus.error;
      rethrow; // 讓 UI 層 (Page) 接手顯示錯誤訊息
    } catch (e) {
      _deleteStatus = LoadStatus.error;
      throw ErrorMapper.parseErrorCode(e);
    } finally {
      notifyListeners();
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
