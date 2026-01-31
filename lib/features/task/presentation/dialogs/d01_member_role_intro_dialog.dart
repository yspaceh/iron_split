import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:provider/provider.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar.dart';
import 'package:iron_split/features/task/presentation/viewmodels/d01_member_role_intro_vm.dart';
import 'package:iron_split/gen/strings.g.dart';

/// Page Key: D01_MemberRole.Intro
class D01MemberRoleIntroDialog extends StatelessWidget {
  final String taskId;
  final String initialAvatar;
  final bool canReroll;

  const D01MemberRoleIntroDialog({
    super.key,
    required this.taskId,
    required this.initialAvatar,
    required this.canReroll,
  });

  @override
  Widget build(BuildContext context) {
    // 使用 Provider 注入 VM
    return ChangeNotifierProvider(
      create: (_) => D01MemberRoleIntroViewModel(
        taskId: taskId,
        taskRepo: context.read<TaskRepository>(),
        initialAvatar: initialAvatar,
        canReroll: canReroll,
      ),
      child: const _D01DialogContent(),
    );
  }
}

class _D01DialogContent extends StatefulWidget {
  const _D01DialogContent();

  @override
  State<_D01DialogContent> createState() => _D01DialogContentState();
}

class _D01DialogContentState extends State<_D01DialogContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    // UI 動畫邏輯保留在 View 層
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
      lowerBound: 0.8,
      upperBound: 1.0,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _onEnter(
      BuildContext context, D01MemberRoleIntroViewModel vm) async {
    await vm.handleEnter();
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = Translations.of(context);

    // 監聽 VM
    final vm = context.watch<D01MemberRoleIntroViewModel>();

    return PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: theme.colorScheme.surfaceTint,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                t.D01_MemberRole_Intro.title,
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              // Avatar Animation
              ScaleTransition(
                scale: _animController,
                child: CommonAvatar(
                  avatarId: vm.currentAvatar, // 從 VM 獲取
                  name: null,
                  radius: 55,
                  isLinked: true,
                ),
              ),
              const SizedBox(height: 16),

              Text(
                t.D01_MemberRole_Intro.dialog_content,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),

              // Reroll Button
              TextButton.icon(
                onPressed: vm.canReroll ? vm.handleReroll : null,
                icon: vm.isUpdating
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.refresh),
                label: Text(vm.canReroll
                    ? t.D01_MemberRole_Intro.action_reroll
                    : t.D01_MemberRole_Intro.desc_reroll_empty),
              ),

              const SizedBox(height: 16),

              // Enter Button
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => _onEnter(context, vm),
                  child: Text(t.D01_MemberRole_Intro.action_enter),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
