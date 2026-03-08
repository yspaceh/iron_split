import 'dart:async';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:iron_split/core/constants/app_constants.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/services/analytics_service.dart';
import 'package:iron_split/core/services/deep_link_service.dart';
import 'package:iron_split/core/services/logger_service.dart';
import 'package:iron_split/core/services/preferences_service.dart';
import 'package:iron_split/core/viewmodels/display_vm.dart';
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
import 'package:iron_split/features/task/data/services/activity_log_service.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:provider/provider.dart';

// 核心配置與服務
import 'package:iron_split/gen/strings.g.dart';
import 'package:iron_split/core/router/app_router.dart';
import 'package:iron_split/core/theme/app_theme.dart';
import 'package:iron_split/firebase_options_dev.dart' as dev;
import 'package:iron_split/firebase_options_prod.dart' as prod;

// 狀態管理
import 'package:iron_split/features/onboarding/application/pending_invite_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const environment = String.fromEnvironment('ENV', defaultValue: 'dev');

  final firebaseOptions = environment == 'prod'
      ? prod.DefaultFirebaseOptions.currentPlatform
      : dev.DefaultFirebaseOptions.currentPlatform;

  // 初始化 Firebase
  if (Firebase.apps.isEmpty) {
    try {
      await Firebase.initializeApp(
        options: firebaseOptions,
      );
    } catch (e) {
      if (e.toString().contains('duplicate-app')) {
        // 故意留空：靜靜地攔截這個錯誤，什麼都不做
      } else {
        rethrow;
      }
    }
  } else {
    // 如果已經存在，直接使用現有的
    Firebase.app();
  }

  // 讀取儲存的語言設定
  final prefs = await SharedPreferences.getInstance();
  final savedLocaleCode = prefs.getString('app_locale');

  if (savedLocaleCode != null) {
    final locale = AppLocaleUtils.parse(savedLocaleCode);
    LocaleSettings.setLocale(locale);
  } else {
    // 跟隨系統
    LocaleSettings.useDeviceLocale();
  }

  final loggerService = LoggerService.instance;

  // 捕獲 Flutter 框架內的錯誤
  FlutterError.onError = (errorDetails) {
    loggerService.recordError(
      errorDetails.exception,
      errorDetails.stack ?? StackTrace.current,
      reason: 'main.dart - FlutterError.onError',
    );
  };

  // 捕獲非同步錯誤（例如未處理的 Future error）
  PlatformDispatcher.instance.onError = (error, stack) {
    loggerService.recordError(
      error,
      stack,
      reason: 'main.dart - PlatformDispatcher.onError',
    );
    return true;
  };

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await FirebaseAppCheck.instance.activate(
    providerAndroid: kDebugMode
        ? AndroidDebugProvider()
        : AndroidPlayIntegrityProvider(), // 正式環境用 Play Integrity

    providerApple: kDebugMode
        ? AppleDebugProvider()
        : AppleAppAttestProvider(), // 正式環境用 App Attest
  );

  runApp(
    MultiProvider(
      providers: [
        Provider<LoggerService>.value(
          value: loggerService,
        ),
        Provider<ActivityLogService>(
          create: (context) => ActivityLogService(
            context.read<LoggerService>(),
          ),
        ),
        Provider<TaskRepository>(
          create: (context) =>
              TaskRepository(loggerService: context.read<LoggerService>()),
        ),
        Provider<RecordRepository>(
          create: (context) =>
              RecordRepository(loggerService: context.read<LoggerService>()),
        ),
        Provider<AuthRepository>(
          create: (context) =>
              AuthRepository(loggerService: context.read<LoggerService>()),
        ),
        Provider<InviteRepository>(
          create: (context) =>
              InviteRepository(loggerService: context.read<LoggerService>()),
        ),
        Provider<AnalyticsService>.value(
          value: AnalyticsService.instance,
        ),
        Provider<OnboardingService>(
          create: (context) => OnboardingService(
            authRepo: context.read<AuthRepository>(),
            inviteRepo: context.read<InviteRepository>(),
            analyticsService: context.read<AnalyticsService>(),
            loggerService: context.read<LoggerService>(),
          ),
        ),
        Provider<DashboardService>(
          create: (context) => DashboardService(context.read<LoggerService>()),
        ),
        Provider<TaskService>(
          create: (context) => TaskService(
            taskRepo: context.read<TaskRepository>(),
            analyticsService: context.read<AnalyticsService>(),
            loggerService: context.read<LoggerService>(),
          ),
        ),
        Provider<RecordService>(
          create: (context) => RecordService(
            context.read<RecordRepository>(),
            context.read<TaskRepository>(),
            context.read<AnalyticsService>(),
            context.read<LoggerService>(),
          ),
        ),
        Provider<SettlementService>(
          create: (context) => SettlementService(context.read<TaskRepository>(),
              context.read<AnalyticsService>(), context.read<LoggerService>()),
        ),
        Provider<ExportService>(
          create: (context) => ExportService(),
        ),
        Provider<ShareService>(
          create: (context) => ShareService(
              context.read<InviteRepository>(), context.read<LoggerService>()),
        ),
        Provider<DeepLinkService>(
          create: (context) => DeepLinkService(),
        ),
        Provider<PreferencesService>(
          create: (context) => PreferencesService(
            prefs,
            loggerService: context.read<LoggerService>(),
          ),
        ),
        // 註冊 SystemRepository
        // 使用 ProxyProvider 因為它依賴上面的 PreferencesService
        ProxyProvider<PreferencesService, SystemRepository>(
          update: (context, prefsService, previous) =>
              previous ??
              SystemRepository(prefsService, context.read<LoggerService>()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              ThemeViewModel(loggerService: context.read<LoggerService>()),
        ),
        ChangeNotifierProvider(
            create: (context) => DisplayViewModel(
                  analyticsService: context.read<AnalyticsService>(),
                  loggerService: context.read<LoggerService>(),
                )),
        ChangeNotifierProvider(
            create: (context) => LocaleViewModel(
                  analyticsService: context.read<AnalyticsService>(),
                  loggerService: context.read<LoggerService>(),
                )),
        // 註冊 PendingInviteProvider 並執行 init
        ChangeNotifierProvider(
            create: (context) =>
                PendingInviteProvider(context.read<LoggerService>())..init()),
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
          // 儲存邀請碼至 Provider 中斷恢復機制
          context.read<PendingInviteProvider>().saveInvite(code);

          // 若已登入則直接跳轉至 S04 確認頁面
          if (FirebaseAuth.instance.currentUser != null) {
            _appRouter.router.push('/join?code=$code');
          }
          break;

        case SettlementIntent(:final taskId):
          // 導向結算頁面
          _appRouter.router.push('/locked/$taskId');
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
    final displayVm = context.watch<DisplayViewModel>();
    final displayMode = displayVm.displayMode;
    final systemTextScaler = MediaQuery.textScalerOf(context);
    final systemScale = systemTextScaler.scale(1.0);

    final bool isEnlargedActive = displayMode == DisplayMode.enlarged ||
        (displayMode == DisplayMode.system &&
            systemScale > AppConstants.enlargedScale);
    final TextScaler safeTextScaler;
    if (isEnlargedActive) {
      // 放大顯示模式：允許字體放到很大，例如 2.0 倍
      safeTextScaler = systemTextScaler.clamp(maxScaleFactor: 2.0);
    } else {
      // 標準顯示模式：鎖定在 1.2 倍，保護精緻 UI 不破版
      safeTextScaler = systemTextScaler.clamp(maxScaleFactor: 1.2);
    }

    final double finalSafeScale = safeTextScaler.scale(1.0);
    // 使用 MaterialApp.router 整合 GoRouter
    return MaterialApp.router(
      title: 'Iron Split',
      locale: localeVm.currentLocale.flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      routerConfig: _appRouter.router,
      theme: AppTheme.getTheme(isDark: false, isEnlarged: isEnlargedActive),
      darkTheme: AppTheme.getTheme(isDark: true, isEnlarged: isEnlargedActive),
      themeMode: themeVm.themeMode,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return Provider<DisplayState>.value(
          value:
              DisplayState(isEnlarged: isEnlargedActive, scale: finalSafeScale),
          child: MediaQuery(
            // 覆寫系統的 textScaler 為我們計算好的 safeTextScaler
            data: MediaQuery.of(context).copyWith(textScaler: safeTextScaler),
            child: child!,
          ),
        );
      },
    );
  }
}
