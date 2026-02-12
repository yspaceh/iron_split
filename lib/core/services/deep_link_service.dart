import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';

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

class DeepLinkService {
  final _appLinks = AppLinks();
  final _controller = StreamController<DeepLinkIntent>.broadcast();

  String? _lastUri;
  DateTime? _lastTime;

  Stream<DeepLinkIntent> get intentStream => _controller.stream;

// 將原本的 void 改為 Future<void>，並加上 async
  Future<void> initialize() async {
    // 1. 強制手動抓取冷啟動 (Cold Start) 連結
    // 這是為了彌補 main() 裡面 Firebase 初始化的時間差
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _onNewUri(initialUri);
      }
    } catch (e) {
      throw AppErrorCodes.initFailed;
    }

    // 2. 監聽熱啟動 (Warm Start) 與後續連結
    _appLinks.uriLinkStream.listen(
      (uri) {
        _onNewUri(uri);
      },
      onError: (err) {
        _controller.addError(AppErrorCodes.initFailed);
      },
    );
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
    if (uri.scheme == 'iron-split') {
      // Case 1: Join Task
      if (uri.host == 'join') {
        final code = query['code'];
        if (code != null && code.isNotEmpty) {
          return JoinTaskIntent(code);
        }
      }

      // Case 2:  Settlement / Task Detail
      // iron-split://task?id=TASK_ID_HERE
      if (uri.host == 'task') {
        final taskId = query['id'];
        if (taskId != null && taskId.isNotEmpty) {
          return SettlementIntent(taskId);
        }
      }
    }

    // 如果未來有 HTTPS 網域，可以加在這裡作為備援
    // if (uri.scheme == 'https' ... )

    return UnknownIntent();
  }

  //  產生連結的方法 (供 ViewModel 呼叫)
  // 因為目前沒有 Domain，我們產生 Custom Scheme 格式
  String generateTaskLink(String taskId) {
    return "iron-split://task?id=$taskId";
  }

  String generateJoinLink(String inviteCode) {
    return "iron-split://join?code=$inviteCode";
  }

  void dispose() => _controller.close();
}
