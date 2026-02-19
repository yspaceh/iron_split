import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';

class B07PaymentMethodEditViewModel extends ChangeNotifier {
  final AuthRepository _authRepo;
  final double totalAmount;
  final Map<String, double> poolBalancesByCurrency;
  final List<TaskMember> members;
  final CurrencyConstants selectedCurrency;

  // --- 狀態管理 (Rule 5) ---
  LoadStatus _initStatus = LoadStatus.initial;
  AppErrorCodes? _initErrorCode;

  // --- 控制器管理 ---
  final TextEditingController prepayController = TextEditingController();
  final Map<String, TextEditingController> memberControllers = {};

  // --- 業務狀態 ---
  bool usePrepay = true;
  double prepayAmount = 0.0;
  bool useAdvance = false;
  Map<String, double> memberAdvance = {};

  // --- Getters (維持原有的計算公式) ---
  LoadStatus get initStatus => _initStatus;
  AppErrorCodes? get initErrorCode => _initErrorCode;

  double get currentAdvanceTotal =>
      memberAdvance.values.fold(0.0, (sum, val) => sum + val);

  double get currentTotalPay =>
      (usePrepay ? prepayAmount : 0.0) +
      (useAdvance ? currentAdvanceTotal : 0.0);

  double get remaining => totalAmount - currentTotalPay;

  bool get isValid => (remaining.abs() < 0.01);

  double get currentCurrencyPoolBalance {
    return poolBalancesByCurrency[selectedCurrency.code] ?? 0.0;
  }

  B07PaymentMethodEditViewModel({
    required AuthRepository authRepo,
    required this.totalAmount,
    required this.poolBalancesByCurrency,
    required this.members,
    required this.selectedCurrency,
  }) : _authRepo = authRepo;

  /// 初始化 (Rule 6: 登入確認)
  Future<void> init({
    required bool initialUsePrepay,
    required double initialPrepayAmount,
    required Map<String, double> initialMemberAdvance,
  }) async {
    if (_initStatus == LoadStatus.loading) return;
    _initStatus = LoadStatus.loading;
    notifyListeners();

    try {
      final user = _authRepo.currentUser;
      if (user == null) throw AppErrorCodes.unauthorized;

      // 1. 資料初步還原
      usePrepay = initialUsePrepay;
      memberAdvance = Map.from(initialMemberAdvance);

      // 確保所有成員 ID 都有在 Map 裡，避免後面讀取失敗
      for (var m in members) {
        final id = m.id;
        if (!memberAdvance.containsKey(id)) {
          memberAdvance[id] = 0.0;
        }
      }

      // 2. 判斷墊付開關
      double advanceTotal = currentAdvanceTotal;
      useAdvance = advanceTotal > 0 || !initialUsePrepay;

      // 3. 預收金額初始化邏輯 (既存公式)
      if (usePrepay && initialPrepayAmount == 0 && advanceTotal == 0) {
        prepayAmount = _calculateAutoPrepay(0);
      } else {
        prepayAmount = initialPrepayAmount;
      }

      // 公款為 0 的特殊處理
      if (currentCurrencyPoolBalance == 0) {
        usePrepay = false;
        prepayAmount = 0.0;
      }

      // 4. 初始化所有 Controllers
      prepayController.text = prepayAmount == 0
          ? ''
          : CurrencyConstants.formatAmount(prepayAmount, selectedCurrency.code);

      for (var m in members) {
        final id = m.id;
        final val = memberAdvance[id] ?? 0.0;
        memberControllers[id] = TextEditingController(
          text: val == 0
              ? ''
              : CurrencyConstants.formatAmount(val, selectedCurrency.code),
        );
      }

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

  // --- 邏輯運算 (維持原有既存公式) ---

  double _calculateAutoPrepay(double advanceTotal) {
    double needed = totalAmount - advanceTotal;
    if (needed < 0) needed = 0;
    return needed > currentCurrencyPoolBalance
        ? currentCurrencyPoolBalance
        : needed;
  }

  void onPrepayToggle() {
    usePrepay = !usePrepay;
    if (usePrepay) {
      prepayAmount = _calculateAutoPrepay(currentAdvanceTotal);
      prepayController.text = prepayAmount == 0
          ? ''
          : CurrencyConstants.formatAmount(prepayAmount, selectedCurrency.code);
    } else {
      prepayAmount = 0.0;
      prepayController.text = '';
      if (!useAdvance) {
        useAdvance = true;
      }
    }
    notifyListeners();
  }

  void onAdvanceToggle() {
    useAdvance = !useAdvance;
    if (!useAdvance) {
      for (var key in memberAdvance.keys) {
        memberAdvance[key] = 0.0;
        memberControllers[key]?.text = '';
      }
      if (!usePrepay) {
        usePrepay = true;
        prepayAmount = _calculateAutoPrepay(0);
        prepayController.text =
            CurrencyConstants.formatAmount(prepayAmount, selectedCurrency.code);
      }
    }
    notifyListeners();
  }

  void onPrepayAmountChanged(String val) {
    final v = double.tryParse(val.replaceAll(',', '')) ?? 0.0;
    if (prepayAmount != v) {
      prepayAmount = v;
      notifyListeners();
    }
  }

  void onMemberAdvanceChanged(String memberId, String val) {
    final v = double.tryParse(val.replaceAll(',', '')) ?? 0.0;
    memberAdvance[memberId] = v;

    if (usePrepay) {
      prepayAmount = _calculateAutoPrepay(currentAdvanceTotal);
      String newText = prepayAmount == 0
          ? ''
          : CurrencyConstants.formatAmount(prepayAmount, selectedCurrency.code);

      if (prepayController.text != newText) {
        prepayController.text = newText;
      }
    }
    notifyListeners();
  }

  Map<String, dynamic> prepareResult() {
    bool finalUsePrepay = usePrepay && prepayAmount > 0;
    bool finalUseAdvance = useAdvance && currentAdvanceTotal > 0;

    return {
      'usePrepay': finalUsePrepay,
      'prepayAmount': finalUsePrepay ? prepayAmount : 0.0,
      'useAdvance': finalUseAdvance,
      'memberAdvance': finalUseAdvance ? memberAdvance : <String, double>{},
    };
  }

  @override
  void dispose() {
    prepayController.dispose();
    for (var c in memberControllers.values) {
      c.dispose();
    }
    super.dispose();
  }
}
