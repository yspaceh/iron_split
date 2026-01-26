import 'package:flutter/material.dart';

/// 專案主題管理類別
/// 遵循 M3 規範、聖經 7.1 色彩定義與 Flutter 最新 API 規範
class AppTheme {
  // --- 1. 私有品牌調色盤 (Private Palette) ---
  // 品牌主色 (Iron Wine)
  static const _ironWine = Color(0xFF9C393F);

  // 基礎中性色
  static const _darkGrey = Color(0xFF35343A);
  static const _softWhite = Color(0xFFFFFBFF);

  // 收入/正向色系 (Income Green) - 提取自 S13 Hardcode
  static const _incomeGreen = Color(0xFF4CAF50); // 主色
  static const _incomeGreenContainer = Color(0xFFE8F5E9); // 背景淺色
  static const _onIncomeGreenContainer = Color(0xFF2E7D32); // 深色文字/Icon

  // --- 2. 公有語義化 Token (Semantic Tokens) ---
  // 讓外部可以直接存取主要顏色 (若有特殊需求)
  static Color get primary => _ironWine;
  static Color get surface => _softWhite;
  static Color get onSurface => _darkGrey;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,

      // 定義完整的 ColorScheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: _ironWine,

        // 1. 品牌色 (Brand)
        primary: _ironWine,
        onPrimary: Colors.white,

        // 2. 背景色 (Background)
        surface: _softWhite,
        onSurface: _darkGrey,
        onSurfaceVariant: _darkGrey.withValues(alpha: 0.7),
        outline: _darkGrey.withValues(alpha: 0.1),

        // 3. 錯誤/支出色 (Expense) - 使用 M3 預設的 Error Red 或自定義
        error: const Color(0xFFBA1A1A),
        errorContainer: const Color(0xFFFFDAD6),
        onErrorContainer: const Color(0xFF410002),

        // 4. 第三色/收入色 (Income) - 映射到 Tertiary
        // 這樣在 App 任何地方使用 colorScheme.tertiary 就是「收入綠」
        tertiary: _incomeGreen,
        tertiaryContainer: _incomeGreenContainer,
        onTertiaryContainer: _onIncomeGreenContainer,
      ),

      // 按鈕主題：對齊聖經 7.2 規範
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _ironWine,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
      ),

      // 文本主題：對齊聖經 7.1 文字主色
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: _darkGrey,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
        bodyLarge: TextStyle(color: _darkGrey),
      ),
    );
  }
}
