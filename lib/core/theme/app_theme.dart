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

  static const _orangeRed = Color(0xFFFF3B30);

  // [最終定案] 文字色階 (Pure Greyscale)
  // Level 1: 重 (標題) - 接近純黑，極高對比
  static const _obsidian = Color(0xFF212121);

  // Level 2: 中 (次要文字/未選中) - 純中性灰，不帶藍也不帶紅
  // 這是搭配 #212121 最平衡的顏色
  static const _mediumGrey = Color(0xFF616161);
  static const _darkGrey = Color(0xFF333333);

  // 收入色
  static const _incomeGreen = Color(0xFF2E7D32);
  static const _incomeBg = Color(0xFFE8F5E9);

  static const Color expenseDeep = Color(0xFF5D2226); // 深栗色 (Dark Maroon)
  static const Color incomeDeep = Color(0xFF1B4E22); // 深松綠 (Deep Pine)
  static const Color expenseLight = Color(0xFFE57373);
  static const Color incomeLight = Color(0xFF81C784);
  static const Color darkGray = Color(0xFF2C2C2C);
  static const Color starGold = Color(0xFFFBC02D);

  // --- Dark Mode 專用調色盤 ---
  // 背景：Material 推薦的標準深色背景 #121212
  static const _darkBg = Color(0xFF121212);
  // 卡片/對話框表面：比背景稍亮，營造層次感
  static const _darkSurface = Color(0xFF1E1E1E);
  // 邊框：深灰，低調的邊界
  static const _darkBorder = Color(0xFF333333);
  // 文字：淺灰白 (避免純白刺眼)
  static const _textPrimaryDark = Color(0xFFE0E0E0);
  // 次要文字：中灰
  static const _textSecondaryDark = Color(0xFFA0A0A0);
  // 輸入框背景
  static const _inputFillDark = Color(0xFF2C2C2C);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Roboto',

      // 1. 色彩計畫
      colorScheme: ColorScheme.fromSeed(
        seedColor: _ironWine,

        surface: _pureWhite,
        onSurface: _obsidian,

        error: _orangeRed,
        errorContainer: _orangeRed.withValues(alpha: 0.1),

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

      datePickerTheme: DatePickerThemeData(
        backgroundColor: _pureWhite, // 背景純白
        surfaceTintColor: Colors.transparent, // 移除 M3 預設染色

        // 標頭區域 (上方顯示年份日期的區塊)
        // 設為白色背景 + 深色文字，符合 "Cool & Crisp" 風格
        headerBackgroundColor: _pureWhite,
        headerForegroundColor: _obsidian,

        // 形狀：對齊 DialogTheme (24px 圓角 + 邊框)
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: _neutralGrey, width: 1),
        ),

        // 日曆中選中日期的樣式
        dayStyle: const TextStyle(fontFamily: 'Roboto', color: _obsidian),
        todayBorder: const BorderSide(color: _ironWine), // 今天的日期加框
        todayForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.white;
          return _ironWine;
        }),

        // 按鈕顏色 (Cancel/OK)
        cancelButtonStyle: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          minimumSize: const Size(120, 44), // 高度 40
          side: BorderSide(color: _neutralGrey),
          foregroundColor: _ironWine,
          shape: const StadiumBorder(),
        ),
        confirmButtonStyle: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          minimumSize: const Size(120, 44), // 高度 40
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
        bodyMedium: TextStyle(color: _obsidian),
        labelLarge: TextStyle(color: _obsidian, fontWeight: FontWeight.w600),
      ),
      snackBarTheme: SnackBarThemeData(
        // 1. 行為：懸浮 (Floating)
        behavior: SnackBarBehavior.floating,

        // 2. 形狀：16px 圓角
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),

        // 3. 位置與間距：留白讓它看起來像浮起來的膠囊
        // 注意：如果下方有 FAB 或 NavigationBar，Flutter 會自動避開
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

        // 4. 預設顏色：使用深灰色 (Inverse Surface) 搭配白字
        // 這樣在白底 App 上對比度最高，看起來最乾淨
        backgroundColor: _darkGrey,
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),

        // 5. 陰影：稍微加一點點，增加層次感
        elevation: 4,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _ironWine,
        foregroundColor: Colors.white,

        // 關鍵：將所有狀態的陰影都設為 0
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,

        // 形狀：保持圓潤的膠囊狀 (Stadium)
        shape: const StadiumBorder(),

        // 如果您希望它跟背景有點區隔，可以加一點點幾乎看不見的邊框，
        // 但因為酒紅色很深，其實不加邊框對比也夠了。
        // shape: StadiumBorder(
        //   side: BorderSide(color: _ironWine.withOpacity(0.1), width: 1),
        // ),

        // 文字樣式 (對齊 ElevatedButton)
        extendedTextStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16,
          letterSpacing: 0.5, // 稍微加一點字距讓它更好看
        ),

        // 調整大小與間距 (Extended FAB 預設有點大，我們可以微調)
        extendedPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
  }

  // --- 新增 Dark Theme ---
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Roboto',
      brightness: Brightness.dark, // 關鍵：告訴 Flutter 這是深色模式

      // 色彩計畫 (Dark Mode)
      colorScheme: ColorScheme.fromSeed(
        seedColor: _ironWine,
        brightness: Brightness.dark,

        surface: _darkSurface, // 背景
        onSurface: _textPrimaryDark, // 主要文字

        error: const Color(0xFFCF6679), // M3 預設的深色模式紅
        errorContainer: const Color(0xFFB00020),

        // 次要內容：淺灰
        onSurfaceVariant: _textSecondaryDark,

        // 容器
        surfaceContainerHighest: _darkSurface,
        surfaceContainerLow: _darkBg,

        // 邊框
        outline: _darkBorder,
        outlineVariant: _darkBorder.withValues(alpha: 0.5),

        primary: _ironWine, // 保持品牌色
        onPrimary: Colors.white,

        // 收入綠色 (稍微調亮一點以適應深色背景)
        tertiary: const Color(0xFF66BB6A),
        tertiaryContainer: const Color(0xFF1B5E20),
        onTertiaryContainer: Colors.white,

        // 反向表面 (SnackBar 等) -> 變成淺色
        inverseSurface: const Color(0xFFE0E0E0),
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
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: _darkBorder, width: 1),
        ),
      ),

      // Button (Dark)
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

      // Input (Dark)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _inputFillDark, // 深灰輸入框
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _ironWine, width: 1.5),
        ),
        hintStyle: const TextStyle(color: _textSecondaryDark),
      ),

      // Dialog (Dark)
      dialogTheme: DialogThemeData(
        backgroundColor: _darkSurface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: _darkBorder, width: 1),
        ),
        titleTextStyle: const TextStyle(
          color: _textPrimaryDark,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        contentTextStyle:
            const TextStyle(color: _textPrimaryDark, fontSize: 16),
      ),

      // DatePicker (Dark)
      datePickerTheme: DatePickerThemeData(
        backgroundColor: _darkSurface,
        surfaceTintColor: Colors.transparent,
        headerBackgroundColor: _darkSurface,
        headerForegroundColor: _textPrimaryDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: _darkBorder, width: 1),
        ),
        dayStyle:
            const TextStyle(fontFamily: 'Roboto', color: _textPrimaryDark),
        yearStyle:
            const TextStyle(fontFamily: 'Roboto', color: _textPrimaryDark),
        weekdayStyle:
            const TextStyle(fontFamily: 'Roboto', color: _textSecondaryDark),
        todayBorder: const BorderSide(color: _ironWine),
        todayForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.white;
          return _ironWine;
        }),
        cancelButtonStyle: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          minimumSize: const Size(120, 44),
          side: const BorderSide(color: _darkBorder),
          foregroundColor: _ironWine,
          shape: const StadiumBorder(),
        ),
        confirmButtonStyle: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          minimumSize: const Size(120, 44),
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
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
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
          borderRadius: BorderRadius.circular(16),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        backgroundColor: const Color(0xFFE0E0E0), // 淺灰底
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
        extendedPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
  }
}
