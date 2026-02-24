import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/split_method_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/models/record_model.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';

class B02SplitExpenseEditViewModel extends ChangeNotifier {
  final AuthRepository _authRepo;
  final RecordDetail? initialDetail;
  final List<TaskMember> allMembers;
  final CurrencyConstants selectedCurrency;

  // --- 1. 狀態管理 (Rule 5: 使用 LoadStatus) ---
  LoadStatus _initStatus = LoadStatus.initial;
  AppErrorCodes? _initErrorCode;

  // --- 2. UI 控制器 (Rule 1: 將控制器由 VM 管理，方便存取數值) ---
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController memoController = TextEditingController();

  // --- 3. 業務資料狀態 ---
  late String splitMethod;
  late List<String> splitMemberIds;
  Map<String, double>? splitDetails;

  // --- Getters ---
  LoadStatus get initStatus => _initStatus;
  AppErrorCodes? get initErrorCode => _initErrorCode;

  B02SplitExpenseEditViewModel({
    required AuthRepository authRepo,
    required this.allMembers,
    required this.selectedCurrency,
    this.initialDetail,
  }) : _authRepo = authRepo;

  /// 4. 初始化方法 (Rule 6: 包含登入檢查)
  Future<void> init() async {
    if (_initStatus == LoadStatus.loading) return;

    _initStatus = LoadStatus.loading;
    _initErrorCode = null;
    notifyListeners();

    try {
      // 權限檢查：確保使用者已登入
      final user = _authRepo.currentUser;
      if (user == null) throw AppErrorCodes.unauthorized;

      // 數據填入：根據 initialDetail 或是預設值初始化
      nameController.text = initialDetail?.name ?? '';

      // 處理金額格式化 (根據當前幣別)
      if (initialDetail?.amount != null && initialDetail!.amount > 0) {
        amountController.text = CurrencyConstants.formatAmount(
          initialDetail!.amount,
          selectedCurrency.code,
        );
      } else {
        amountController.text = '';
      }

      memoController.text = initialDetail?.memo ?? '';

      // 分帳設定初始化
      splitMethod =
          initialDetail?.splitMethod ?? SplitMethodConstant.defaultMethod;

      // 預設選中所有人，或是從 detail 讀取
      splitMemberIds =
          initialDetail?.splitMemberIds ?? allMembers.map((m) => m.id).toList();

      splitDetails = initialDetail?.splitDetails;

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
  }

  /// 5. 處理分帳細節更新 (Rule 1: 當從 B03 返回時由 VM 更新資料)
  void updateSplitConfig(Map<String, dynamic> result) {
    final rawMemberIds = result['memberIds'];
    final safeMemberIds = rawMemberIds is List
        ? rawMemberIds.whereType<String>().toList()
        : <String>[];

    // 2. 安全解析 details (Map<String, double>)
    final rawDetails = result['details'];
    final safeDetails = rawDetails is Map
        ? rawDetails.map((key, value) => MapEntry(
              key.toString(), // 確保 key 一定是 String
              (value is num)
                  ? value.toDouble()
                  : 0.0, // 容錯：把 int 轉成 double，如果是怪異型別就給 0.0
            ))
        : <String, double>{};
    splitMethod = result['splitMethod'] ?? SplitMethodConstant.defaultMethod;
    splitMemberIds = safeMemberIds;
    splitDetails = safeDetails;
    notifyListeners();
  }

  /// 6. 封裝並導出結果 (Rule 1: 負責檢查邏輯並組裝 RecordDetail)
  RecordDetail? prepareResult() {
    // 清除千分位，轉為 double
    final amountText = amountController.text.replaceAll(',', '');
    final amount = double.tryParse(amountText) ?? 0.0;

    // 🔴 業務逻辑保護：如果使用者手動更改了總金額，
    // 而原本的 splitDetails 是指定金額(如精確模式)，總和會對不起來。
    // 這時我們需要將分帳模式重設為預設，避免資料衝突。
    Map<String, double>? finalDetails = splitDetails;
    String finalMethod = splitMethod;

    if (finalDetails != null && finalDetails.isNotEmpty) {
      final sum = finalDetails.values.fold(0.0, (p, c) => p + c);
      // 允許極小的浮點數誤差 (0.1)
      if ((sum - amount).abs() > 0.1) {
        finalDetails = null; // 清除明細
        finalMethod = SplitMethodConstant.defaultMethod; // 回歸均分
      }
    }

    return RecordDetail(
      id: initialDetail?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: nameController.text.trim(),
      amount: amount,
      memo: memoController.text.trim(),
      splitMethod: finalMethod,
      splitMemberIds: splitMemberIds,
      splitDetails: finalDetails,
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    memoController.dispose();
    super.dispose();
  }
}
