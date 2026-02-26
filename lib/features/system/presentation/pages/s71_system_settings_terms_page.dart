import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/features/common/presentation/view/common_state_view.dart';
import 'package:iron_split/features/system/presentation/viewmodels/s71_system_settings_terms_vm.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:iron_split/gen/strings.g.dart';

class S71SettingsTermsPage extends StatelessWidget {
  final bool isTerms;
  final bool isEmbedded;

  const S71SettingsTermsPage({
    super.key,
    required this.isTerms,
    this.isEmbedded = false,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => S71SystemSettingsTermsViewModel(),
      child: _S71Content(isTerms: isTerms, isEmbedded: isEmbedded),
    );
  }
}

/// Page Key: S71_Settings.Tos
class _S71Content extends StatefulWidget {
  final bool isTerms;
  final bool isEmbedded;

  const _S71Content({required this.isTerms, required this.isEmbedded});

  @override
  State<_S71Content> createState() => _S71ContentState();
}

class _S71ContentState extends State<_S71Content> {
  late final WebViewController _controller;
  late final S71SystemSettingsTermsViewModel _vm;
  bool _hasFetched = false;

  void _injectTextScaleIntoWebView() {
    if (!mounted) return;

    // 1. 取得 Flutter 目前的字體放大倍率
    // 利用 scale(100) 的小技巧：如果倍率是 1.35，算出來就是 135；如果是 3.0，就是 300。
    final scalePercent = MediaQuery.textScalerOf(context).scale(100).toInt();

    // 2. 透過 JavaScript 動態修改網頁 body 的 fontSize
    // 加上 '-webkit-text-size-adjust: none' 防止 iOS Safari 雞婆二次縮放
    final jsString = '''
      document.body.style.fontSize = '$scalePercent%';
      document.body.style.webkitTextSizeAdjust = 'none';
    ''';

    _controller.runJavaScript(jsString);
  }

  @override
  void initState() {
    super.initState();
    _vm = context.read<S71SystemSettingsTermsViewModel>();
    // 初始化 WebView
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          // 當網頁載入完成時觸發
          onPageFinished: (String url) {
            _injectTextScaleIntoWebView();
          },
        ),
      )
      ..setBackgroundColor(Colors.transparent);
    _vm.addListener(_onStateChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 在這裡取得 Locale 並觸發 VM init
    if (!_hasFetched) {
      _hasFetched = true;
      // 1. 先安全地取得 Locale (此時 Context 已經準備好)
      final locale = Localizations.localeOf(context);

      // 2. 把會觸發 notifyListeners() 的動作推遲到下一幀 (Frame)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _vm.init(widget.isTerms, locale);
      });
    }
  }

  // 監聽並反應狀態 (載入 URL)
  void _onStateChanged() {
    if (!mounted) return;
    if (_vm.initStatus == LoadStatus.success && _vm.targetUrl != null) {
      _controller.loadRequest(Uri.parse(_vm.targetUrl!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<S71SystemSettingsTermsViewModel>();
    final t = Translations.of(context);
    // 內容本體
    final content = WebViewWidget(controller: _controller);

    // [重點] 如果是嵌入模式，直接回傳內容，不要 Scaffold
    if (widget.isEmbedded) {
      return content;
    }

    // 獨立頁面模式 (保留原本邏輯)
    final title = widget.isTerms
        ? t.common.terms.label.terms
        : t.common.terms.label.privacy;
    final leading = IconButton(
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
      onPressed: () => context.pop(),
    );

    return CommonStateView(
      status: vm.initStatus,
      errorCode: vm.initErrorCode,
      title: title,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          centerTitle: true,
          leading: leading,
        ),
        body: content,
      ),
    );
  }
}
