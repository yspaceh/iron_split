import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/task/presentation/views/s18_input_view.dart';
import 'package:provider/provider.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/app_toast.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:iron_split/features/task/presentation/viewmodels/s18_task_join_vm.dart';

class S18TaskJoinPage extends StatelessWidget {
  const S18TaskJoinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => S18TaskJoinViewModel(),
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
  DateTime? _lastErrorTime;

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

  Future<void> _handleNativeScan(
      BuildContext context, S18TaskJoinViewModel vm, Translations t) async {
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      final rawCode = await vm.startScan();
      if (rawCode != null && context.mounted) {
        _handleRawCode(context, vm, t, rawCode);
      }
    } on AppErrorCodes catch (code) {
      if (!context.mounted) return;
      final msg = ErrorMapper.map(context, code: code);
      AppToast.showError(context, msg);
    }
  }

  void _handleRawCode(BuildContext context, S18TaskJoinViewModel vm,
      Translations t, String rawCode) {
    final parsedCode = vm.parseScannedData(rawCode);

    if (parsedCode != null) {
      HapticFeedback.vibrate(); // 震動回饋

      vm.codeController.text = parsedCode;

      // 自動觸發跳轉 (如果你希望使用者自己按確認，可以把這行註解掉)
      _handleCode(context, vm, parsedCode);
    } else {
      if (_isNavigating) return;
      final now = DateTime.now();
      if (_lastErrorTime == null ||
          now.difference(_lastErrorTime!).inSeconds > 2) {
        _lastErrorTime = now;
        AppToast.showError(context, t.error.message.invalid_qr_code);
      }
    }
  }

  void _handleCode(BuildContext context, S18TaskJoinViewModel vm, String code) {
    if (_isNavigating) return;
    _isNavigating = true;

    context.pushNamed('S11',
        queryParameters: {'code': code.toUpperCase()}).then((_) {
      // 如果從 S11 返回，解除鎖定並根據當前 Mode 決定是否重啟相機
      _isNavigating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final vm = context.watch<S18TaskJoinViewModel>();
    final isEnlarged = context.watch<DisplayState>().isEnlarged;
    final double horizontalMargin = AppLayout.pageMargin(isEnlarged);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.s18_task_join.title),
        centerTitle: true,
      ),
      bottomNavigationBar: StickyBottomActionBar(
        isSheetMode: false,
        children: [
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
            onScanPressed: () => _handleNativeScan(context, vm, t),
          ),
        ),
      ),
    );
  }
}
