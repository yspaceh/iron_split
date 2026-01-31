import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iron_split/features/task/domain/helpers/task_share_helper.dart';
import 'package:iron_split/features/task/domain/models/activity_log_model.dart';
import 'package:iron_split/features/task/domain/services/activity_log_service.dart';
import 'package:iron_split/gen/strings.g.dart'; // For default name

class S53TaskSettingsMembersViewModel extends ChangeNotifier {
  final String taskId;
  bool _isProcessing = false;

  bool get isProcessing => _isProcessing;

  S53TaskSettingsMembersViewModel({required this.taskId});

  // 直接暴露 Firestore Stream 給 UI 使用 (也可以在 VM 內 listen)
  Stream<DocumentSnapshot> get taskStream =>
      FirebaseFirestore.instance.collection('tasks').doc(taskId).snapshots();

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

      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(taskId)
          .update({'members': updatedMap});

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

      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(taskId)
          .update({'members': updatedMap});
    } catch (e) {
      debugPrint("Rename failed: $e");
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  Future<void> updateRatio(Map<String, dynamic> currentMembersMap,
      String memberId, double newRatio) async {
    // 這裡通常反應很快，不做全局 loading，避免 UI 跳動
    final updatedMap = Map<String, dynamic>.from(currentMembersMap);

    if (updatedMap.containsKey(memberId)) {
      final memberData = Map<String, dynamic>.from(updatedMap[memberId] as Map);
      memberData['defaultSplitRatio'] = newRatio;
      updatedMap[memberId] = memberData;

      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(taskId)
          .update({'members': updatedMap});
    }
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
      final recordsSnapshot = await FirebaseFirestore.instance
          .collection('tasks')
          .doc(taskId)
          .collection('records')
          .get();

      bool hasData = false;

      for (var doc in recordsSnapshot.docs) {
        final data = doc.data();
        // 檢查 Payer
        if (data['payerId'] == memberId) {
          hasData = true;
          break;
        }
        // 檢查 Contributors (複雜結構)
        if (data['payment'] != null &&
            data['payment']['contributors'] is List) {
          final contributors = data['payment']['contributors'] as List;
          if (contributors.any((c) => (c as Map)['uid'] == memberId)) {
            hasData = true;
            break;
          }
        }
        // Fallback: 簡單字串匹配 (防止遺漏)
        final jsonString = data.toString();
        if (jsonString.contains(memberId)) {
          hasData = true;
          break;
        }
      }

      if (hasData) {
        return false; // Blocked
      }

      // 2. 執行刪除
      final updatedMap = Map<String, dynamic>.from(currentMembersMap);
      updatedMap.remove(memberId);

      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(taskId)
          .update({'members': updatedMap});

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
