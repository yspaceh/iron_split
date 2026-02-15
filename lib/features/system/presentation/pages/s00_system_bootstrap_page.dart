import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/features/common/presentation/view/common_state_view.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/system/presentation/viewmodels/s00_system_bootstrap_vm.dart';
import 'package:provider/provider.dart';
import 'package:iron_split/features/onboarding/application/pending_invite_provider.dart';

class S00SystemBootstrapPage extends StatelessWidget {
  const S00SystemBootstrapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => S00SystemBootstrapViewModel(
        authRepo: context.read<AuthRepository>(),
        pendingProvider: context.read<PendingInviteProvider>(),
      ),
      child: const _S00Content(),
    );
  }
}

class _S00Content extends StatefulWidget {
  const _S00Content();

  @override
  State<_S00Content> createState() => _S00ContentState();
}

class _S00ContentState extends State<_S00Content> {
  late final S00SystemBootstrapViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = context.read<S00SystemBootstrapViewModel>();

    // 監聽狀態變化來執行導航
    _vm.addListener(_onStateChanged);

    // 啟動初始化
    // 使用 addPostFrameCallback 確保不會在 build 過程中觸發狀態更新
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _vm.initApp();
    });
  }

  @override
  void dispose() {
    _vm.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    if (!mounted) return;

    // 當狀態變成 success 時，執行導航
    if (_vm.initStatus == LoadStatus.success && _vm.destination != null) {
      _navigate(_vm.destination!);
    }
  }

  void _navigate(BootstrapDestination destination) {
    switch (destination) {
      case BootstrapDestination.onboarding:
        context.goNamed('S50');
        break;
      case BootstrapDestination.setupName:
        context.goNamed('S51');
        break;
      case BootstrapDestination.confirmInvite:
        final code = _vm.pendingCode;
        context.goNamed('S11', queryParameters: {'code': code});
        break;
      case BootstrapDestination.home:
        context.goNamed('S10');
        break;
      case BootstrapDestination.updateTerms:
        context.goNamed('S72');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final vm = context.watch<S00SystemBootstrapViewModel>();
    // 這裡只需要顯示 Loading 與背景
    return CommonStateView(
      status: vm.initStatus,
      errorCode: vm.initErrorCode,
      title: '',
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: Center(
          child: CircularProgressIndicator(color: theme.colorScheme.primary),
        ),
      ),
    );
  }
}
