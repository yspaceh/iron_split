import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iron_split/features/task/presentation/widgets/activity_log_item.dart';
import 'package:provider/provider.dart';
import 'package:iron_split/features/task/data/models/activity_log_model.dart';
import 'package:iron_split/features/task/presentation/viewmodels/s52_task_settings_log_vm.dart';
import 'package:iron_split/gen/strings.g.dart';

class S52TaskSettingsLogPage extends StatelessWidget {
  const S52TaskSettingsLogPage({
    super.key,
    required this.taskId,
    required this.membersData,
  });

  final String taskId;
  final Map<String, dynamic> membersData;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => S52TaskSettingsLogViewModel(
        taskId: taskId,
        membersData: membersData,
      ),
      child: const _S52Content(),
    );
  }
}

class _S52Content extends StatelessWidget {
  const _S52Content();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = Translations.of(context);
    final vm = context.watch<S52TaskSettingsLogViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(t.S52_TaskSettings_Log.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: vm.logsStream,
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
                    final log = ActivityLogModel.fromFirestore(docs[index]);

                    return ActivityLogItem(
                      log: log,
                      memberData: vm.membersData, // Use data from VM
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
                onPressed: vm.isExporting ? null : () => vm.exportCsv(context),
                icon: vm.isExporting
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
