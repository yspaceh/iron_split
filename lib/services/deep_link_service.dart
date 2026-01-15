// lib/services/deep_link_service.dart
import 'dart:async';
import 'package:app_links/app_links.dart';

// 保持 Sealed class，這對未來擴充極有幫助
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
    _appLinks.uriLinkStream.listen(_onNewUri);
    handleInitialLink(); // 處理冷啟動
  }

  Future<void> handleInitialLink() async {
    final uri = await _appLinks.getInitialAppLink();
    if (uri != null) _onNewUri(uri);
  }

  void _onNewUri(Uri uri) {
    final uriString = uri.toString();
    final now = DateTime.now();

    // 800ms 去重邏輯
    if (_lastUri == uriString &&
        _lastTime != null &&
        now.difference(_lastTime!).inMilliseconds < 800) {
      return;
    }

    _lastUri = uriString;
    _lastTime = now;
    _controller.add(_parseUri(uri));
  }

  DeepLinkIntent _parseUri(Uri uri) {
    // 根據專案聖經規範解析
    // 優先支援 HTTPS 連結 (Firebase Dynamic Links / Universal Links)
    if (uri.path == '/join' || uri.queryParameters.containsKey('code')) {
      final code = uri.queryParameters['code'];
      if (code != null && code.length == 8) return JoinTaskIntent(code);
    }
    
    // 原本的 Custom Scheme 作為備援
    if (uri.scheme == 'iron-split' && uri.host == 'join') {
      final code = uri.queryParameters['code'];
      if (code != null) return JoinTaskIntent(code);
    }
    
    return UnknownIntent();
  }

  void dispose() => _controller.close();
}