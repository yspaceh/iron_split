import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iron_split/features/task/data/models/activity_log_model.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:iron_split/gen/strings.g.dart'; // 需要 context 翻譯
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class S52TaskSettingsLogViewModel extends ChangeNotifier {
  final TaskRepository _taskRepo;
  final String taskId;
  final Map<String, dynamic> membersData;

  bool _isExporting = false;
  bool get isExporting => _isExporting;

  S52TaskSettingsLogViewModel({
    required this.taskId,
    required TaskRepository taskRepo,
    required this.membersData,
  }) : _taskRepo = taskRepo;

  // Logs Stream Getter
  Stream<List<ActivityLogModel>> get logsStream =>
      _taskRepo.streamActivityLogs(taskId);

  Future<void> exportCsv(BuildContext context) async {
    _isExporting = true;
    notifyListeners();

    try {
      final t = Translations.of(context);

      // 1. Fetch all logs (改用 Repo)
      final logs = await _taskRepo.getActivityLogs(taskId);

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
        final member = membersData[log.operatorUid] as Map<String, dynamic>?;
        final displayName = member?['displayName'] as String? ?? 'Unknown';

        final timeStr = dateFormat.format(log.createdAt);
        final actionStr = log.getLocalizedAction(context);
        final detailsStr = log.getFormattedDetails(context);

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
      final fileName =
          '${t.S52_TaskSettings_Log.export_file_prefix}_${DateFormat('yyyyMMdd_HHmm').format(DateTime.now())}.csv';
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsString(csvBuffer.toString());

      // 5. Share
      if (context.mounted) {
        await SharePlus.instance.share(
          ShareParams(
            subject: t.S52_TaskSettings_Log.title,
            files: [XFile(file.path)],
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(Translations.of(context)
                  .common
                  .error_prefix(message: e.toString()))),
        );
      }
    } finally {
      _isExporting = false;
      notifyListeners();
    }
  }
}
