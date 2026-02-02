import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/cupertino.dart';

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

  void initialize() {
    // [修正] app_links v6+ 不需要手動呼叫 getInitialLink
    // uriLinkStream 現在會自動發送初始連結 (Cold Start)
    _appLinks.uriLinkStream.listen(
      _onNewUri,
      onError: (err) {
        // TODO: 處理錯誤
        debugPrint('DeepLink Error: $err');
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
      // iron-split://join?code=12345678
      if (uri.host == 'join') {
        final code = query['code'];
        if (code != null && code.length == 8) {
          return JoinTaskIntent(code);
        }
      }

      // Case 2: [新增] Settlement / Task Detail
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

  // [新增] 產生連結的方法 (供 ViewModel 呼叫)
  // 因為目前沒有 Domain，我們產生 Custom Scheme 格式
  String generateTaskLink(String taskId) {
    return "iron-split://task?id=$taskId";
  }

  String generateJoinLink(String inviteCode) {
    return "iron-split://join?code=$inviteCode";
  }

  void dispose() => _controller.close();
}
