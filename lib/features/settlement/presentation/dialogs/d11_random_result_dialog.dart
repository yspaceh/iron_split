import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Haptics
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/models/settlement_model.dart';
import 'package:iron_split/core/theme/app_theme.dart'; //  用於存取自定義顏色
import 'package:iron_split/features/common/presentation/dialogs/common_alert_dialog.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar.dart';
import 'package:iron_split/gen/strings.g.dart';

class D11RandomResultDialog extends StatefulWidget {
  final List<SettlementMember> members;
  final String winnerId;

  const D11RandomResultDialog({
    super.key,
    required this.members,
    required this.winnerId,
  });

  static Future<void> show(
    BuildContext context, {
    required List<SettlementMember> members,
    required String winnerId,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => D11RandomResultDialog(
        members: members,
        winnerId: winnerId,
      ),
    );
  }

  @override
  State<D11RandomResultDialog> createState() => _D11RandomResultDialogState();
}

class _D11RandomResultDialogState extends State<D11RandomResultDialog> {
  late FixedExtentScrollController _scrollController;
  late ConfettiController _confettiController;
  bool _isSpinning = true;

  // 為了模擬無限滾動，我們將原始名單重複多次
  // 增加次數以配合更長的動畫時間 (4.5s)
  static const int _loopCount = 50;
  late List<SettlementMember> _displayList;

  @override
  void initState() {
    super.initState();
    debugPrint("[D11] initState called"); // [LOG]

    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));

    if (widget.members.isEmpty) {
      debugPrint("[D11] Member list empty, closing."); // [LOG]
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop();
      });
      return;
    }

    _displayList = [];
    for (int i = 0; i < _loopCount; i++) {
      _displayList.addAll(widget.members);
    }

    final int winnerBaseIndex =
        widget.members.indexWhere((m) => m.memberData.id == widget.winnerId);
    final int safeWinnerIndex = winnerBaseIndex == -1 ? 0 : winnerBaseIndex;
    final int targetRound = _loopCount - 5;
    final int targetIndex =
        (targetRound * widget.members.length) + safeWinnerIndex;

    _scrollController = FixedExtentScrollController(initialItem: 0);

    WidgetsBinding.instance
        .addPostFrameCallback((_) => _tryStartSpinning(targetIndex));
  }

  // [新增] 安全啟動檢查
  void _tryStartSpinning(int targetIndex, [int attempt = 1]) {
    if (!mounted) return;

    bool isReady = false;
    bool hasClients = _scrollController.hasClients;

    if (hasClients) {
      try {
        isReady = _scrollController.position.haveDimensions;
      } catch (e) {
        isReady = false;
      }
    }

    if (isReady) {
      _startSpinning(targetIndex);
    } else {
      // 防無窮迴圈 (試超過 100 次就放棄)
      if (attempt > 100) return;
      // 下一幀再試
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => _tryStartSpinning(targetIndex, attempt + 1));
    }
  }
  // ------------------

  void _startSpinning(int targetIndex) {
    // 播放震動
    HapticFeedback.mediumImpact();

    _scrollController
        .animateToItem(
      targetIndex,
      // [修改] 時間延長至 4500ms，曲線改為 easeOutQuart (比 Quint 平緩一點)
      duration: const Duration(milliseconds: 4500),
      curve: Curves.easeOutQuart,
    )
        .then((_) {
      _onSpinEnd();
    });
  }

  void _onSpinEnd() {
    if (!mounted) return;
    HapticFeedback.heavyImpact(); // 停止時重震動
    setState(() {
      _isSpinning = false;
    });
    // 稍微延遲一點點再噴紙花，更有驚喜感
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _confettiController.play();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // 單一 Item 高度
    const double itemHeight = 180.0;

    return CommonAlertDialog(
      title: t.D11_random_result.title,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // [修改] 滾輪區域容器
          Container(
            height: itemHeight,
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: colorScheme.surface, // [修改] 淺灰跑道背景
              borderRadius: BorderRadius.circular(20),
            ),
            clipBehavior: Clip.hardEdge,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 1. 高亮選取框 (Selection Highlight) - 位於中間
                // [修改] 改為純白卡片 + 陰影
                Container(
                  height: itemHeight, // 比 item 稍小，製造內縮感
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.1), // [修改] 純白背景
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.black.withValues(alpha: 0.05), // [修改] 極淡陰影
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),

                // 2. 垂直滾輪 (The Reel)
                Positioned.fill(
                  child: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: const [
                          Colors.transparent, // 上方透明 (被遮住)
                          Colors.black, // 中間顯示
                          Colors.black,
                          Colors.transparent, // 下方透明
                        ],
                        stops: const [0.0, 0.2, 0.8, 1.0],
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.dstIn,
                    child: RepaintBoundary(
                      child: ListWheelScrollView.useDelegate(
                        controller: _scrollController,
                        itemExtent: itemHeight,
                        renderChildrenOutsideViewport: false,
                        perspective: 0.002, // [修改] 更扁平的透視感
                        diameterRatio: 1.5,
                        physics: const NeverScrollableScrollPhysics(),
                        clipBehavior: Clip.hardEdge,
                        childDelegate: ListWheelChildBuilderDelegate(
                          childCount: _displayList.length,
                          builder: (context, index) {
                            if (index < 0 || index >= _displayList.length) {
                              return null;
                            }
                            final member = _displayList[index];
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CommonAvatar(
                                    avatarId: member.memberData.avatar,
                                    name: member.memberData.displayName,
                                    isLinked: member.memberData.isLinked,
                                    radius: 48, // [修改] 適中大小
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    member.memberData.displayName,
                                    style:
                                        theme.textTheme.titleMedium?.copyWith(
                                      color: colorScheme.onSurface,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                // 3. 紙花 (Confetti) - 疊在最上層
                Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                    shouldLoop: false,
                    // [修改] 使用 App 品牌色
                    colors: [
                      colorScheme.primary, // 酒紅
                      colorScheme.tertiary, // 森綠
                      AppTheme.starGold, // 金色
                      colorScheme.outline, // 淺灰 (增加層次)
                    ],
                    emissionFrequency: 0.02,
                    numberOfParticles: 25,
                    gravity: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // Actions 只保留關閉按鈕 (動畫結束後顯示)
      actions: [
        AppButton(
          text: t.D11_random_result.buttons.close,
          type: AppButtonType.primary,
          onPressed: !_isSpinning ? () => context.pop() : null,
        ),
      ],
    );
  }
}
