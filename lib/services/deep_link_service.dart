import 'dart:async';
import 'package:app_links/app_links.dart';

// 1. 定義導航意圖 (Intent)
sealed class DeepLinkIntent {
  const DeepLinkIntent();
}

class JoinTaskIntent extends DeepLinkIntent {
  final String code; // 8位大寫邀請碼
  JoinTaskIntent(this.code);
}

class SettlementIntent extends DeepLinkIntent {
  final String taskId; // 結算任務 ID
  SettlementIntent(this.taskId);
}

class UnknownIntent extends DeepLinkIntent {}

// 2. 封裝服務層，隔離第三方套件
class DeepLinkService {
  final _appLinks = AppLinks();
  final _controller = StreamController<DeepLinkIntent>.broadcast();
  
  // 實作 800ms 去重邏輯所需變數
  String? _lastUri;
  DateTime? _lastTime;

  Stream<DeepLinkIntent> get intentStream => _controller.stream;

  DeepLinkService() {
    // 監聽 App 在背景時被喚起的連結
    _appLinks.uriLinkStream.listen(_onNewUri);
  }

  /// 處理冷啟動 (Cold Start)，即 App 徹底關閉時點擊連結
  Future<void> handleInitialLink() async {
    final uri = await _appLinks.getInitialAppLink();
    if (uri != null) _onNewUri(uri);
  }

  void _onNewUri(Uri uri) {
    final uriString = uri.toString();
    final now = DateTime.now();

    // 實作 800ms 去重 (Dedupe)
    if (_lastUri == uriString &&
        _lastTime != null &&
        now.difference(_lastTime!).inMilliseconds < 800) {
      return;
    }

    _lastUri = uriString;
    _lastTime = now;
    _controller.add(_parseUri(uri));
  }

  // 解析 URI 邏輯
  DeepLinkIntent _parseUri(Uri uri) {
    // 規範: iron-split://join?code=XXXXXXXX
    if (uri.scheme == 'iron-split' && uri.host == 'join') {
      final code = uri.queryParameters['code'];
      if (code != null) return JoinTaskIntent(code);
    }
    
    // 規範: iron-split://settlement?taskId=XXXX
    if (uri.scheme == 'iron-split' && uri.host == 'settlement') {
      final taskId = uri.queryParameters['taskId'];
      if (taskId != null) return SettlementIntent(taskId);
    }
    
    return UnknownIntent();
  }

  void dispose() => _controller.close();
}