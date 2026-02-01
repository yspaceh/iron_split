import 'package:flutter/material.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
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
        taskRepo: context.read<TaskRepository>(),
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
            child: StreamBuilder<List<ActivityLogModel>>(
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

                final logs = snapshot.data ?? [];

                if (logs.isEmpty) {
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
                  itemCount: logs.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final log = logs[index];

                    return ActivityLogItem(
                      log: log,
                      memberData: vm.membersData, // Use data from VM
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: StickyBottomActionBar(
        children: [
          AppButton(
              text: t.S52_TaskSettings_Log.action_export_csv,
              type: AppButtonType.secondary,
              isLoading: vm.isExporting,
              icon: Icons.download,
              onPressed: vm.isExporting ? null : () => vm.exportCsv(context)),
        ],
      ),
    );
  }
}
