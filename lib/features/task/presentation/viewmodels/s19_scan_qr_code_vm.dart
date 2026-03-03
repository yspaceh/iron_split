import 'package:flutter/material.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';

class S19TaskScanQrCodeViewModel extends ChangeNotifier {
  // 用來防止相機在短時間內連續觸發多次掃描的鎖
  bool _isScanned = false;

  /// 處理掃描到的條碼資料
  /// 成功：回傳解析後的 8 碼字串
  /// 失敗：拋出 AppErrorCodes.scanFailed
  String? processBarcode(String rawData) {
    // 如果已經在處理中，直接略過 (回傳 null 讓 UI 什麼都不做)
    if (_isScanned) return null;

    _isScanned = true; // 1. 立刻上鎖，防止重複觸發

    // 2. 解析條碼
    final cleanCode = _parseScannedData(rawData);

    if (cleanCode != null) {
      // 解析成功，把字串交還給 UI 去做導航
      return cleanCode;
    } else {
      // 解析失敗，解鎖並拋出特定的 ErrorCode 給 UI 處理
      _isScanned = false;
      throw AppErrorCodes.scanFailed;
    }
  }

  /// 核心解析邏輯：從掃描到的字串中榨出 8 碼邀請碼
  String? _parseScannedData(String rawData) {
    try {
      final uri = Uri.parse(rawData);
      if (uri.queryParameters.containsKey('code')) {
        final code = uri.queryParameters['code']!;
        if (code.length == 8) return code.toUpperCase();
      }
      if (uri.pathSegments.isNotEmpty) {
        final lastSegment = uri.pathSegments.last;
        if (lastSegment.length == 8) return lastSegment.toUpperCase();
      }
    } catch (_) {}

    final cleanData = rawData.trim().toUpperCase();
    if (RegExp(r'^[A-Z0-9]{8}$').hasMatch(cleanData)) {
      return cleanData;
    }

    return null; // 不是我們的邀請碼
  }
}
