// lib/features/settlement/presentation/pages/s32_settlement_result_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/services/deep_link_service.dart';
import 'package:iron_split/features/settlement/application/settlement_service.dart';
import 'package:iron_split/features/task/presentation/helpers/task_share_helper.dart';
import 'package:provider/provider.dart';
import 'package:iron_split/gen/strings.g.dart';

// Core & Constants
import 'package:iron_split/core/constants/currency_constants.dart';

// ViewModels & Repos
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:iron_split/features/settlement/presentation/viewmodels/s32_settlement_result_vm.dart';

// Widgets
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:iron_split/features/common/presentation/widgets/state_visual.dart';
import 'package:iron_split/features/common/presentation/widgets/info_card.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar.dart';
import 'package:iron_split/features/settlement/presentation/dialogs/d11_random_result_dialog.dart';

class S32SettlementResultPage extends StatelessWidget {
  final String taskId;
  const S32SettlementResultPage({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => S32SettlementResultViewModel(
        taskId: taskId,
        taskRepo: context.read<TaskRepository>(),
        deepLinkService: context.read<DeepLinkService>(),
        settlementService: context.read<SettlementService>(),
      )..init(),
      child: const _S32Content(),
    );
  }
}

class _S32Content extends StatefulWidget {
  const _S32Content();

  @override
  State<_S32Content> createState() => _S32ContentState();
}

class _S32ContentState extends State<_S32Content> {
  // 狀態：是否已經揭曉
  bool _hasRevealed = false;

  // 標記：是否已經嘗試觸發過 Dialog (避免重複觸發)
  bool _dialogTriggered = false;

  @override
  void initState() {
    super.initState();
    // 預設先不揭曉，等待 VM 資料載入後決定
  }

  // 監聽 VM 變化來觸發 Dialog
  void _checkAndTriggerDialog(S32SettlementResultViewModel vm) {
    if (_dialogTriggered) return;
    if (vm.isLoading || vm.task == null) return; // 資料還沒好

    _dialogTriggered = true; // 標記已觸發

    if (vm.shouldShowRoulette) {
      // 是 Random 模式 且 有零頭 且 有名單 -> 啟動輪盤流程
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showRouletteDialog(vm);
      });
    } else {
      // 一般模式 或 零頭為0 -> 直接視為已揭曉
      setState(() {
        _hasRevealed = true;
      });
    }
  }

  Future<void> _showRouletteDialog(S32SettlementResultViewModel vm) async {
    // 稍微延遲，讓畫面先 Render 出來
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    // 呼叫 D11
    await D11RandomResultDialog.show(
      context,
      members: vm.allMembers, // 從 VM 取得重建後的列表
      winnerId: vm.remainderWinnerId!,
    );

    // Dialog 關閉後，揭曉結果
    if (mounted) {
      setState(() {
        _hasRevealed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final vm = context.watch<S32SettlementResultViewModel>();

    // 每次 build 都檢查是否需要觸發 Dialog
    _checkAndTriggerDialog(vm);

    // 準備資料
    final winner = vm.winnerMember;
    final currency = vm.baseCurrency;

    // 如果是輪盤模式，且還沒揭曉，就不顯示贏家區塊 (顯示 Waiting)
    final bool showWinnerCard =
        vm.isRandomMode && _hasRevealed && winner != null;

    // UI 文字準備
    String winnerTotalText = '';
    if (winner != null) {
      final double amount = winner.finalAmount;
      final String prefix = amount >= 0
          ? t.S30_settlement_confirm.label_refund
          : t.S30_settlement_confirm.label_payable;
      final String total =
          '${currency.code} ${currency.symbol}${CurrencyConstants.formatAmount(amount, currency.code)}';

      winnerTotalText = t.S32_settlement_result.remainder_winner_total(
          winnerName: winner.displayName, total: total, prefix: prefix);
    }

    void onBackToTask() {
      // 清除 Stack，回到 S17 並帶上 taskId
      context.goNamed('S17', pathParameters: {'taskId': vm.taskId});
    }

    Future<void> onShareTap() async {
      try {
        if (context.mounted) {
          await TaskShareHelper.shareSettlement(
            context: context,
            taskId: vm.taskId,
            taskName: vm.task!.name,
          );

          // 3. 導航到任務 Dashboard
          if (mounted) {
            onBackToTask();
          }
        }
      } catch (e) {
        // TODO: handle error
        if (context.mounted) {
          debugPrint(e.toString());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(Translations.of(context)
                    .common
                    .error_prefix(message: e.toString()))),
          );
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: onBackToTask,
        ),
        title: Text(t.S32_settlement_result.title),
        centerTitle: true,
      ),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const StateVisual(
                      assetPath: 'assets/images/iron/iron_image_settlement.png',
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(t.S32_settlement_result.content),
                    ),
                    if (vm.shouldShowRoulette)
                      Visibility(
                        visible: showWinnerCard,
                        replacement: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(t.S32_settlement_result.waiting_reveal),
                        ),
                        child: InfoCard(
                          icon: Icons.info_outline,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(t.S32_settlement_result
                                      .remainder_winner_prefix),
                                  const SizedBox(width: 8),
                                  if (winner != null)
                                    CommonAvatar(
                                      avatarId: winner.avatar,
                                      name: winner.displayName,
                                      isLinked: winner.isLinked,
                                      radius: 12,
                                    ),
                                  const SizedBox(width: 8),
                                  Text(
                                    winner?.displayName ?? '',
                                    style:
                                        theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(winnerTotalText),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: StickyBottomActionBar(
        children: [
          AppButton(
            text: t.S32_settlement_result.buttons.share,
            type: AppButtonType.secondary,
            onPressed: onShareTap,
          ),
          AppButton(
            text: t.S32_settlement_result.buttons.back,
            type: AppButtonType.primary,
            onPressed: onBackToTask,
          ),
        ],
      ),
    );
  }
}
