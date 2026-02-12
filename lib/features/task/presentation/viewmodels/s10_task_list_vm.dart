import 'dart:async';
import 'package:flutter/material.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/models/task_model.dart'; // 引用現有 Model
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/task/application/task_service.dart';
import 'package:iron_split/features/task/data/task_repository.dart';

class S10TaskListViewModel extends ChangeNotifier {
  final TaskRepository _taskRepo;
  final AuthRepository _authRepo;
  final TaskService _service;

  LoadStatus _initStatus = LoadStatus.initial;
  AppErrorCodes? _initErrorCode;

  // UI State
  List<TaskModel> _allTasks = [];
  List<TaskModel> _displayTasks = [];
  int _filterIndex = 0; // 0: 進行中, 1: 已完成

  String _currentUserId = '';
  StreamSubscription? _subscription;

  // Getters
  LoadStatus get initStatus => _initStatus;
  AppErrorCodes? get initErrorCode => _initErrorCode;
  List<TaskModel> get displayTasks => _displayTasks;
  int get filterIndex => _filterIndex;
  String get currentUserId => _currentUserId;

  S10TaskListViewModel({
    required TaskRepository taskRepo,
    required AuthRepository authRepo,
    required TaskService service,
  })  : _taskRepo = taskRepo,
        _authRepo = authRepo,
        _service = service;

  void init() {
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
      _subscription = _taskRepo.streamUserTasks(currentUserId).listen((tasks) {
        _allTasks = tasks;
        _recalculate();
        _initStatus = LoadStatus.success;
        notifyListeners();
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

  void setFilter(int index) {
    if (_filterIndex == index) return;
    _filterIndex = index;
    _recalculate();
    notifyListeners();
  }

  void _recalculate() {
    _displayTasks = _service.filterAndSortTasks(_allTasks, _filterIndex);
  }

  // 判斷是否為建立者 (權限檢查)
  bool isCaptain(TaskModel task) {
    // 依據 TaskModel，欄位是 createdBy
    return task.createdBy == currentUserId;
  }

  ({String routeName, Map<String, String> params})? getNavigationInfo(
      TaskModel task) {
    switch (task.status) {
      case 'ongoing':
      case 'pending':
        return (routeName: 'S13', params: {'taskId': task.id});
      case 'settled':
      case 'close':
        return (routeName: 'S17', params: {'taskId': task.id});
      default:
        return null;
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
