import 'package:barcode_scan2/gen/protos/protos.pbenum.dart';
import 'package:barcode_scan2/model/scan_options.dart';
import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';

class S18TaskJoinViewModel extends ChangeNotifier {
  final TextEditingController codeController = TextEditingController();
  bool get isInputValid => codeController.text.trim().length == 8;

  S18TaskJoinViewModel() {
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

  Future<String?> startScan() async {
    try {
      final result = await BarcodeScanner.scan(
        options: const ScanOptions(
          restrictFormat: [BarcodeFormat.qr],
        ),
      );

      if (result.type == ResultType.Barcode && result.rawContent.isNotEmpty) {
        return result.rawContent;
      }
      return null;
    } on PlatformException catch (e, stackTrace) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        throw AppErrorCodes.cameraPermissionDenied;
      }
      FirebaseCrashlytics.instance.recordError(
        e,
        stackTrace,
        reason: 'BarcodeScanner 原生掃描發生 PlatformException',
      );
      throw AppErrorCodes.scanFailed;
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stackTrace,
        reason: 'BarcodeScanner 發生非預期錯誤',
      );
      throw AppErrorCodes.scanFailed;
    }
  }

  @override
  void dispose() {
    codeController.removeListener(_onInputChanged);
    codeController.dispose();
    super.dispose();
  }
}
