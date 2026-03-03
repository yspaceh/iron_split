import 'package:flutter/material.dart';

class S18TaskEnterCodeViewModel extends ChangeNotifier {
  final TextEditingController codeController = TextEditingController();
  bool get isInputValid => codeController.text.trim().length == 8;

  S18TaskEnterCodeViewModel() {
    codeController.addListener(_onInputChanged);
  }

  void _onInputChanged() {
    notifyListeners();
  }

  /// 核心解析邏輯：從掃描到的字串中榨出 8 碼邀請碼
  String? parseScannedData(String rawData) {
    // 1. 嘗試以 URL 解析 (相容 DeepLink 與 Web Link)
    try {
      final uri = Uri.parse(rawData);
      // 情境 A: iron-split://join?code=ABCDEFGH
      if (uri.queryParameters.containsKey('code')) {
        final code = uri.queryParameters['code']!;
        if (code.length == 8) return code.toUpperCase();
      }
      // 情境 B: https://iron-split.web.app/join/ABCDEFGH
      if (uri.pathSegments.isNotEmpty) {
        final lastSegment = uri.pathSegments.last;
        if (lastSegment.length == 8) return lastSegment.toUpperCase();
      }
    } catch (_) {
      // 不是合法的 URL，往下走純文字檢查
    }

    // 2. 情境 C: 使用者直接掃描只包含 8 碼純文字的條碼
    final cleanData = rawData.trim().toUpperCase();
    if (RegExp(r'^[A-Z0-9]{8}$').hasMatch(cleanData)) {
      return cleanData;
    }

    return null; // 不是我們的邀請碼
  }

  @override
  void dispose() {
    codeController.removeListener(_onInputChanged);
    codeController.dispose();
    super.dispose();
  }
}
