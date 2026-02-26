import 'package:flutter/material.dart';
import 'package:iron_split/core/theme/app_layout.dart';

/// 專案主題管理類別 (Modern Minimalist / Cool & Crisp)
/// - 核心：主色酒紅 (#9C393F)
/// - 修正：文字全系列採用純粹的黑白灰階，徹底消除色偏
/// - 風格：微邊框 + 純白卡片 + 膠囊按鈕
class AppTheme {
  // --- 1. 私有調色盤 ---

  // 品牌主色 (Iron Wine)
  static const _ironWine = Color(0xFF9C393F);

  // 冷灰系背景
  static const _slateBg = Color(0xFFF4F6F8);
  static const _pureWhite = Color(0xFFFFFFFF);
  static const _neutralGrey = Color(0xFFE0E3E5);
  static const _orangeRed = Color(0xFFFF3B30);

  // 文字色階 (Pure Greyscale)
  static const _obsidian = Color(0xFF212121);
  static const _mediumGrey = Color(0xFF616161);
  static const _darkGrey = Color(0xFF333333);

  // 收入色
  static const _prepayGreen = Color(0xFF2E7D32);
  static const _prepayBg = Color(0xFFE8F5E9);

  // --- Dark Mode 專用調色盤 ---
  static const _darkBg = Color(0xFF121212);
  static const _darkSurface = Color(0xFF1E1E1E);
  static const _darkBorder = Color(0xFF333333);
  static const _textPrimaryDark = Color(0xFFE0E0E0);
  static const _textSecondaryDark = Color(0xFFA0A0A0);
  static const _inputFillDark = Color(0xFF2C2C2C);
  static const _darkOrangeRed = Color(0xFFCF6679);
  static const _darkPrepayGreen = Color(0xFF66BB6A);
  static const _darkPrepayBg = Color(0xFF1B5E20);

  static const Color expenseDeep = Color(0xFF5D2226); // 深栗色 (Dark Maroon)
  static const Color prepayDeep = Color(0xFF1B4E22); // 深松綠 (Deep Pine)
  static const Color expenseLight = Color(0xFFE57373);
  static const Color prepayLight = Color(0xFF81C784);
  static const Color darkGray = Color(0xFF2C2C2C);
  static const Color starGold = Color(0xFFFBC02D);

  // --- 2. 系統化建構邏輯 ---

  /// 建構動態行高 (遵循 WCAG 2.1 無障礙規範)
  static TextTheme _buildTextTheme(TextTheme base, bool isEnlarged) {
    // 確立唯一的真理基底：Flutter 原生標準行高 1.2
    const double baseLineHeight = 1.2;
    // 透過 AppLayout 引擎計算全域行高 (標準: 1.2, 放大: 1.32)
    final double globalLineHeight = AppLayout.dynamicLineHeight(
      baseLineHeight,
      isEnlarged,
    );

    return base.copyWith(
      displayMedium: base.displayMedium
          ?.copyWith(height: globalLineHeight, letterSpacing: -1.0),
      headlineMedium: base.headlineMedium
          ?.copyWith(height: globalLineHeight, letterSpacing: -0.5),
      titleLarge: base.titleLarge?.copyWith(height: globalLineHeight),
      titleMedium: base.titleMedium?.copyWith(height: globalLineHeight),
      bodyLarge: base.bodyLarge?.copyWith(height: globalLineHeight),
      bodyMedium: base.bodyMedium?.copyWith(height: globalLineHeight),
      labelLarge: base.labelLarge?.copyWith(height: globalLineHeight),
      labelMedium: base.labelMedium?.copyWith(height: globalLineHeight),
    );
  }

  /// 獲取全域主題 (將 AppLayout 邏輯注入)
  static ThemeData getTheme({required bool isDark, required bool isEnlarged}) {
    final ThemeData baseTheme = isDark ? _darkThemeData : _lightThemeData;

    return baseTheme.copyWith(
      // 1. 動態文字行高
      textTheme: _buildTextTheme(baseTheme.textTheme, isEnlarged),

      // 2. 動態 AppBar 高度 (基於 8px 網格)
      // M3 標準：56px (7 grid) | 放大模式給予更多呼吸空間：72px (9 grid)
      appBarTheme: baseTheme.appBarTheme.copyWith(
        toolbarHeight: AppLayout.gridUnit * (isEnlarged ? 9 : 7),
      ),

      // 3. 全域基礎輸入框 Padding
      // 給系統預設的 TextField 使用 (AppTextField 內有自己更精密的推算)
      inputDecorationTheme: baseTheme.inputDecorationTheme.copyWith(
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppLayout.spaceL, // 16px
          vertical: isEnlarged
              ? AppLayout.spaceXL
              : AppLayout.spaceL, // 放大時 24px，標準 16px
        ),
      ),
    );
  }

  static final ThemeData _lightThemeData = ThemeData(
    useMaterial3: true,
    fontFamily: 'Roboto',

    // 1. 色彩計畫
    colorScheme: ColorScheme.fromSeed(
      seedColor: _ironWine,
      surface: _pureWhite,
      onSurface: _obsidian,
      error: _orangeRed,
      errorContainer: _orangeRed.withValues(alpha: 0.1),
      onSurfaceVariant: _mediumGrey,
      surfaceContainerHighest: _neutralGrey,
      surfaceContainerLow: _slateBg,
      outline: _neutralGrey,
      outlineVariant: _neutralGrey.withValues(alpha: 0.7),
      primary: _ironWine,
      onPrimary: Colors.white,
      tertiary: _prepayGreen,
      tertiaryContainer: _prepayBg,
      onTertiaryContainer: Colors.white,
      inverseSurface: _darkGrey,
      onInverseSurface: Colors.white,
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
        borderRadius: BorderRadius.circular(AppLayout.radiusXL),
        side: const BorderSide(color: _neutralGrey, width: 1),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _ironWine,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: AppLayout.spaceXL, // 24px
          vertical: AppLayout.spaceM,
        ),
        minimumSize: const Size.fromHeight(AppLayout.gridUnit * 5),
        shape: const StadiumBorder(),
        textStyle: const TextStyle(
            fontWeight: FontWeight.w700, fontSize: AppLayout.spaceL),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _pureWhite,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppLayout.radiusL),
        borderSide: const BorderSide(color: _neutralGrey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppLayout.radiusL),
        borderSide: const BorderSide(color: _ironWine, width: 1.5),
      ),
    ),

    dialogTheme: DialogThemeData(
      backgroundColor: _pureWhite,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppLayout.radiusXXL),
        side: const BorderSide(color: _neutralGrey, width: 1),
      ),
    ),

    datePickerTheme: DatePickerThemeData(
      backgroundColor: _pureWhite,
      surfaceTintColor: Colors.transparent,
      headerBackgroundColor: _pureWhite,
      headerForegroundColor: _obsidian,

      // 形狀：對齊 DialogTheme (24px 圓角 + 邊框)
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppLayout.radiusXXL),
        side: const BorderSide(color: _neutralGrey, width: 1),
      ),
      dayStyle: const TextStyle(fontFamily: 'Roboto', color: _obsidian),
      todayBorder: const BorderSide(color: _ironWine), // 今天的日期加框
      todayForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return Colors.white;
        return _ironWine;
      }),

      // 按鈕顏色 (Cancel/OK)
      cancelButtonStyle: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: AppLayout.spaceXL),
        minimumSize: const Size(120, AppLayout.gridUnit * 5),
        side: BorderSide(color: _neutralGrey),
        foregroundColor: _ironWine,
        shape: const StadiumBorder(),
      ),
      confirmButtonStyle: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: AppLayout.spaceXL),
        minimumSize: const Size(120, AppLayout.gridUnit * 5),
        backgroundColor: _ironWine,
        foregroundColor: Colors.white,
        shape: const StadiumBorder(),
        elevation: 0, // M3 FilledButton 預設無陰影
      ),
    ),

    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: _pureWhite,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppLayout.gridUnit * 3.5)),
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
      bodyLarge: TextStyle(color: _obsidian),
      bodyMedium: TextStyle(color: _obsidian),
      labelLarge: TextStyle(color: _obsidian, fontWeight: FontWeight.w600),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppLayout.radiusL),
      ),
      insetPadding: const EdgeInsets.symmetric(
          horizontal: AppLayout.spaceL, vertical: AppLayout.spaceL),
      backgroundColor: _darkGrey,
      contentTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      elevation: 4,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _ironWine,
      foregroundColor: Colors.white,
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      shape: const StadiumBorder(),
      extendedTextStyle: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 16,
        letterSpacing: 0.5, // 稍微加一點字距讓它更好看
      ),
      extendedPadding: const EdgeInsets.symmetric(
          horizontal: AppLayout.spaceXL, vertical: AppLayout.spaceL),
    ),
  );

  // --- 新增 Dark Theme ---
  static final ThemeData _darkThemeData = ThemeData(
    useMaterial3: true,
    fontFamily: 'Roboto',
    brightness: Brightness.dark,

    // 色彩計畫 (Dark Mode)
    colorScheme: ColorScheme.fromSeed(
      seedColor: _ironWine,
      brightness: Brightness.dark,
      surface: _darkSurface, // 背景
      onSurface: _textPrimaryDark, // 主要文字
      error: _darkOrangeRed,
      errorContainer: _darkOrangeRed.withValues(alpha: 0.1),
      onSurfaceVariant: _textSecondaryDark,
      surfaceContainerHighest: _darkSurface,
      surfaceContainerLow: _darkBg,
      outline: _darkBorder,
      outlineVariant: _darkBorder.withValues(alpha: 0.5),
      primary: _ironWine, // 保持品牌色
      onPrimary: Colors.white,
      tertiary: _darkPrepayGreen,
      tertiaryContainer: _darkPrepayBg,
      onTertiaryContainer: Colors.white,
      inverseSurface: _textPrimaryDark,
      onInverseSurface: _darkBg,
    ),

    scaffoldBackgroundColor: _darkBg,

    // AppBar (Dark)
    appBarTheme: const AppBarTheme(
      backgroundColor: _darkBg,
      scrolledUnderElevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: _textPrimaryDark,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      iconTheme: IconThemeData(color: _textPrimaryDark),
    ),

    // Card (Dark)
    cardTheme: CardThemeData(
      color: _darkSurface, // 深色卡片
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppLayout.radiusXL),
        side: const BorderSide(color: _darkBorder, width: 1),
      ),
    ),

    // Button (Dark)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _ironWine,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: AppLayout.spaceXL,
          vertical: AppLayout.spaceM,
        ),
        minimumSize: const Size.fromHeight(AppLayout.gridUnit * 5),
        shape: const StadiumBorder(),
        textStyle: const TextStyle(
            fontWeight: FontWeight.w700, fontSize: AppLayout.radiusL),
      ),
    ),

    // Input (Dark)
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _inputFillDark, // 深灰輸入框
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppLayout.radiusL),
        borderSide: const BorderSide(color: _darkBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppLayout.radiusL),
        borderSide: const BorderSide(color: _ironWine, width: 1.5),
      ),
      hintStyle: const TextStyle(color: _textSecondaryDark),
    ),

    // Dialog (Dark)
    dialogTheme: DialogThemeData(
      backgroundColor: _darkSurface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppLayout.radiusXXL),
        side: const BorderSide(color: _darkBorder, width: 1),
      ),
      titleTextStyle: const TextStyle(
        color: _textPrimaryDark,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
      contentTextStyle: const TextStyle(color: _textPrimaryDark, fontSize: 16),
    ),

    // DatePicker (Dark)
    datePickerTheme: DatePickerThemeData(
      backgroundColor: _darkSurface,
      surfaceTintColor: Colors.transparent,
      headerBackgroundColor: _darkSurface,
      headerForegroundColor: _textPrimaryDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppLayout.radiusXXL),
        side: const BorderSide(color: _darkBorder, width: 1),
      ),
      dayStyle: const TextStyle(fontFamily: 'Roboto', color: _textPrimaryDark),
      yearStyle: const TextStyle(fontFamily: 'Roboto', color: _textPrimaryDark),
      weekdayStyle:
          const TextStyle(fontFamily: 'Roboto', color: _textSecondaryDark),
      todayBorder: const BorderSide(color: _ironWine),
      todayForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return Colors.white;
        return _ironWine;
      }),
      cancelButtonStyle: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: AppLayout.spaceXL),
        minimumSize: const Size(120, AppLayout.gridUnit * 5),
        side: const BorderSide(color: _darkBorder),
        foregroundColor: _ironWine,
        shape: const StadiumBorder(),
      ),
      confirmButtonStyle: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: AppLayout.spaceXL),
        minimumSize: const Size(120, AppLayout.gridUnit * 5),
        backgroundColor: _ironWine,
        foregroundColor: Colors.white,
        shape: const StadiumBorder(),
        elevation: 0,
      ),
    ),

    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: _darkSurface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppLayout.gridUnit * 3.5)),
      ),
    ),

    // Text (Dark) - 全部反白
    textTheme: const TextTheme(
      displayMedium: TextStyle(
          color: _textPrimaryDark,
          fontWeight: FontWeight.w800,
          letterSpacing: -1.0),
      headlineMedium: TextStyle(
          color: _textPrimaryDark,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5),
      titleLarge:
          TextStyle(color: _textPrimaryDark, fontWeight: FontWeight.w700),
      titleMedium:
          TextStyle(color: _textPrimaryDark, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(color: _textPrimaryDark),
      bodyMedium: TextStyle(color: _textPrimaryDark),
      labelLarge:
          TextStyle(color: _textPrimaryDark, fontWeight: FontWeight.w600),
      labelMedium: TextStyle(color: _textSecondaryDark),
    ),

    // SnackBar (Dark) - 為了對比，深色模式下的 SnackBar 改用淺灰底黑字
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppLayout.radiusL),
      ),
      insetPadding: const EdgeInsets.symmetric(
          horizontal: AppLayout.spaceL, vertical: AppLayout.spaceL),
      backgroundColor: _textPrimaryDark, // 淺灰底
      contentTextStyle: const TextStyle(
        color: _obsidian, // 深黑字
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      elevation: 4,
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _ironWine,
      foregroundColor: Colors.white,
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      shape: StadiumBorder(),
      extendedTextStyle: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 16,
        letterSpacing: 0.5,
      ),
      extendedPadding: EdgeInsets.symmetric(
          horizontal: AppLayout.spaceXL, vertical: AppLayout.spaceL),
    ),
  );
}
