import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:iron_split/features/common/presentation/widgets/common_avatar.dart';
import 'package:iron_split/features/task/domain/models/activity_log_model.dart';
import 'package:iron_split/gen/strings.g.dart';

class S52TaskSettingsLogPage extends StatefulWidget {
  const S52TaskSettingsLogPage({
    super.key,
    required this.taskId,
    required this.membersData,
  });

  final String taskId;
  final Map<String, dynamic> membersData;

  @override
  State<S52TaskSettingsLogPage> createState() => _S52TaskSettingsLogPageState();
}

class _S52TaskSettingsLogPageState extends State<S52TaskSettingsLogPage> {
  bool _isExporting = false;

  Future<void> _exportCsv() async {
    setState(() {
      _isExporting = true;
    });

    try {
      // 1. Fetch all logs
      final collection = FirebaseFirestore.instance
          .collection('tasks/${widget.taskId}/activity_logs')
          .orderBy('createdAt', descending: true); // 最新在最上面

      final snapshot = await collection.get();
      final logs = snapshot.docs
          .map((doc) => ActivityLogModel.fromFirestore(doc))
          .toList();

      // 2. Prepare CSV Header
      final header =
          '${t.S52_TaskSettings_Log.csv_header.time},${t.S52_TaskSettings_Log.csv_header.user},${t.S52_TaskSettings_Log.csv_header.action},${t.S52_TaskSettings_Log.csv_header.details}\n';

      final csvBuffer = StringBuffer();
      // Add BOM for Excel UTF-8 compatibility
      csvBuffer.write('\uFEFF');
      csvBuffer.write(header);

      final dateFormat = DateFormat('yyyy/MM/dd HH:mm');

      // 3. Generate Rows
      for (final log in logs) {
        // Resolve User Name
        final member =
            widget.membersData[log.operatorUid] as Map<String, dynamic>?;
        // CSV 只顯示名字，不顯示頭像
        final displayName = member?['displayName'] as String? ?? 'Unknown';

        // Resolve Action & Details using Model
        final timeStr = dateFormat.format(log.createdAt);
        final actionStr = log.getLocalizedAction(context);
        final detailsStr = log.getFormattedDetails(); // 包含金額幣別格式化

        // Escape CSV fields (handle commas in content)
        String escape(String s) {
          if (s.contains(',') || s.contains('"') || s.contains('\n')) {
            return '"${s.replaceAll('"', '""')}"';
          }
          return s;
        }

        csvBuffer.write(
            '${escape(timeStr)},${escape(displayName)},${escape(actionStr)},${escape(detailsStr)}\n');
      }

      // 4. Save to Temp File
      final tempDir = await getTemporaryDirectory();
      // 使用當前時間做檔名
      final fileName =
          '${t.S52_TaskSettings_Log.export_file_prefix}_${DateFormat('yyyyMMdd_HHmm').format(DateTime.now())}.csv';
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsString(csvBuffer.toString());

      // 5. Share
      if (mounted) {
        // [FIX] Use SharePlus.instance.share() with ShareParams
        await SharePlus.instance.share(
          ShareParams(
            subject: t.S52_TaskSettings_Log.title,
            files: [XFile(file.path)], // 改用 files 傳遞列表
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.common.error_prefix(message: e.toString()))),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isExporting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.S52_TaskSettings_Log.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('tasks/${widget.taskId}/activity_logs')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                      child: Text(t.common
                          .error_prefix(message: snapshot.error.toString())));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data?.docs ?? [];

                if (docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history,
                            size: 48, color: theme.colorScheme.outline),
                        const SizedBox(height: 16),
                        Text(
                          t.S52_TaskSettings_Log.empty_log,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: docs.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    // Convert to Model
                    final log = ActivityLogModel.fromFirestore(docs[index]);

                    // Resolve Operator Info
                    final member = widget.membersData[log.operatorUid]
                        as Map<String, dynamic>?;
                    final displayName =
                        member?['displayName'] as String? ?? 'Unknown';
                    final avatarId = member?['avatar'] as dynamic;

                    // Format Data
                    final actionStr = log.getLocalizedAction(context);
                    final detailsStr = log.getFormattedDetails();
                    final timeStr =
                        DateFormat('yyyy/MM/dd HH:mm').format(log.createdAt);

                    return ListTile(
                      leading: CommonAvatar(
                        avatarId: avatarId,
                        name: displayName,
                        radius: 20,
                      ),
                      title: Text(
                        '$actionStr: $detailsStr',
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        '$displayName • $timeStr',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Sticky Bottom Button
          SafeArea(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
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
              child: FilledButton.icon(
                onPressed: _isExporting ? null : _exportCsv,
                icon: _isExporting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.download),
                label: Text(t.S52_TaskSettings_Log.action_export_csv),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
