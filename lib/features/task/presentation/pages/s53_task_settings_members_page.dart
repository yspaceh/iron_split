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

  /// 新增未連結成員 (Unlinked Member) - 寫入 Map
  Future<void> _handleAddMember(Map<String, dynamic> currentMembersMap) async {
    final t = Translations.of(context);
    setState(() => _isProcessing = true);

    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      // 使用 timestamp 作為 Key，確保唯一性
      final newId = 'temp_$timestamp';

      final newMember = {
        'id': newId,
        'name':
            '${t.S53_TaskSettings_Members.member_default_name} ${currentMembersMap.length + 1}',
        'role': 'member',
        'status': 'unlinked',
        'defaultSplitRatio': 1.0,
        'avatar': null,
        'isLinked': false,
        'createdAt': timestamp,
      };

      // 複製舊 Map 並新增一筆 (確保是 Map 操作)
      final updatedMap = Map<String, dynamic>.from(currentMembersMap);
      updatedMap[newId] = newMember;

      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(widget.taskId)
          .update({'members': updatedMap});

      await ActivityLogService.log(
        taskId: widget.taskId,
        action: LogAction.addMember,
        details: {'memberName': newMember['name']},
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

  /// 修改預設比例 - 更新 Map
  Future<void> _handleRatioChange(Map<String, dynamic> currentMembersMap,
      String memberId, double newRatio) async {
    final updatedMap = Map<String, dynamic>.from(currentMembersMap);

    // 確保該 Key 存在
    if (updatedMap.containsKey(memberId)) {
      // 需要先轉成 Map 才能修改內部欄位
      final memberData = Map<String, dynamic>.from(updatedMap[memberId] as Map);
      memberData['defaultSplitRatio'] = newRatio;

      updatedMap[memberId] = memberData;

      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(widget.taskId)
          .update({'members': updatedMap});
    }
  }

  /// 刪除成員 - 從 Map 移除 Key
  Future<void> _handleDeleteMember(
      Map<String, dynamic> currentMembersMap, String memberId) async {
    final t = Translations.of(context);

    // 取得要刪除的成員資料 (用於 Log)
    final memberToDelete = currentMembersMap[memberId] as Map<String, dynamic>?;
    if (memberToDelete == null) return;

    setState(() => _isProcessing = true);

    try {
      // 1. 髒檢查 (Dirty Check)
      final recordsSnapshot = await FirebaseFirestore.instance
          .collection('tasks')
          .doc(widget.taskId)
          .collection('records')
          .get();

      bool hasData = false;

      for (var doc in recordsSnapshot.docs) {
        final data = doc.data();

        // A. 檢查付款人 (payerId)
        if (data['payerId'] == memberId) {
          hasData = true;
          break;
        }

        // B. 檢查多重付款人
        if (data['payment'] != null &&
            data['payment']['contributors'] is List) {
          final contributors = data['payment']['contributors'] as List;
          // 這裡檢查 contributors 裡面有沒有這個 uid
          if (contributors.any((c) => (c as Map)['uid'] == memberId)) {
            hasData = true;
            break;
          }
        }

        // C. 檢查分帳對象 (簡單字串檢查 ID 是否存在於文件內容中)
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

      // 2. 執行刪除 (Map Remove)
      final updatedMap = Map<String, dynamic>.from(currentMembersMap);
      updatedMap.remove(memberId);

      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(widget.taskId)
          .update({'members': updatedMap});

      await ActivityLogService.log(
        taskId: widget.taskId,
        action: LogAction.removeMember,
        details: {'memberName': memberToDelete['name']},
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to generate invite code")),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
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

          // 1. 安全讀取 members Map
          final rawMembers = taskData['members'];
          final Map<String, dynamic> membersMap = (rawMembers is Map)
              ? Map<String, dynamic>.from(rawMembers)
              : <String, dynamic>{};

          final createdBy = taskData['createdBy'] as String?;
          final taskName = taskData['name'] as String? ?? 'Task';

          // 2. 轉換為 List<MapEntry> (解決 getter key 錯誤的關鍵)
          // Explicitly typing helps debugging and type safety
          final List<MapEntry<String, dynamic>> membersList =
              membersMap.entries.toList();

          // 3. 排序邏輯
          membersList.sort((a, b) {
            final dataA = a.value as Map<String, dynamic>;
            final dataB = b.value as Map<String, dynamic>;

            // A. 已連結優先
            final bool isALinked =
                dataA['status'] == 'linked' || (dataA['isLinked'] == true);
            final bool isBLinked =
                dataB['status'] == 'linked' || (dataB['isLinked'] == true);

            if (isALinked && !isBLinked) return -1;
            if (!isALinked && isBLinked) return 1;

            // B. 建立時間排序
            final int tA = dataA['createdAt'] as int? ?? 0;
            final int tB = dataB['createdAt'] as int? ?? 0;
            return tA.compareTo(tB);
          });

          return Column(
            children: [
              // 成員列表
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: membersList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final entry = membersList[index];
                    final memberId = entry.key; // 這是 Map 的 Key，絕對安全
                    final memberData = entry.value as Map<String, dynamic>;

                    // 判斷邏輯：ID 是否等於 createdBy
                    final bool isOwner =
                        (createdBy != null && memberId == createdBy);

                    return _MemberTile(
                      key: ValueKey(memberId),
                      member: memberData,
                      isOwner: isOwner,
                      onRatioChanged: (val) =>
                          _handleRatioChange(membersMap, memberId, val),
                      onDelete: () => _handleDeleteMember(membersMap, memberId),
                      isProcessing: _isProcessing,
                    );
                  },
                ),
              ),

              // 底部按鈕區 (左右並排)
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
                      // 左邊：邀請
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
                      // 右邊：新增
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
  final bool isProcessing;

  const _MemberTile({
    super.key,
    required this.member,
    required this.isOwner,
    required this.onRatioChanged,
    required this.onDelete,
    required this.isProcessing,
  });

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);

    final name = member['displayName'] ?? member['name'] ?? 'Unknown';
    final isLinked =
        member['status'] == 'linked' || (member['isLinked'] == true);
    final avatarId = member['avatar'];
    final ratio = (member['defaultSplitRatio'] as num? ?? 1.0).toDouble();

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
            name: name,
            radius: 20,
            isLinked: isLinked,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isOwner) ...[
                      const SizedBox(width: 4),
                      Icon(Icons.star,
                          size: 14, color: theme.colorScheme.primary),
                    ],
                  ],
                ),
              ],
            ),
          ),
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

          // 隊長顯示鎖頭，其他人顯示刪除
          if (isOwner)
            SizedBox(
              width: 40,
              height: 40,
              child: Icon(Icons.lock_outline,
                  size: 18,
                  color: theme.colorScheme.outline.withValues(alpha: 0.5)),
            )
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
