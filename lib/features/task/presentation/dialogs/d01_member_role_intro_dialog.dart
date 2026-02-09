import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/avatar_constants.dart';
import 'package:iron_split/features/common/presentation/dialogs/common_alert_dialog.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
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
      child: CommonAlertDialog(
        title: t.D01_MemberRole_Intro.title,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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

            Text(vm.currentAvatar),

            Text(
              t.D01_MemberRole_Intro.description.content(
                avatar: AvatarConstants.getName(t, vm.currentAvatar),
              ),
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
                  ? t.D01_MemberRole_Intro.buttons.reroll
                  : t.D01_MemberRole_Intro.description.reroll_empty),
            ),
          ],
        ),
        actions: [
          AppButton(
            text: t.D01_MemberRole_Intro.buttons.enter,
            type: AppButtonType.primary,
            onPressed: () => _onEnter(context, vm),
          ),
        ],
      ),
    );
  }
}
