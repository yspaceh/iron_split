import 'package:flutter/material.dart';

class SelectionIndicator extends StatelessWidget {
  final bool isSelected;
  final bool isRadio; //  控制顯示打勾還是圓點

  const SelectionIndicator({
    super.key,
    required this.isSelected,
    this.isRadio = false, // 預設為 Checkbox (打勾)
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // [修改] 尺寸縮小一點 (20 -> 18)
    const double size = 18.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          // 未選中時：灰色邊框
          // 選中時：主色邊框 (若是 Radio) 或 主色填滿 (若是 Checkbox)
          color: isSelected ? colorScheme.primary : colorScheme.outline,
          width: 2,
        ),
        // Radio 模式：選中時背景保持透明 (因為中間有實心圓)
        // Checkbox 模式：選中時背景填滿主色
        color: isSelected
            ? (isRadio ? Colors.transparent : colorScheme.primary)
            : Colors.transparent,
      ),
      child: isSelected
          ? Center(
              child: isRadio
                  ? _buildRadioDot(colorScheme.primary)
                  : _buildCheckIcon(colorScheme.onPrimary),
            )
          : null,
    );
  }

  // 繪製 Radio 的實心圓點
  Widget _buildRadioDot(Color color) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  // [修改] 使用 CustomPaint 繪製更粗的打勾線條
  Widget _buildCheckIcon(Color color) {
    return CustomPaint(
      size: const Size(6, 4), // 打勾的大小
      painter: _CheckPainter(color: color, strokeWidth: 2), // 線條加粗到 2.5
    );
  }
}

// 自定義打勾繪製器 (為了解決 Icon 線條太細的問題)
class _CheckPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _CheckPainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round; // 圓頭線條

    final path = Path();
    // 繪製打勾路徑 (相對於 10x8 的畫布)
    path.moveTo(0, size.height * 0.5);
    path.lineTo(size.width * 0.4, size.height);
    path.lineTo(size.width, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
