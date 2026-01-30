import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iron_split/features/common/presentation/dialogs/common_alert_dialog.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar.dart';
import 'package:iron_split/features/common/presentation/widgets/common_ratio_stepper.dart';
import 'package:iron_split/features/task/domain/helpers/task_share_helper.dart';
import 'package:iron_split/features/task/domain/models/activity_log_model.dart';
import 'package:iron_split/features/task/domain/services/activity_log_service.dart';
import 'package:iron_split/gen/strings.g.dart';

class S53TaskSettingsMembersPage extends StatefulWidget {
  final String taskId;

  const S53TaskSettingsMembersPage({
    super.key,
    required this.taskId,
  });

  @override
  State<S53TaskSettingsMembersPage> createState() =>
      _S53TaskSettingsMembersPageState();
}

class _S53TaskSettingsMembersPageState
    extends State<S53TaskSettingsMembersPage> {
  bool _isProcessing = false;

  /// 新增未連結成員
  Future<void> _handleAddMember(Map<String, dynamic> currentMembersMap) async {
    final t = Translations.of(context);
    setState(() => _isProcessing = true);

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
          .doc(widget.taskId)
          .update({'members': updatedMap});

      await ActivityLogService.log(
        taskId: widget.taskId,
        action: LogAction.addMember,
        details: {'memberName': newMember['displayName']},
      );
    } catch (e) {
      debugPrint("Add member failed: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  /// 修改成員名稱 (Rename) - 使用 Dialog 觸發
  Future<void> _handleRenameMember(Map<String, dynamic> currentMembersMap,
      String memberId, String newName) async {
    final trimmedName = newName.trim();
    if (trimmedName.isEmpty) return;

    // 1. 取得舊資料
    final oldData = currentMembersMap[memberId] as Map<String, dynamic>?;
    if (oldData == null) return;

    // 如果名字沒變，不執行寫入
    if (oldData['displayName'] == trimmedName) return;

    setState(() => _isProcessing = true);

    try {
      // 2. 準備更新資料 (深拷貝以避免 Reference Error)
      final updatedMap = Map<String, dynamic>.from(currentMembersMap);

      // 複製單個成員資料
      final updatedMemberData = Map<String, dynamic>.from(oldData);
      updatedMemberData['displayName'] = trimmedName;

      // 放回大 Map
      updatedMap[memberId] = updatedMemberData;

      // 3. 寫入 Firestore
      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(widget.taskId)
          .update({'members': updatedMap});
    } catch (e) {
      debugPrint("Rename failed: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Rename failed: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  /// 修改預設比例
  Future<void> _handleRatioChange(Map<String, dynamic> currentMembersMap,
      String memberId, double newRatio) async {
    // 這裡也要確保 Deep Copy，防止 Immutable 錯誤
    final updatedMap = Map<String, dynamic>.from(currentMembersMap);

    if (updatedMap.containsKey(memberId)) {
      final memberData = Map<String, dynamic>.from(updatedMap[memberId] as Map);
      memberData['defaultSplitRatio'] = newRatio;
      updatedMap[memberId] = memberData;

      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(widget.taskId)
          .update({'members': updatedMap});
    }
  }

  /// 刪除成員
  Future<void> _handleDeleteMember(
      Map<String, dynamic> currentMembersMap, String memberId) async {
    final t = Translations.of(context);
    final memberToDelete = currentMembersMap[memberId] as Map<String, dynamic>?;
    if (memberToDelete == null) return;

    setState(() => _isProcessing = true);

    try {
      // 1. 髒檢查
      final recordsSnapshot = await FirebaseFirestore.instance
          .collection('tasks')
          .doc(widget.taskId)
          .collection('records')
          .get();

      bool hasData = false;

      for (var doc in recordsSnapshot.docs) {
        final data = doc.data();
        if (data['payerId'] == memberId) {
          hasData = true;
          break;
        }
        if (data['payment'] != null &&
            data['payment']['contributors'] is List) {
          final contributors = data['payment']['contributors'] as List;
          if (contributors.any((c) => (c as Map)['uid'] == memberId)) {
            hasData = true;
            break;
          }
        }
        final jsonString = data.toString();
        if (jsonString.contains(memberId)) {
          hasData = true;
          break;
        }
      }

      if (hasData) {
        if (!mounted) return;
        await CommonAlertDialog.show(
          context,
          title: t.S53_TaskSettings_Members.dialog_delete_error_title,
          content: t.S53_TaskSettings_Members.dialog_delete_error_content,
        );
        return;
      }

      // 2. 執行刪除
      final updatedMap = Map<String, dynamic>.from(currentMembersMap);
      updatedMap.remove(memberId);

      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(widget.taskId)
          .update({'members': updatedMap});

      await ActivityLogService.log(
        taskId: widget.taskId,
        action: LogAction.removeMember,
        details: {'memberName': memberToDelete['displayName']},
      );
    } catch (e) {
      debugPrint("Delete member failed: $e");
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  /// 發送邀請
  Future<void> _handleInvite(String taskName) async {
    setState(() => _isProcessing = true);
    try {
      await TaskShareHelper.inviteMember(
        context: context,
        taskId: widget.taskId,
        taskName: taskName,
      );
    } catch (e) {
      debugPrint("Invite Error: $e");
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  /// 顯示更名 Dialog [UI 優化]
  void _showRenameDialog(
      Map<String, dynamic> membersMap, String memberId, String currentName) {
    final t = Translations.of(context);
    final controller = TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(t.S53_TaskSettings_Members.title), // 或 "編輯名稱"
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              labelText: t.S53_TaskSettings_Members.member_name,
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: (val) {
              Navigator.pop(context);
              _handleRenameMember(membersMap, memberId, val);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(t.common.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _handleRenameMember(membersMap, memberId, controller.text);
              },
              child: Text(t.common.confirm),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.S53_TaskSettings_Members.title),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tasks')
            .doc(widget.taskId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final taskData = snapshot.data!.data() as Map<String, dynamic>?;
          if (taskData == null) return const SizedBox();

          // 1. 讀取成員
          final rawMembers = taskData['members'];
          final Map<String, dynamic> membersMap = (rawMembers is Map)
              ? Map<String, dynamic>.from(rawMembers)
              : <String, dynamic>{};

          final createdBy = taskData['createdBy'] as String?;
          final taskName = taskData['name'] as String? ?? 'Task';

          // 2. 轉換為 List
          final List<MapEntry<String, dynamic>> membersList =
              membersMap.entries.toList();

          // 3. 排序
          membersList.sort((a, b) {
            final dataA = a.value as Map<String, dynamic>;
            final dataB = b.value as Map<String, dynamic>;
            final bool isALinked =
                dataA['status'] == 'linked' || (dataA['isLinked'] == true);
            final bool isBLinked =
                dataB['status'] == 'linked' || (dataB['isLinked'] == true);
            if (isALinked && !isBLinked) return -1;
            if (!isALinked && isBLinked) return 1;
            final int tA = dataA['createdAt'] as int? ?? 0;
            final int tB = dataB['createdAt'] as int? ?? 0;
            return tA.compareTo(tB);
          });

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: membersList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final entry = membersList[index];
                    final memberId = entry.key;
                    final memberData = entry.value as Map<String, dynamic>;

                    final bool isOwner =
                        (createdBy != null && memberId == createdBy);

                    return _MemberTile(
                      key: ValueKey(memberId),
                      member: memberData,
                      isOwner: isOwner,
                      onRatioChanged: (val) =>
                          _handleRatioChange(membersMap, memberId, val),
                      onDelete: () => _handleDeleteMember(membersMap, memberId),
                      // [UI優化] 傳入 onEdit callback 觸發 Dialog
                      onEdit: () => _showRenameDialog(membersMap, memberId,
                          memberData['displayName'] ?? ''),
                      isProcessing: _isProcessing,
                    );
                  },
                ),
              ),
              SafeArea(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _isProcessing
                              ? null
                              : () => _handleInvite(taskName),
                          icon: const Icon(Icons.share, size: 18),
                          label: Text(t.S53_TaskSettings_Members.action_invite),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _isProcessing
                              ? null
                              : () => _handleAddMember(membersMap),
                          icon: const Icon(Icons.person_add_alt_1, size: 18),
                          label: Text(t.S53_TaskSettings_Members.action_add),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MemberTile extends StatelessWidget {
  final Map<String, dynamic> member;
  final bool isOwner;
  final ValueChanged<double> onRatioChanged;
  final VoidCallback onDelete;
  final VoidCallback onEdit; // [修改] 改為無參數 callback，點擊觸發 Dialog
  final bool isProcessing;

  const _MemberTile({
    super.key,
    required this.member,
    required this.isOwner,
    required this.onRatioChanged,
    required this.onDelete,
    required this.onEdit,
    required this.isProcessing,
  });

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);

    final isLinked =
        member['status'] == 'linked' || (member['isLinked'] == true);
    final avatarId = member['avatar'];
    final ratio = (member['defaultSplitRatio'] as num? ?? 1.0).toDouble();

    String displayLabel;
    if (isLinked) {
      displayLabel = member['displayName'] ??
          t.S53_TaskSettings_Members.member_default_name;
    } else {
      displayLabel = member['displayName'] ??
          t.S53_TaskSettings_Members.member_default_name;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          CommonAvatar(
            avatarId: avatarId,
            name: displayLabel,
            radius: 20,
            isLinked: isLinked,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // [UI優化] 名字顯示區
                GestureDetector(
                  // 只有未連結成員可以點擊修改
                  onTap: (!isLinked && !isProcessing) ? onEdit : null,
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // 讓 Row 緊貼內容
                    children: [
                      Flexible(
                        child: Text(
                          displayLabel,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            // 如果可編輯，加一點底線提示 (可選)
                            decoration:
                                (!isLinked) ? TextDecoration.underline : null,
                            decorationStyle: TextDecorationStyle.dotted,
                            decorationColor: theme.colorScheme.outline,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // 標記區：隊長星號 OR 編輯鉛筆
                      if (isOwner) ...[
                        const SizedBox(width: 8),
                        Icon(Icons.star_rounded,
                            size: 14, color: theme.colorScheme.primary),
                      ] else if (!isLinked) ...[
                        // [新增] 顯性的編輯按鈕
                        const SizedBox(width: 8),
                        Icon(Icons.edit_rounded,
                            size: 14,
                            color: theme.colorScheme.primary
                                .withValues(alpha: 0.7)),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 比例控制區
          Row(
            children: [
              Text(
                "${ratio.toStringAsFixed(1)}x",
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              CommonRatioStepper(
                value: ratio,
                onChanged: isProcessing ? (_) {} : onRatioChanged,
                enabled: !isProcessing,
              ),
            ],
          ),
          const SizedBox(width: 8),

          // 刪除按鈕 / 佔位符
          if (isOwner)
            const SizedBox(width: 40, height: 40)
          else
            IconButton(
              onPressed: isProcessing ? null : onDelete,
              icon: Icon(
                Icons.delete_outline,
                color: theme.colorScheme.error,
                size: 20,
              ),
              tooltip: t.common.delete,
            ),
        ],
      ),
    );
  }
}
