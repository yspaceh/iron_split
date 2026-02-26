// lib/core/theme/app_layout.dart (建議新增此檔或放入 AppTheme)
class AppLayout {
  static const double gridUnit = 8.0; // 基礎網格單位

  // 垂直間距規範 (基於 M3 與 8px 網格)
  static const double spaceXS = gridUnit * 0.5; // 4px (元件內極小間隙)
  static const double spaceS = gridUnit; // 8px (緊湊間距)
  static const double spaceM = gridUnit * 1.5; // 12px (標準內邊距 - 你的 12 起源於此)
  static const double spaceL = gridUnit * 2.0; // 16px (舒適內邊距 - 你的 16 起源於此)
  static const double spaceXL = gridUnit * 2.5; // 20px (大區塊間距)
  static const double spaceXXL = gridUnit * 3.0; // 24px (大區塊間距)

// Icon 尺寸系統 (對齊 Material 3 規範)
  static const double iconSizeS = 18.0; // 小圖示 (用於按鈕內、標籤旁)
  static const double iconSizeM = 24.0; // 標準圖示 (用於 AppBar、獨立按鈕)
  static const double iconSizeL = 32.0; // 大圖示

  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 20.0;
  static const double radiusXXL = 24.0;

  /// 核心推算公式：計算文字在畫面上實際佔用的物理高度
  /// [fontSize] 原始字體大小
  /// [height] TextStyle 中的行高倍率
  /// [scale] 系統目前的 TextScaler 倍率
  static double renderedHeight(double fontSize, double? height, double scale) {
    final double effectiveHeight = height ?? 1;
    return fontSize * scale * effectiveHeight;
  }

  static double dynamicLineHeight(double baseHeight, bool isEnlarged) {
    if (isEnlarged) {
      return double.parse((baseHeight * 1.1).toStringAsFixed(2));
    }
    return baseHeight;
  }

  static double pageMargin(bool isEnlarged) {
    return isEnlarged ? spaceS : spaceL;
  }

  static double inlineIconSize(bool isEnlarged) {
    return isEnlarged ? iconSizeM : iconSizeS;
  }
}
