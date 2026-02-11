import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/features/onboarding/data/invite_repository.dart';
import 'package:iron_split/features/record/data/record_repository.dart';
import 'package:iron_split/features/task/application/member_service.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:iron_split/features/task/presentation/helpers/task_share_helper.dart';
import 'package:iron_split/features/task/data/models/activity_log_model.dart';
import 'package:iron_split/features/task/data/services/activity_log_service.dart';
import 'package:iron_split/gen/strings.g.dart'; // For default name

class S53TaskSettingsMembersViewModel extends ChangeNotifier {
  final TaskRepository _taskRepo;
  final RecordRepository _recordRepo;
  final InviteRepository _inviteRepo;
  final String taskId;
  bool _isProcessing = false;

  Stream<TaskModel?>? _taskStream;
  bool get isProcessing => _isProcessing;
  String get currentUserId => FirebaseAuth.instance.currentUser?.uid ?? '';

  S53TaskSettingsMembersViewModel(
      {required TaskRepository taskRepo,
      required RecordRepository recordRepo,
      required InviteRepository inviteRepo,
      required this.taskId})
      : _taskRepo = taskRepo,
        _recordRepo = recordRepo,
        _inviteRepo = inviteRepo;

  // 直接暴露 Firestore Stream 給 UI 使用 (也可以在 VM 內 listen)
  Stream<TaskModel?> get taskStream {
    _taskStream ??= _taskRepo.streamTask(taskId);
    return _taskStream!;
  }

  void retryLoad() {
    _taskStream = _taskRepo.streamTask(taskId);

    notifyListeners();
  }

// 徹底重寫 addMember 方法，移除 temp_id, status, createdAt 等垃圾
  Future<void> addMember(Translations t, TaskModel task) async {
    if (_isProcessing) return;
    _isProcessing = true;
    notifyListeners();

    try {
      final nextNumber = (task.memberCount) + 1;
      final virtualId = MemberService.generateVirtualId();
      final newMember = MemberService.createGhost(
          displayName: "${t.common.member_prefix} $nextNumber");

      await _taskRepo.addMemberToTask(taskId, virtualId, newMember);

      // Activity Log ...
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
      // TODO: handle error
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
      // TODO: handle error
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
      final inviteCode = await _inviteRepo.createInviteCode(taskId);
      if (context.mounted) {
        await TaskShareHelper.inviteMember(
          context: context,
          taskName: taskName,
          inviteCode: inviteCode, // 這裡的參數現在跟 Helper 完美對齊了
        );
      }
    } catch (e) {
      // TODO: handle error
      debugPrint("Invite Error: $e");
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }
}
