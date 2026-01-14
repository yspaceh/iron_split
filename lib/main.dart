import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iron_split/routing/app_router.dart';
import 'package:iron_split/firebase_options.dart'; // 確保您已生成此檔案

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. 初始化 Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const IronSplitApp());
}

class IronSplitApp extends StatefulWidget {
  const IronSplitApp({super.key});

  @override
  State<IronSplitApp> createState() => _IronSplitAppState();
}

class _IronSplitAppState extends State<IronSplitApp> {
  final _deepLinkService = DeepLinkService();
  StreamSubscription? _linkSubscription;

  @override
  void initState() {
    super.initState();
    // 在 App 啟動時掛載監聽器
    _setupDeepLinkListener();
  }

  void _setupDeepLinkListener() {
    // 1. 監聽導航意圖
    _linkSubscription = _deepLinkService.intentStream.listen((intent) {
      if (!mounted) return;

      switch (intent) {
        case JoinTaskIntent(:final code):
          // 解析到邀請碼，導向 p7
          _router.push('/invite/confirm?code=$code');
          break;
        case SettlementIntent(:final taskId):
          // 解析到結算 ID，導向結算頁
          _router.push('/tasks/$taskId/settlement');
          break;
        case UnknownIntent():
          break;
      }
    });

    // 2. 處理 App 徹底關閉後被點擊連結的情況 (Cold Start)
    _deepLinkService.handleInitialLink();
  }

  @override
  void dispose() {
    // 重要：釋放資源以符合專業開發規範
    _linkSubscription?.cancel();
    _deepLinkService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Iron Split',
      routerConfig: AppRouter.router,
      // 3. 設計系統：品牌色票
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF9C393F), // 品牌酒紅色
          primary: const Color(0xFF9C393F),
          surface: const Color(0xFFFFFBFF),
        ),
      ),
      // 設定多國語言支援 (針對中、日、英)
      // localizationsDelegates: [ ... ],
      debugShowCheckedModeBanner: false,
    );
  }
}

// 4. 關鍵畫面：處理背景匿名登入
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _handleStartupLogic();
  }

  Future<void> _handleStartupLogic() async {
    try {
      // 背景自動匿名登入，確保後續操作都有 UID
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        await FirebaseAuth.instance.signInAnonymously();
      }

      // 模擬加載時間（展現艾隆・魯斯特品牌意象）
      await Future.delayed(const Duration(seconds: 2));

      // 導向邏輯：此處可加入判斷使用者是否已同意 ToS
      if (mounted) {
        context.go('/tos'); 
      }
    } catch (e) {
      debugPrint("Firebase Auth Error: $e");
      // 錯誤處理邏輯
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 之後替換為艾隆・魯斯特 Assets 圖片
            const Icon(Icons.Bakery_dining, size: 80, color: Colors.white),
            const SizedBox(height: 24),
            Text(
              "IRON SPLIT",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 16),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}