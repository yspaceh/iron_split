import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 注意：此處需放入您在 Firebase Console 產生的 firebase_options.dart
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const IronSplitApp());
}

final GoRouter _router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    // 預留 MVP 要求的路由
    GoRoute(path: '/tos', builder: (context, state) => const Scaffold(body: Center(child: Text("ToS (p1)")))),
    GoRoute(path: '/home', builder: (context, state) => const Scaffold(body: Center(child: Text("Home")))),
  ],
);

class IronSplitApp extends StatelessWidget {
  const IronSplitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      theme: ThemeData(
        useMaterial3: true, // 強制使用 M3
        colorSchemeSeed: Colors.blue,
      ),
      title: 'Iron Split',
    );
  }
}