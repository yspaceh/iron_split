import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:iron_split/gen/strings.g.dart';

/// Page Key: S71_Settings.Tos
class S71SettingsTermsPage extends StatefulWidget {
  final bool isTerms;
  final bool isEmbedded; // [新增] 是否為嵌入模式

  const S71SettingsTermsPage({
    super.key,
    required this.isTerms,
    this.isEmbedded = false, // 預設為獨立頁面 (false)
  });

  @override
  State<S71SettingsTermsPage> createState() => _S71SettingsTermsPageState();
}

class _S71SettingsTermsPageState extends State<S71SettingsTermsPage> {
  late final WebViewController _controller;
  bool _isLoading = true;

  // TODO: 請確認這是您的 Project ID
  static const String _firebaseProjectId = 'iron-split';

  @override
  void initState() {
    super.initState();
    // 初始化 WebView
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent) // 透明背景，適應外部
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            if (mounted) setState(() => _isLoading = false);
          },
        ),
      );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadRemoteContent();
  }

  // 監聽父層傳來的 isTerms 變化 (這點對 Tab 切換很重要)
  @override
  void didUpdateWidget(covariant S71SettingsTermsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isTerms != widget.isTerms) {
      _loadRemoteContent();
    }
  }

  void _loadRemoteContent() {
    // 開始載入時顯示轉圈圈
    setState(() => _isLoading = true);

    final String folder = widget.isTerms ? 'terms' : 'privacy';
    final Locale locale = Localizations.localeOf(context);

    // 簡單的語言對應邏輯
    String filename = 'en_us';
    if (locale.languageCode == 'zh') {
      filename = 'zh_tw';
    } else if (locale.languageCode == 'ja') {
      filename = 'ja_jp';
    }

    // Cache Busting (加上時間戳記避免快取)
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final String urlString =
        'https://$_firebaseProjectId.web.app/legal/$folder/$filename.html?v=$timestamp';

    _controller.loadRequest(Uri.parse(urlString));
  }

  @override
  Widget build(BuildContext context) {
    // 內容本體
    final content = Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_isLoading) const Center(child: CircularProgressIndicator()),
      ],
    );

    // [重點] 如果是嵌入模式，直接回傳內容，不要 Scaffold
    if (widget.isEmbedded) {
      return content;
    }

    // 獨立頁面模式 (保留原本邏輯)
    final title = widget.isTerms
        ? t.common.terms.label.terms
        : t.common.terms.label.privacy;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: content,
    );
  }
}
