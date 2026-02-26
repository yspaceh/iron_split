import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/task_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/record/data/record_repository.dart';
import 'package:iron_split/features/task/application/member_service.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:iron_split/features/task/data/models/activity_log_model.dart';
import 'package:iron_split/features/task/data/services/activity_log_service.dart';
import 'package:iron_split/gen/strings.g.dart'; // For default name

class S53TaskSettingsMembersViewModel extends ChangeNotifier {
  final TaskRepository _taskRepo;
  final RecordRepository _recordRepo;
  final AuthRepository _authRepo;

  final String taskId;

  LoadStatus _addMemberStatus = LoadStatus.initial;
  LoadStatus _deleteMemberStatus = LoadStatus.initial;
  LoadStatus _updateStatus = LoadStatus.initial;
  LoadStatus _initStatus = LoadStatus.initial;
  AppErrorCodes? _initErrorCode;
  String _currentUserId = '';
  TaskModel? _task;
  String _createdBy = '';
  Map<String, TaskMember> _membersMap = {};
  List<MapEntry<String, TaskMember>> _membersList = [];
  // Getters

  LoadStatus get addMemberStatus => _addMemberStatus;
  LoadStatus get deleteMemberStatus => _deleteMemberStatus;
  LoadStatus get updateStatus => _updateStatus;
  String get currentUserId => _currentUserId;
  TaskModel? get task => _task;
  String get createdBy => _createdBy;
  Map<String, TaskMember> get membersMap => _membersMap;
  List<MapEntry<String, TaskMember>> get membersList => _membersList;
  LoadStatus get initStatus => _initStatus;
  AppErrorCodes? get initErrorCode => _initErrorCode;

  StreamSubscription? _taskSubscription;

  S53TaskSettingsMembersViewModel(
      {required TaskRepository taskRepo,
      required RecordRepository recordRepo,
      required AuthRepository authRepo,
      required this.taskId})
      : _taskRepo = taskRepo,
        _recordRepo = recordRepo,
        _authRepo = authRepo;

  void init() {
    if (_initStatus == LoadStatus.loading) return;
    _initStatus = LoadStatus.loading;
    _initErrorCode = null;
    notifyListeners();

    try {
      final user = _authRepo.currentUser;
      if (user == null) throw AppErrorCodes.unauthorized;
      _currentUserId = user.uid;

      _taskSubscription = _taskRepo.streamTask(taskId).listen(
        (taskData) {
          if (taskData != null) {
            _task = taskData;
            _createdBy = _task?.createdBy ?? '';
            _membersMap = _task?.members ?? {};
            _membersList = _task?.sortedMembers ?? [];
            _initStatus = LoadStatus.success;
            notifyListeners();
          }
        },
        onError: (e) {
          _initStatus = LoadStatus.error;
          _initErrorCode =
              e is AppErrorCodes ? e : ErrorMapper.parseErrorCode(e);
          notifyListeners();
        },
      );
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

// 徹底重寫 addMember 方法，移除 temp_id, status, createdAt 等垃圾
  Future<void> addMember() async {
    if (_addMemberStatus == LoadStatus.loading) return;
    _addMemberStatus = LoadStatus.loading;
    notifyListeners();

    try {
      if (_task == null) throw AppErrorCodes.dataNotFound;
      if (_membersMap.length >= TaskConstants.maxMembers) {
        throw AppErrorCodes.maxMembersReached; // 拋出專屬的錯誤碼
      }
      final nextNumber = (_task?.memberCount ?? 0) + 1;
      final virtualId = MemberService.generateVirtualId();
      final displayName = "${t.common.member_prefix} $nextNumber";
      final newMember = MemberService.createGhost(displayName: displayName);

      await _taskRepo.addMemberToTask(taskId, virtualId, newMember);

      await ActivityLogService.log(
        taskId: taskId,
        action: LogAction.addMember,
        details: {'memberName': displayName},
      );
      _addMemberStatus = LoadStatus.success;
      notifyListeners();
    } on AppErrorCodes {
      _addMemberStatus = LoadStatus.error;
      notifyListeners();
      rethrow;
    } catch (e) {
      _addMemberStatus = LoadStatus.error;
      notifyListeners();
      throw ErrorMapper.parseErrorCode(e);
    }
  }

  Future<void> renameMember(String memberId, String newName) async {
    final trimmedName = newName.trim();
    if (trimmedName.isEmpty) return;

    final oldData = _membersMap[memberId];
    if (oldData == null) return;
    if (oldData.displayName == trimmedName) return;

    try {
      await _taskRepo
          .updateMemberFields(taskId, memberId, {'displayName': trimmedName});
    } on AppErrorCodes {
      rethrow;
    } catch (e) {
      throw ErrorMapper.parseErrorCode(e);
    }
  }

  Future<void> updateRatio(String memberId, double newRatio) async {
    if (_updateStatus == LoadStatus.loading) return;
    _updateStatus = LoadStatus.loading;
    notifyListeners();
    try {
      await _taskRepo.updateMemberFields(
          taskId, memberId, {'defaultSplitRatio': newRatio});
      _updateStatus = LoadStatus.success;
      notifyListeners();
    } on AppErrorCodes {
      // Deleted
      _updateStatus = LoadStatus.error;
      notifyListeners();
      rethrow;
    } catch (e) {
      _updateStatus = LoadStatus.error;
      notifyListeners();
      throw ErrorMapper.parseErrorCode(e);
    }
  }

  /// 嘗試刪除成員
  /// Returns: true if deleted, false if blocked (has data)
  Future<void> deleteMember(String memberId) async {
    if (_deleteMemberStatus == LoadStatus.loading) return;
    _deleteMemberStatus = LoadStatus.loading;
    notifyListeners();

    try {
      if (_membersMap.isEmpty) throw AppErrorCodes.dataNotFound;
      final memberToDelete = _membersMap[memberId];
      if (memberToDelete == null) throw AppErrorCodes.dataNotFound;
      // 1. 髒檢查
      final hasData = await _recordRepo.hasMemberRecords(taskId, memberId);

      if (hasData) throw AppErrorCodes.dataIsUsed;

      // 2. 執行刪除
      final updatedMap =
          _membersMap.map((key, value) => MapEntry(key, value.toMap()));
      updatedMap.remove(memberId);

      await _taskRepo.replaceMembersMap(taskId, updatedMap);

      await ActivityLogService.log(
        taskId: taskId,
        action: LogAction.removeMember,
        details: {'memberName': memberToDelete.displayName},
      );
      _deleteMemberStatus = LoadStatus.success;
      notifyListeners();
    } on AppErrorCodes {
      // Deleted
      _deleteMemberStatus = LoadStatus.error;
      notifyListeners();
      rethrow;
    } catch (e) {
      _deleteMemberStatus = LoadStatus.error;
      notifyListeners();
      throw ErrorMapper.parseErrorCode(e);
    }
  }

  @override
  void dispose() {
    _taskSubscription?.cancel();
    super.dispose();
  }
}
