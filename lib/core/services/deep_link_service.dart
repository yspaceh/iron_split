import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:iron_split/core/constants/app_constants.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/services/logger_service.dart';

// 保持 Sealed class 定義，確保對應 AppRouter 的 Intent 解析
sealed class DeepLinkIntent {
  const DeepLinkIntent();
}

class JoinTaskIntent extends DeepLinkIntent {
  final String code;
  JoinTaskIntent(this.code);
}

class SettlementIntent extends DeepLinkIntent {
  final String taskId;
  SettlementIntent(this.taskId);
}

class UnknownIntent extends DeepLinkIntent {}

abstract class DeepLinkSource {
  Future<Uri?> getInitialLink();
  Stream<Uri> get uriLinkStream;
}

class AppLinksDeepLinkSource implements DeepLinkSource {
  final AppLinks _appLinks;

  AppLinksDeepLinkSource([AppLinks? appLinks])
      : _appLinks = appLinks ?? AppLinks();

  @override
  Future<Uri?> getInitialLink() => _appLinks.getInitialLink();

  @override
  Stream<Uri> get uriLinkStream => _appLinks.uriLinkStream;
}

class DeepLinkService {
  final LoggerService _loggerService;
  final DeepLinkSource _source;
  final _controller = StreamController<DeepLinkIntent>.broadcast();

  String? _lastUri;
  DateTime? _lastTime;

  DeepLinkService({LoggerService? loggerService, DeepLinkSource? source})
      : _loggerService = loggerService ?? LoggerService.instance,
        _source = source ?? AppLinksDeepLinkSource();

  Stream<DeepLinkIntent> get intentStream => _controller.stream;

// 將原本的 void 改為 Future<void>，並加上 async
  Future<void> initialize() async {
    // 1. 強制手動抓取冷啟動 (Cold Start) 連結
    // 這是為了彌補 main() 裡面 Firebase 初始化的時間差
    try {
      final initialUri = await _source.getInitialLink();
      if (initialUri != null) {
        _onNewUri(initialUri);
      }
    } catch (e, stackTrace) {
      _recordErrorSafely(
        e,
        stackTrace,
        reason: 'DeepLinkService - initialize: Failed to get initial link',
      );
      throw AppErrorCodes.initFailed;
    }

    // 2. 監聽熱啟動 (Warm Start) 與後續連結
    _source.uriLinkStream.listen(
      (uri) {
        _onNewUri(uri);
      },
      onError: (e, stackTrace) {
        _recordErrorSafely(
          e,
          stackTrace,
          reason: 'DeepLinkService - initialize: Stream error',
        );
        _controller.addError(AppErrorCodes.initFailed);
      },
    );
  }

  /// 提供給測試或防禦性呼叫：安全處理原始字串連結
  /// 任何格式錯誤都不拋出，避免未捕捉例外造成崩潰。
  void handleRawLink(String rawLink) {
    try {
      final uri = Uri.parse(rawLink);
      _onNewUri(uri);
    } catch (e, stackTrace) {
      _recordErrorSafely(
        e,
        stackTrace,
        reason: 'DeepLinkService - handleRawLink: Invalid raw deep link string',
      );
    }
  }

  void _recordErrorSafely(
    Object error,
    StackTrace stackTrace, {
    String? reason,
  }) {
    try {
      _loggerService.recordError(error, stackTrace, reason: reason);
    } catch (_) {
      // 測試環境或 Firebase 未初始化時，忽略記錄失敗，避免影響主流程。
    }
  }

  void _onNewUri(Uri uri) {
    final uriString = uri.toString();
    final now = DateTime.now();

    // 保持你原本設定的 800ms 去重邏輯
    if (_lastUri == uriString &&
        _lastTime != null &&
        now.difference(_lastTime!).inMilliseconds < 800) {
      return;
    }

    _lastUri = uriString;
    _lastTime = now;
    final intent = _parseUri(uri);
    if (intent is! UnknownIntent) {
      _controller.add(intent);
    }
  }

  DeepLinkIntent _parseUri(Uri uri) {
    // 取得 Query Parameters
    final query = uri.queryParameters;

    // --- Custom Scheme 處理 (iron-split://) ---
    if (uri.scheme == AppConstants.scheme || uri.scheme == 'https') {
      // Case 1: Join Task
      if (uri.host == 'join' || uri.path == '/join') {
        final code = query['code'];
        if (code != null && code.isNotEmpty) {
          return JoinTaskIntent(code);
        }
      }

      // Case 2:  Settlement / Task Detail
      // iron-split://task?id=TASK_ID_HERE
      if (uri.path.startsWith('/locked/')) {
        final segments = uri.pathSegments;
        if (segments.length >= 2 &&
            segments[0] == 'locked' &&
            segments[1].isNotEmpty) {
          return SettlementIntent(segments[1]);
        }
      }
      return UnknownIntent();
    }

    // 如果未來有 HTTPS 網域，可以加在這裡作為備援
    // if (uri.scheme == 'https' ... )

    return UnknownIntent();
  }

  //  產生連結的方法 (供 ViewModel 呼叫)
  String generateSettlementLink(String taskId) {
    return "${AppConstants.baseUrl}/locked/$taskId";
  }

  String generateJoinLink(String inviteCode) {
    return "${AppConstants.baseUrl}/join?code=$inviteCode";
  }

  void dispose() => _controller.close();
}
