import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/models/settlement_model.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';

class B04PaymentMergeViewModel extends ChangeNotifier {
  final AuthRepository _authRepo;

  // 外部傳入的資料 (Data)
  final SettlementMember headMember;
  final List<SettlementMember> candidateMembers;
  final CurrencyConstants baseCurrency;

  // 狀態 (State)
  LoadStatus _initStatus = LoadStatus.initial;
  AppErrorCodes? _initErrorCode;
  final Set<String> _selectedIds = {};

  // Getters
  LoadStatus get initStatus => _initStatus;
  AppErrorCodes? get initErrorCode => _initErrorCode;

  bool isSelected(String id) => _selectedIds.contains(id);

  // 邏輯 1: 計算總金額 (移至 VM)
  double get totalAmount {
    final selectedCandidatesSum = candidateMembers
        .where((m) => _selectedIds.contains(m.id))
        .fold(0.0, (sum, m) => sum + m.finalAmount);
    return headMember.finalAmount + selectedCandidatesSum;
  }

  B04PaymentMergeViewModel({
    required AuthRepository authRepo,
    required this.headMember,
    required this.candidateMembers,
    required this.baseCurrency,
    required List<String> initialMergedIds,
  }) : _authRepo = authRepo {
    // 初始化選取狀態
    _selectedIds.addAll(initialMergedIds);
  }

  // 邏輯 6: 登入檢查與初始化
  void init() {
    if (_initStatus == LoadStatus.loading) return;
    _initStatus = LoadStatus.loading;
    _initErrorCode = null;
    notifyListeners();

    try {
      final user = _authRepo.currentUser;
      if (user == null) throw AppErrorCodes.unauthorized;

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

  // 邏輯 1: 切換選取狀態
  void toggleSelection(String id) {
    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id);
    } else {
      _selectedIds.add(id);
    }
    notifyListeners();
  }

  // 返回結果
  List<String> getResult() => _selectedIds.toList();
}
