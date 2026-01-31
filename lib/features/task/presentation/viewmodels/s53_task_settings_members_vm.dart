import 'package:flutter/material.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/features/record/data/record_repository.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:iron_split/features/task/presentation/helpers/task_share_helper.dart';
import 'package:iron_split/features/task/data/models/activity_log_model.dart';
import 'package:iron_split/features/task/data/services/activity_log_service.dart';
import 'package:iron_split/gen/strings.g.dart'; // For default name

class S53TaskSettingsMembersViewModel extends ChangeNotifier {
  final TaskRepository _taskRepo;
  final RecordRepository _recordRepo;
  final String taskId;
  bool _isProcessing = false;

  bool get isProcessing => _isProcessing;

  S53TaskSettingsMembersViewModel(
      {required TaskRepository taskRepo,
      required RecordRepository recordRepo,
      required this.taskId})
      : _taskRepo = taskRepo,
        _recordRepo = recordRepo;

  // 直接暴露 Firestore Stream 給 UI 使用 (也可以在 VM 內 listen)
  Stream<TaskModel?> get taskStream => _taskRepo.streamTask(taskId);

  Future<void> addMember(
      Map<String, dynamic> currentMembersMap, Translations t) async {
    _isProcessing = true;
    notifyListeners();

    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final newId = 'temp_$timestamp';

      final newMember = {
        'id': newId,
        'displayName':
            '${t.S53_TaskSettings_Members.member_default_name} ${currentMembersMap.length + 1}',
        'role': 'member',
        'status': 'unlinked',
        'defaultSplitRatio': 1.0,
        'avatar': null,
        'isLinked': false,
        'createdAt': timestamp,
      };

      final updatedMap = Map<String, dynamic>.from(currentMembersMap);
      updatedMap[newId] = newMember;

      await _taskRepo.replaceMembersMap(taskId, updatedMap);

      await ActivityLogService.log(
        taskId: taskId,
        action: LogAction.addMember,
        details: {'memberName': newMember['displayName']},
      );
    } catch (e) {
      debugPrint("Add member failed: $e");
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  Future<void> renameMember(Map<String, dynamic> currentMembersMap,
      String memberId, String newName) async {
    final trimmedName = newName.trim();
    if (trimmedName.isEmpty) return;

    final oldData = currentMembersMap[memberId] as Map<String, dynamic>?;
    if (oldData == null) return;
    if (oldData['displayName'] == trimmedName) return;

    _isProcessing = true;
    notifyListeners();

    try {
      final updatedMap = Map<String, dynamic>.from(currentMembersMap);
      final updatedMemberData = Map<String, dynamic>.from(oldData);
      updatedMemberData['displayName'] = trimmedName;
      updatedMap[memberId] = updatedMemberData;

      await _taskRepo
          .updateMemberFields(taskId, memberId, {'displayName': trimmedName});
    } catch (e) {
      debugPrint("Rename failed: $e");
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  Future<void> updateRatio(Map<String, dynamic> currentMembersMap,
      String memberId, double newRatio) async {
    // 這裡還是要更新
    await _taskRepo
        .updateMemberFields(taskId, memberId, {'defaultSplitRatio': newRatio});
  }

  /// 嘗試刪除成員
  /// Returns: true if deleted, false if blocked (has data)
  Future<bool> deleteMember(
      Map<String, dynamic> currentMembersMap, String memberId) async {
    final memberToDelete = currentMembersMap[memberId] as Map<String, dynamic>?;
    if (memberToDelete == null) return false;

    _isProcessing = true;
    notifyListeners();

    try {
      // 1. 髒檢查
      final hasData = await _recordRepo.hasMemberRecords(taskId, memberId);

      if (hasData) {
        return false; // Blocked
      }

      // 2. 執行刪除
      final updatedMap = Map<String, dynamic>.from(currentMembersMap);
      updatedMap.remove(memberId);

      await _taskRepo.replaceMembersMap(taskId, updatedMap);

      await ActivityLogService.log(
        taskId: taskId,
        action: LogAction.removeMember,
        details: {'memberName': memberToDelete['displayName']},
      );

      return true; // Deleted
    } catch (e) {
      debugPrint("Delete member failed: $e");
      return false; // Error treated as blocked/failed
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  Future<void> inviteMember(BuildContext context, String taskName) async {
    _isProcessing = true;
    notifyListeners();
    try {
      await TaskShareHelper.inviteMember(
        context: context,
        taskId: taskId,
        taskName: taskName,
      );
    } catch (e) {
      debugPrint("Invite Error: $e");
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }
}
