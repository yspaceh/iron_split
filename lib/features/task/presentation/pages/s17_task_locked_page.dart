import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/features/task/presentation/views/s17_settled_pending_view.dart';
import 'package:iron_split/features/task/presentation/views/s17_status_view.dart';

/// Page Key: S17_Task.Locked
/// 負責：AppBar, Loading, 路由分發
class S17TaskLockedPage extends StatelessWidget {
  final String taskId;

  const S17TaskLockedPage({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tasks')
          .doc(taskId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        final data = snapshot.data!.data() as Map<String, dynamic>?;
        if (data == null) return const Scaffold(body: SizedBox());

        // 狀態判斷
        final status = data['status'] as String? ?? 'closed';
        final settlementData =
            data['settlement'] as Map<String, dynamic>? ?? {};
        final settlementStatus =
            settlementData['status'] as String? ?? 'pending';

        Widget content;

        // 路由邏輯
        if (status == 'closed') {
          // WF33: 手動結束 -> 鎖頭
          content = const S17StatusView(
            mode: LockedMode.closed,
          );
        } else if (status == 'settled') {
          if (settlementStatus == 'cleared') {
            // WF45: 結算完成 -> 打勾
            content = const S17StatusView(
              mode: LockedMode.cleared,
            );
          } else {
            // WF41: 結算進行中 -> 儀表板
            content = S17SettledPendingView();
          }
        } else {
          // 例外處理
          content = const SizedBox();
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(data['name'] ?? ''),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.go('/landing'), // 唯一出口
            ),
          ),
          body: content,
        );
      },
    );
  }
}
