import 'dart:async';
import 'package:flutter/material.dart';
import 'package:iron_split/core/models/task_model.dart'; // 引用現有 Model
import 'package:iron_split/features/task/data/task_repository.dart';

class S10TaskListViewModel extends ChangeNotifier {
  final TaskRepository _repo;
  final String currentUserId;

  // UI State
  List<TaskModel> _allTasks = [];
  int _filterIndex = 0; // 0: 進行中, 1: 已完成
  bool _isLoading = true;
  StreamSubscription? _subscription;

  // Getters
  bool get isLoading => _isLoading;
  int get filterIndex => _filterIndex;

  // Computed Property: 篩選並排序
  List<TaskModel> get displayTasks {
    // 1. Filter Logic (適配 TaskModel 的 String status)
    final filtered = _allTasks.where((task) {
      if (_filterIndex == 0) {
        // 進行中
        switch (task.status) {
          case 'ongoing':
          case 'pending':
            return true;
          case 'settled':
            if (task.settlement?['status'] == 'pending') {
              return true;
            } else {
              return false;
            }
          case 'close':
            return false;
          default:
            return false;
        }
      } else {
        // 已完成 (包含 closed, settled,等)
        switch (task.status) {
          case 'ongoing':
          case 'pending':
            return false;
          case 'settled':
            if (task.settlement?['status'] == 'cleared') {
              return true;
            } else {
              return false;
            }
          case 'close':
            return true;
          default:
            return false;
        }
      }
    }).toList();

    // 2. Sort Logic (Descending by updatedAt)
    filtered.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    return filtered;
  }

  S10TaskListViewModel({
    required TaskRepository repo,
    required this.currentUserId,
  }) : _repo = repo;

  void init() {
    _isLoading = true;
    notifyListeners();

    _subscription = _repo.streamUserTasks(currentUserId).listen((tasks) {
      _allTasks = tasks;
      _isLoading = false;
      notifyListeners();
    }, onError: (e) {
      debugPrint("Error fetching tasks: $e");
      _isLoading = false;
      notifyListeners();
    });
  }

  void setFilter(int index) {
    _filterIndex = index;
    notifyListeners();
  }

  // 判斷是否為建立者 (權限檢查)
  bool isCaptain(TaskModel task) {
    // 依據 TaskModel，欄位是 createdBy
    return task.createdBy == currentUserId;
  }

  Future<void> deleteTask(String taskId) async {
    await _repo.deleteTask(taskId);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
