import 'dart:async';
import 'dart:ui';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:iron_split/core/services/deep_link_service.dart';
import 'package:iron_split/core/services/preferences_service.dart';
import 'package:iron_split/core/viewmodels/locale_vm.dart';
import 'package:iron_split/core/viewmodels/theme_vm.dart';
import 'package:iron_split/features/onboarding/application/onboarding_service.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/onboarding/data/invite_repository.dart';
import 'package:iron_split/features/record/application/record_service.dart';
import 'package:iron_split/features/record/data/record_repository.dart';
import 'package:iron_split/features/settlement/application/settlement_service.dart';
import 'package:iron_split/features/system/data/system_repository.dart';
import 'package:iron_split/features/task/application/dashboard_service.dart';
import 'package:iron_split/features/task/application/export_service.dart';
import 'package:iron_split/features/task/application/share_service.dart';
import 'package:iron_split/features/task/application/task_service.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:provider/provider.dart';

// 核心配置與服務
import 'package:iron_split/gen/strings.g.dart';
import 'package:iron_split/core/router/app_router.dart';
import 'package:iron_split/core/theme/app_theme.dart'; // 導入定義好的主題
import 'package:iron_split/firebase_options.dart';

// 狀態管理
import 'package:iron_split/features/onboarding/application/pending_invite_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化 Firebase
  final results = await Future.wait([
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    SharedPreferences.getInstance(),
  ]);

  // 讀取儲存的語言設定
  final prefs = results[1] as SharedPreferences;
  final savedLocaleCode = prefs.getString('app_locale');

  if (savedLocaleCode != null) {
    final locale = AppLocaleUtils.parse(savedLocaleCode);
    LocaleSettings.setLocale(locale);
  } else {
    // 跟隨系統
    LocaleSettings.useDeviceLocale();
  }

  // 捕獲 Flutter 框架內的錯誤
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  // 捕獲非同步錯誤（例如未處理的 Future error）
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(
    MultiProvider(
      providers: [
        Provider<TaskRepository>(
          create: (_) => TaskRepository(),
        ),
        Provider<RecordRepository>(
          create: (_) => RecordRepository(),
        ),
        Provider<AuthRepository>(
          create: (_) => AuthRepository(),
        ),
        Provider<InviteRepository>(
          create: (_) => InviteRepository(),
        ),
        Provider<OnboardingService>(
          create: (context) =>
              OnboardingService(authRepo: context.read<AuthRepository>()),
        ),
        Provider<DashboardService>(
          create: (_) => DashboardService(),
        ),
        Provider<TaskService>(
          create: (context) =>
              TaskService(taskRepo: context.read<TaskRepository>()),
        ),
        Provider<RecordService>(
          create: (context) => RecordService(
              context.read<RecordRepository>(), context.read<TaskRepository>()),
        ),
        Provider<SettlementService>(
          create: (context) =>
              SettlementService(context.read<TaskRepository>()),
        ),
        Provider<ExportService>(
          create: (context) => ExportService(),
        ),
        Provider<ShareService>(
          create: (context) => ShareService(),
        ),
        Provider<DeepLinkService>(
          create: (context) => DeepLinkService(),
        ),
        Provider<PreferencesService>(
          create: (_) => PreferencesService(prefs),
        ),
        // ✅ [新增] 註冊 SystemRepository
        // 使用 ProxyProvider 因為它依賴上面的 PreferencesService
        ProxyProvider<PreferencesService, SystemRepository>(
          update: (context, prefsService, previous) =>
              previous ?? SystemRepository(prefsService),
        ),
        ChangeNotifierProvider(create: (_) => ThemeViewModel()),
        ChangeNotifierProvider(create: (_) => LocaleViewModel()),
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
  late final AppRouter _appRouter;
  StreamSubscription? _linkSubscription;

  @override
  void initState() {
    super.initState();
    // 修正點：現在 AppRouter 接收 deepLinkService 作為參數
    final deepLinkService = context.read<DeepLinkService>();
    _appRouter = AppRouter(deepLinkService);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupDeepLinkListener(deepLinkService);
    });
  }

  /// 設置 Deep Link 監聽邏輯
  void _setupDeepLinkListener(DeepLinkService service) {
    service.initialize();

    _linkSubscription = service.intentStream.listen((intent) {
      if (!mounted) return;

      switch (intent) {
        case JoinTaskIntent(:final code):
          debugPrint("🔥 [DeepLink] JoinTaskIntent Code: $code");
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
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeVm = context.watch<ThemeViewModel>();
    final localeVm = context.watch<LocaleViewModel>();
    // 使用 MaterialApp.router 整合 GoRouter
    return MaterialApp.router(
      title: 'Iron Split',
      // 設定語系支援
      locale: localeVm.currentLocale.flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      routerConfig: _appRouter.router,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeVm.themeMode,
      debugShowCheckedModeBanner: false,
    );
  }
}
