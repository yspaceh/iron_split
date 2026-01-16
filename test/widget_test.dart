// test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// 修正：路徑必須與 pubspec.yaml 的 name 一致，且指向正確的 iron_split
import 'package:iron_split/main.dart'; 

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // 修正：將 MyApp() 改為你在 main.dart 定義的 IronSplitApp()
    await tester.pumpWidget(const IronSplitApp());

    // 注意：目前的 IronSplitApp 會先進入 SplashScreen 進行匿名登入
    // 這裡的測試邏輯仍保留原始樣板，若未來需要寫正式測試再根據 UI 調整
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}