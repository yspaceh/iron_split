import 'package:flutter/material.dart';

/// 專案主題管理類別 (Modern Minimalist / Cool & Crisp)
/// - 核心：主色酒紅 (#9C393F)
/// - 修正：文字全系列採用純粹的黑白灰階，徹底消除色偏
/// - 風格：微邊框 + 純白卡片 + 膠囊按鈕
class AppTheme {
  // --- 1. 私有調色盤 ---

  // 品牌主色 (Iron Wine)
  static const _ironWine = Color(0xFF9C393F);

  // 冷灰系背景 (保持不變)
  static const _slateBg = Color(0xFFF4F6F8);
  static const _pureWhite = Color(0xFFFFFFFF);
  static const _neutralGrey = Color(0xFFE0E3E5); // 邊框/底色用淺灰

  // [最終定案] 文字色階 (Pure Greyscale)
  // Level 1: 重 (標題) - 接近純黑，極高對比
  static const _obsidian = Color(0xFF212121);

  // Level 2: 中 (次要文字/未選中) - 純中性灰，不帶藍也不帶紅
  // 這是搭配 #212121 最平衡的顏色
  static const _mediumGrey = Color(0xFF616161);

  // 收入色
  static const _incomeGreen = Color(0xFF2E7D32);
  static const _incomeBg = Color(0xFFE8F5E9);

  static const Color expenseDeep = Color(0xFF5D2226); // 深栗色 (Dark Maroon)
  static const Color incomeDeep = Color(0xFF1B4E22); // 深松綠 (Deep Pine)

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Roboto',

      // 1. 色彩計畫
      colorScheme: ColorScheme.fromSeed(
        seedColor: _ironWine,

        surface: _pureWhite,
        onSurface: _obsidian,

        // --- 關鍵修正區 ---
        // 強制指定次要內容為純中性灰 (#616161)
        // 這會直接影響 CustomSlidingSegment 的未選中文字顏色
        onSurfaceVariant: _mediumGrey,

        // 背景與容器
        surfaceContainerHighest: _neutralGrey,
        surfaceContainerLow: _slateBg,

        // 邊框
        outline: _neutralGrey,
        outlineVariant: _neutralGrey.withValues(alpha: 0.7),

        primary: _ironWine,
        onPrimary: Colors.white,

        tertiary: _incomeGreen,
        tertiaryContainer: _incomeBg,
        onTertiaryContainer: _incomeGreen,
      ),

      scaffoldBackgroundColor: _slateBg,

      appBarTheme: const AppBarTheme(
        backgroundColor: _slateBg,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: _obsidian,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(color: _obsidian),
      ),

      cardTheme: CardThemeData(
        color: _pureWhite,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: _neutralGrey, width: 1),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _ironWine,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _pureWhite,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _neutralGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _ironWine, width: 1.5),
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: _pureWhite,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: _neutralGrey, width: 1),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: _pureWhite,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),

      // 文字排版：統一使用黑與中性灰
      textTheme: const TextTheme(
        displayMedium: TextStyle(
            color: _obsidian, fontWeight: FontWeight.w800, letterSpacing: -1.0),
        headlineMedium: TextStyle(
            color: _obsidian, fontWeight: FontWeight.w700, letterSpacing: -0.5),
        titleLarge: TextStyle(color: _obsidian, fontWeight: FontWeight.w700),
        titleMedium: TextStyle(color: _obsidian, fontWeight: FontWeight.w600),

        // 內文
        bodyLarge: TextStyle(color: _obsidian),
        // 次要資訊：使用 #616161，清晰且不搶戲
        bodyMedium: TextStyle(color: _mediumGrey),
        labelLarge: TextStyle(color: _obsidian, fontWeight: FontWeight.w600),
      ),
    );
  }
}
