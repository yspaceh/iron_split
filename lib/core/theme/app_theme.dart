import 'package:flutter/material.dart';

/// 專案主題管理類別
/// 遵循 M3 規範、聖經 7.1 色彩定義與 Flutter 最新 API 規範
class AppTheme {
  // --- 1. 私有品牌調色盤 (Private Palette) ---
  // 艾隆・魯斯特酒紅與鄉村農場色系
  static const _ironWine = Color(0xFF9C393F);
  static const _darkGrey = Color(0xFF35343A);
  static const _softWhite = Color(0xFFFFFBFF);

  // --- 2. 公有語義化 Token (Semantic Tokens) ---
  static Color get primary => _ironWine;
  static Color get surface => _softWhite;
  static Color get onSurface => _darkGrey;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _ironWine,
        primary: _ironWine,
        onPrimary: Colors.white,
        surface: _softWhite,
        onSurface: _darkGrey,
        // 修正點：使用 .withValues(alpha: ...) 避免精度損失
        onSurfaceVariant: _darkGrey.withValues(alpha: 0.7), 
        outline: _darkGrey.withValues(alpha: 0.1),
      ),
      
      // 按鈕主題：對齊聖經 7.2 規範
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _ironWine,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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