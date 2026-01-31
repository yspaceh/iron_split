import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:iron_split/core/services/deep_link_service.dart';
import 'package:iron_split/features/record/data/record_repository.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:provider/provider.dart';

// 核心配置與服務
import 'package:iron_split/gen/strings.g.dart';
import 'package:iron_split/core/router/app_router.dart';
import 'package:iron_split/core/theme/app_theme.dart'; // 導入定義好的主題
import 'package:iron_split/firebase_options.dart';

// 狀態管理
import 'package:iron_split/features/onboarding/application/pending_invite_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化 Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        // 1. 注入 TaskRepository
        Provider<TaskRepository>(
          create: (_) => TaskRepository(),
        ),
        // 2. 注入 RecordRepository
        Provider<RecordRepository>(
          create: (_) => RecordRepository(),
        ),
        // 註冊 PendingInviteProvider 並執行 init
        ChangeNotifierProvider(create: (_) => PendingInviteProvider()..init()),
      ],
      // 封裝 slang 語系供應器
      child: TranslationProvider(child: const IronSplitApp()),
    ),
  );
}

class IronSplitApp extends StatefulWidget {
  const IronSplitApp({super.key});

  @override
  State<IronSplitApp> createState() => _IronSplitAppState();
}

class _IronSplitAppState extends State<IronSplitApp> {
  final DeepLinkService _deepLinkService = DeepLinkService();
  late final AppRouter _appRouter;
  StreamSubscription? _linkSubscription;

  @override
  void initState() {
    super.initState();
    // 修正點：現在 AppRouter 接收 deepLinkService 作為參數
    _appRouter = AppRouter(_deepLinkService);
    _setupDeepLinkListener();
  }

  /// 設置 Deep Link 監聽邏輯
  void _setupDeepLinkListener() {
    _deepLinkService.initialize();

    _linkSubscription = _deepLinkService.intentStream.listen((intent) {
      if (!mounted) return;

      switch (intent) {
        case JoinTaskIntent(:final code):
          // 儲存邀請碼至 Provider 中斷恢復機制
          context.read<PendingInviteProvider>().saveInvite(code);

          // 若已登入則直接跳轉至 S04 確認頁面
          if (FirebaseAuth.instance.currentUser != null) {
            _appRouter.router.push('/invite/confirm?code=$code');
          }
          break;

        case SettlementIntent(:final taskId):
          // 導向結算頁面
          _appRouter.router.push('/tasks/$taskId/settlement');
          break;

        default:
          break;
      }
    });

    // 處理 App 啟動時的初始連結
    _deepLinkService.handleInitialLink();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    _deepLinkService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 使用 MaterialApp.router 整合 GoRouter
    return MaterialApp.router(
      title: 'Iron Split',
      // 設定語系支援
      locale: TranslationProvider.of(context).flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,

      // 路由配置
      routerConfig: _appRouter.router,

      // 主題配置：使用 AppTheme 中定義的 M3 酒紅色主題
      theme: AppTheme.lightTheme,

      debugShowCheckedModeBanner: false,
    );
  }
}
