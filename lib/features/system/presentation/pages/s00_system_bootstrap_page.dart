import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/features/system/presentation/viewmodels/s00_system_bootstrap_vm.dart';
import 'package:provider/provider.dart';
import 'package:iron_split/features/onboarding/application/pending_invite_provider.dart';

class S00SystemBootstrapPage extends StatefulWidget {
  const S00SystemBootstrapPage({super.key});
  @override
  State<S00SystemBootstrapPage> createState() => _S00SystemBootstrapPageState();
}

class _S00SystemBootstrapPageState extends State<S00SystemBootstrapPage> {
  // 我們不需要 ChangeNotifierProvider 包覆整個 Scaffold，
  // 因為這頁只有一個動作，直接在 State 裡用即可。
  // 但為了統一風格，用 Provider 也可以。
  late final S00SystemBootstrapViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = S00SystemBootstrapViewModel();
    _startBootstrap();
  }

  Future<void> _startBootstrap() async {
    // 從 Provider 拿邀請碼 (UI 層的狀態)
    final destination = await _vm.initApp(
      getPendingCode: () => context.read<PendingInviteProvider>().pendingCode,
    );

    // 呼叫 VM 判斷去向
    if (!mounted) return;

    // 根據結果導航
    switch (destination) {
      case BootstrapDestination.onboarding:
        context.goNamed('S50');
        break;
      case BootstrapDestination.setupName:
        context.goNamed('S51');
        break;
      case BootstrapDestination.confirmInvite:
        final latestCode = context.read<PendingInviteProvider>().pendingCode;
        context.goNamed('S11', queryParameters: {'code': latestCode});
        break;
      case BootstrapDestination.home:
        context.goNamed('S10');
        break;
      case BootstrapDestination.updateTerms:
        context.goNamed('S72');
    }
  }

  @override
  Widget build(BuildContext context) {
    // 這裡只需要顯示 Loading 與背景
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}
