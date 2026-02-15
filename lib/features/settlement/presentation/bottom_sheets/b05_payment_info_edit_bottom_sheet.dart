import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/common/presentation/view/common_state_view.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/app_toast.dart';
import 'package:iron_split/features/common/presentation/widgets/common_bottom_sheet.dart';
import 'package:iron_split/features/common/presentation/widgets/form/app_keyboard_actions_wrapper.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/settlement/presentation/viewmodels/b05_payment_info_edit_vm.dart';
import 'package:iron_split/features/settlement/presentation/widgets/payment_info_form.dart';
import 'package:iron_split/features/system/data/system_repository.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:provider/provider.dart';

/// B05: 編輯收款資訊 (BottomSheet)
class B05PaymentinfoEditBottomSheet extends StatelessWidget {
  final TaskModel task;

  const B05PaymentinfoEditBottomSheet({super.key, required this.task});

  static void show(BuildContext context, {required TaskModel task}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      // 避免鍵盤遮擋
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: B05PaymentinfoEditBottomSheet(task: task),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => B05PaymentInfoEditViewModel(
        taskRepo: context.read<TaskRepository>(),
        authRepo: context.read<AuthRepository>(),
        systemRepo: context.read<SystemRepository>(),
        task: task,
      )..init(),
      child: const _B05Content(),
    );
  }
}

class _B05Content extends StatefulWidget {
  const _B05Content();

  @override
  State<_B05Content> createState() => _B05ContentState();
}

class _B05ContentState extends State<_B05Content> {
  late FocusNode _bankNameNode;
  late FocusNode _bankAccountNode;
  final Map<int, FocusNode> _appNameNodes = {};
  final Map<int, FocusNode> _appLinkNodes = {};

  @override
  void initState() {
    super.initState();
    _bankNameNode = FocusNode();
    _bankAccountNode = FocusNode();
  }

  @override
  void dispose() {
    _bankNameNode.dispose();
    _bankAccountNode.dispose();
    for (var node in _appNameNodes.values) {
      node.dispose();
    }
    for (var node in _appLinkNodes.values) {
      node.dispose();
    }
    super.dispose();
  }

  // 取得動態 Node 的 Helper
  FocusNode _getAppLinkNode(int index) {
    return _appLinkNodes.putIfAbsent(index, () => FocusNode());
  }

  FocusNode _getAppNameNode(int index) {
    return _appNameNodes.putIfAbsent(index, () => FocusNode());
  }

  Future<void> _handleSave(
      BuildContext context, B05PaymentInfoEditViewModel vm) async {
    try {
      await vm.save();

      if (!context.mounted) return;
      context.pop();
    } on AppErrorCodes catch (code) {
      final msg = ErrorMapper.map(context, code: code);
      AppToast.showError(context, msg);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final vm = context.watch<B05PaymentInfoEditViewModel>();
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final title = t.S31_settlement_payment_info.title;

    final allNodes = [
      _bankNameNode,
      _bankAccountNode,
      ...List.generate(
          vm.formController.appControllers.length, (i) => _getAppNameNode(i)),
      ...List.generate(
          vm.formController.appControllers.length, (i) => _getAppLinkNode(i)),
    ];

    return AppKeyboardActionsWrapper(
      focusNodes: allNodes,
      child: CommonStateView(
        status: vm.initStatus,
        title: title,
        errorCode: vm.initErrorCode,
        isSheetMode: true,
        child: CommonBottomSheet(
          title: t.S31_settlement_payment_info.title,
          bottomActionBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Sync Checkbox (Smart Display)
              if (vm.showSyncOption)
                Container(
                  color: theme.colorScheme.surfaceContainerLow,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: CheckboxListTile(
                    value: vm.isSyncChecked,
                    onChanged: vm.toggleSync,
                    title: Text(
                      vm.isUpdate
                          ? t.S31_settlement_payment_info
                              .sync_update // "更新我的預設收款資訊"
                          : t.S31_settlement_payment_info
                              .sync_save, // "儲存為預設收款資訊"
                      style: textTheme.bodySmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    activeColor: theme.colorScheme.primary,
                  ),
                ),
              StickyBottomActionBar.sheet(
                children: [
                  AppButton(
                    text: t.common.buttons.cancel,
                    type: AppButtonType.secondary,
                    onPressed: () => context.pop(),
                  ),
                  AppButton(
                    text: t.common.buttons.save,
                    type: AppButtonType.primary,
                    onPressed: () => _handleSave(context, vm),
                  ),
                ],
              ),
            ],
          ),
          children: SingleChildScrollView(
            child: PaymentInfoForm(controller: vm.formController),
          ),
        ),
      ),
    );
  }
}
