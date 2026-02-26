import 'package:flutter/material.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/gen/strings.g.dart';

class DisplayState {
  final bool isEnlarged;
  final double scale;
  DisplayState({
    required this.isEnlarged,
    required this.scale,
  });
}

class DisplayConstants {
  // 定義顯示大小
  static const DisplayMode defaultDisplay = DisplayMode.system;

  // 定義清單 (直接使用 Enum)
  static const List<DisplayMode> allDisplays = [
    DisplayMode.system,
    DisplayMode.enlarged,
    DisplayMode.standard,
  ];

  // Helper: 取得顯示名稱
  static String getLabel(BuildContext context, DisplayMode locale) {
    final t = Translations.of(context);
    switch (locale) {
      case DisplayMode.system:
        return t.common.display.system;
      case DisplayMode.enlarged:
        return t.common.display.enlarged;
      case DisplayMode.standard:
        return t.common.display.standard;
    }
  }
}
