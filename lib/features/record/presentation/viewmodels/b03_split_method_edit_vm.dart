import 'package:flutter/material.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/split_method_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/utils/balance_calculator.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/core/utils/split_ratio_helper.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';

class B03SplitMethodEditViewModel extends ChangeNotifier {
  final AuthRepository _authRepo;
  final double totalAmount;
  final CurrencyConstants selectedCurrency;
  final List<Map<String, dynamic>> allMembers;
  final Map<String, double> defaultMemberWeights;
  final double exchangeRate;
  final CurrencyConstants baseCurrency;

  // --- State (嚴格對照原始檔案寄存邏輯) ---
  LoadStatus _initStatus = LoadStatus.initial;
  AppErrorCodes? _initErrorCode;
  late String _splitMethod;
  late List<String> _selectedMemberIds;
  late Map<String, double> _details;

  final Map<String, TextEditingController> _amountControllers = {};

  // --- Getters ---
  LoadStatus get initStatus => _initStatus;
  AppErrorCodes? get initErrorCode => _initErrorCode;
  String get splitMethod => _splitMethod;
  List<String> get selectedMemberIds => _selectedMemberIds;
  Map<String, double> get details => _details;
  Map<String, TextEditingController> get amountControllers =>
      _amountControllers;

  B03SplitMethodEditViewModel({
    required AuthRepository authRepo,
    required this.totalAmount,
    required this.selectedCurrency,
    required this.allMembers,
    required this.defaultMemberWeights,
    required this.exchangeRate,
    required this.baseCurrency,
    required String initialSplitMethod,
    required List<String> initialMemberIds,
    required Map<String, double> initialDetails,
  }) : _authRepo = authRepo {
    _splitMethod = initialSplitMethod;
    _selectedMemberIds = List.from(initialMemberIds);
    _details = Map.from(initialDetails);
  }

  // 對照原始 initState 邏輯
  void init() {
    _initStatus = LoadStatus.loading;
    notifyListeners();

    try {
      final user = _authRepo.currentUser;
      if (user == null) throw AppErrorCodes.unauthorized;
      for (var m in allMembers) {
        final id = m['id'];
        final val = _details[id] ?? 0.0;
        _amountControllers[id] = TextEditingController(
          text: val > 0
              ? CurrencyConstants.formatAmount(val, selectedCurrency.code)
              : '',
        );
      }

      // 防呆：如果進來時沒選人，且是 Even 模式，預設全選
      if (_selectedMemberIds.isEmpty &&
          _splitMethod == SplitMethodConstant.even) {
        _selectedMemberIds = allMembers.map((m) => m['id'] as String).toList();
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

  // 對照原始 _getSplitResult 邏輯
  SplitResult getSplitResult() {
    return BalanceCalculator.calculateSplit(
      totalAmount: totalAmount,
      exchangeRate: exchangeRate,
      splitMethod: _splitMethod,
      memberIds: _selectedMemberIds,
      details: _details,
      baseCurrency: baseCurrency,
    );
  }

  // 對照原始 _switchMethod 邏輯 (使用 percent 與 exact)
  void switchMethod(String newMethod) {
    if (_splitMethod == newMethod) return;
    _splitMethod = newMethod;

    if (newMethod == SplitMethodConstant.percent) {
      _details.clear();
      for (var id in _selectedMemberIds) {
        _details[id] = defaultMemberWeights[id] ?? 1.0;
      }
    } else if (newMethod == SplitMethodConstant.exact) {
      _details.clear();
      for (var c in _amountControllers.values) {
        c.clear();
      }
    }
    notifyListeners();
  }

  // 對照原始各 Section 的 onTap 邏輯
  void toggleMember(String id) {
    final isSelected = _selectedMemberIds.contains(id);

    if (_splitMethod == SplitMethodConstant.exact) {
      if (!isSelected) {
        _selectedMemberIds.add(id);
        final currentSum = _details.values.fold(0.0, (sum, v) => sum + v);
        final remaining = totalAmount - currentSum;
        if (remaining > 0) {
          _details[id] = remaining;
          _amountControllers[id]?.text =
              CurrencyConstants.formatAmount(remaining, selectedCurrency.code);
        }
      } else {
        _selectedMemberIds.remove(id);
        _details.remove(id);
        _amountControllers[id]?.clear();
      }
    } else if (_splitMethod == SplitMethodConstant.percent) {
      final weight = _details[id] ?? 0.0;
      final isActuallySelected = weight > 0;
      if (!isActuallySelected) {
        _details[id] = defaultMemberWeights[id] ?? 1.0;
        if (!_selectedMemberIds.contains(id)) {
          _selectedMemberIds.add(id);
        }
      } else {
        _details[id] = 0.0;
        _selectedMemberIds.remove(id);
      }
    } else {
      // Even
      if (isSelected) {
        _selectedMemberIds.remove(id);
      } else {
        _selectedMemberIds.add(id);
      }
    }
    notifyListeners();
  }

  // 對照原始 Exact 模式 onChanged 邏輯
  void updateAmount(String id, String val) {
    final amount = double.tryParse(val) ?? 0.0;
    if (amount > 0) {
      _details[id] = amount;
      if (!_selectedMemberIds.contains(id)) {
        _selectedMemberIds.add(id);
      }
    } else {
      _details.remove(id);
    }
    notifyListeners();
  }

  // 對照原始 Percent 模式 AppStepper 邏輯 (使用 increase/decrease)
  void updatePercent(String id, bool isIncrease) {
    final weight = _details[id] ?? 0.0;
    double newW;
    if (isIncrease) {
      newW = SplitRatioHelper.increase(weight);
      if (newW > 0 && !_selectedMemberIds.contains(id)) {
        _selectedMemberIds.add(id);
      }
    } else {
      newW = SplitRatioHelper.decrease(weight);
      if (newW == 0.0) {
        _selectedMemberIds.remove(id);
      }
    }
    _details[id] = newW;
    notifyListeners();
  }

  // 對照原始 _isValid 邏輯
  bool get isValid {
    if (_selectedMemberIds.isEmpty) return false;

    if (_splitMethod == SplitMethodConstant.exact) {
      final sum = _details.values.fold(0.0, (prev, curr) => prev + curr);
      return (sum - totalAmount).abs() < 0.1;
    }
    return true;
  }

  Map<String, dynamic> save() {
    return {
      'splitMethod': _splitMethod,
      'memberIds': _selectedMemberIds,
      'details': _details,
    };
  }

  @override
  void dispose() {
    for (var c in _amountControllers.values) {
      c.dispose();
    }
    super.dispose();
  }
}
