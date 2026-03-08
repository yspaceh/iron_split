import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/features/onboarding/application/onboarding_service.dart';
import 'package:iron_split/features/task/presentation/views/s18_input_view.dart';
import 'package:provider/provider.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:iron_split/features/task/presentation/viewmodels/s18_task_enter_code_vm.dart';

class S18TaskEnterCodePage extends StatelessWidget {
  const S18TaskEnterCodePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => S18TaskEnterCodeViewModel(),
      child: const _S18Content(),
    );
  }
}

class _S18Content extends StatefulWidget {
  const _S18Content();

  @override
  State<_S18Content> createState() => _S18ContentState();
}

class _S18ContentState extends State<_S18Content> {
  late FocusNode _codeNode;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _codeNode = FocusNode();
  }

  @override
  void dispose() {
    _codeNode.dispose();
    super.dispose();
  }

  void _handleCode(
      BuildContext context, S18TaskEnterCodeViewModel vm, String code) {
    if (_isNavigating) return;
    _isNavigating = true;

    context.pushNamed('S11',
        queryParameters: {'code': code.toUpperCase()},
        extra: {'inviteMethod': InviteMethod.code}).then((_) {
      // 如果從 S11 返回，解除鎖定並根據當前 Mode 決定是否重啟相機
      _isNavigating = false;
    });
  }

  void _redirectToScan(BuildContext context) {
    context.pushNamed('S19');
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final vm = context.watch<S18TaskEnterCodeViewModel>();
    final isEnlarged = context.watch<DisplayState>().isEnlarged;
    final double horizontalMargin = AppLayout.pageMargin(isEnlarged);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.s18_task_enter_code.title),
        centerTitle: true,
      ),
      bottomNavigationBar: StickyBottomActionBar(
        isSheetMode: false,
        children: [
          AppButton(
            text: t.s18_task_enter_code.buttons.scan,
            type: AppButtonType.secondary,
            onPressed: () => _redirectToScan(context),
          ),
          AppButton(
            text: t.common.buttons.confirm,
            type: AppButtonType.primary,
            onPressed: !vm.isInputValid
                ? null
                : () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    final code = vm.codeController.text.trim();
                    _handleCode(context, vm, code);
                  },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalMargin),
          child: S18InputView(
            controller: vm.codeController,
            focusNode: _codeNode,
          ),
        ),
      ),
    );
  }
}
