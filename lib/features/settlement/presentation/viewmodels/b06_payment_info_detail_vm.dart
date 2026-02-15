import 'package:flutter/material.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/models/payment_info_model.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';

class B06PaymentInfoDetailViewModel extends ChangeNotifier {
  final AuthRepository _authRepo;
  final TaskModel task;
  final bool isCaptain;

  // --- 狀態 ---
  LoadStatus _initStatus = LoadStatus.initial;
  AppErrorCodes? _initErrorCode;
  PaymentInfoModel? _info;

  // --- Getters ---
  LoadStatus get initStatus => _initStatus;
  AppErrorCodes? get initErrorCode => _initErrorCode;
  PaymentInfoModel? get info => _info;

  // 邏輯 1: 判斷是否為隱私模式
  bool get isPrivate => _info == null || _info!.mode == PaymentMode.private;

  B06PaymentInfoDetailViewModel({
    required AuthRepository authRepo,
    required this.task,
    required this.isCaptain,
  }) : _authRepo = authRepo;

  // 邏輯 6: 初始化與登入檢查
  Future<void> init() async {
    if (_initStatus == LoadStatus.loading) return;
    _initStatus = LoadStatus.loading;
    _initErrorCode = null;
    notifyListeners();

    try {
      final user = _authRepo.currentUser;
      if (user == null) throw AppErrorCodes.unauthorized;

      // 邏輯 1: 資料解析移至 VM
      if (task.settlement != null &&
          task.settlement!['receiverInfos'] != null) {
        try {
          _info = PaymentInfoModel.fromJson(task.settlement!['receiverInfos']);
        } catch (_) {
          // 解析失敗視為無資料，不拋出錯誤，維持 isPrivate = true
        }
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
}
