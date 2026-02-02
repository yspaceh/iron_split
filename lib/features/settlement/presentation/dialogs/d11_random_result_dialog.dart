import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Haptics
import 'package:iron_split/core/models/settlement_model.dart';
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
      barrierDismissible: false, // 強制使用者看動畫或按 Skip
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
  bool _isSpinning = true;
  bool _showConfetti = false; // 控制慶祝特效

  // 為了模擬無限滾動，我們將原始名單重複多次
  // 30次重複足夠支撐約 3-4 秒的高速旋轉
  static const int _loopCount = 40;
  late List<SettlementMember> _displayList;

  @override
  void initState() {
    super.initState();

    // 1. 準備顯示清單 (重複名單)
    _displayList = [];
    for (int i = 0; i < _loopCount; i++) {
      _displayList.addAll(widget.members);
    }

    // 2. 計算目標索引 (Target Index)
    // 我們希望停在列表後段的某個 winner 位置，確保有足夠的滾動空間
    final int winnerBaseIndex =
        widget.members.indexWhere((m) => m.id == widget.winnerId);
    // 讓它停在倒數第 5 輪的位置
    final int targetRound = _loopCount - 5;
    final int targetIndex =
        (targetRound * widget.members.length) + winnerBaseIndex;

    _scrollController = FixedExtentScrollController(initialItem: 0);

    // 3. 啟動動畫 (延遲一點點讓 UI 先 render)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startSpinning(targetIndex);
    });
  }

  void _startSpinning(int targetIndex) {
    // 播放震動
    HapticFeedback.mediumImpact();

    _scrollController
        .animateToItem(
      targetIndex,
      // [關鍵]: 時間越長 + easeOutQuint = 快速旋轉後慢慢煞車的效果
      duration: const Duration(milliseconds: 3500),
      curve: Curves.easeOutQuint,
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
      _showConfetti = true; // 觸發慶祝狀態
    });
  }

  void _onSkip() {
    // 立即停止動畫，跳到結果
    _scrollController
        .jumpToItem(_scrollController.selectedItem); // 停止目前位置 (非準確)
    // 重新定位到最近的一個 winner
    // 這裡簡單處理：直接呼叫結束邏輯，外部 S32 會顯示正確結果
    // 為了視覺連貫，我們可以瞬間 jump 到最後一個 winner 的位置
    // 但因為 Skip 就是不想看，直接 close 也可以
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // 單一 Item 高度
    const double itemHeight = 70.0;

    return AlertDialog(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: colorScheme.surfaceTint,
      contentPadding: const EdgeInsets.symmetric(vertical: 24, horizontal: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      title: Text(
        _isSpinning
            ? t.D11_random_result.title
            : t.D11_random_result.winner_reveal,
        textAlign: TextAlign.center,
        style: theme.textTheme.headlineSmall
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        height: 250, // 滾輪可視高度
        width: 300,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 1. 高亮選取框 (Selection Highlight) - 位於中間
            Container(
              height: itemHeight + 12, // 比 item 稍高
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: colorScheme.tertiaryContainer
                    .withValues(alpha: 0.4), // 半透明強調色
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.tertiary.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
            ),

            // 2. 指針 (Indicators) - 左右兩側的箭頭
            Positioned(
              left: 8,
              child: Icon(Icons.arrow_right,
                  size: 32, color: colorScheme.tertiary),
            ),
            Positioned(
              right: 8,
              child:
                  Icon(Icons.arrow_left, size: 32, color: colorScheme.tertiary),
            ),

            // 3. 垂直滾輪 (The Reel)
            ListWheelScrollView.useDelegate(
              controller: _scrollController,
              itemExtent: itemHeight,
              perspective: 0.005, // 3D 透視感 (越小越平)
              diameterRatio: 1.5, // 圓筒直徑比例
              physics: const NeverScrollableScrollPhysics(), // 禁止手動滑動，只能程式控制
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: _displayList.length,
                builder: (context, index) {
                  final member = _displayList[index];
                  return Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CommonAvatar(
                          avatarId: member.avatar,
                          name: member.displayName,
                          isLinked: member.isLinked,
                          radius: 40,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          member.displayName,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        if (_isSpinning)
          TextButton(
            onPressed: _onSkip,
            child: Text(t.D11_random_result.skip),
          )
        else
          AppButton(
            text: t.D11_random_result.buttons.close,
            type: AppButtonType.primary,
            onPressed: () => Navigator.pop(context),
          ),
      ],
    );
  }
}
