import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // 1. 背景匿名登入
      final userCredential = await FirebaseAuth.instance.signInAnonymously();
      debugPrint("Signed in with UID: ${userCredential.user?.uid}");

      // 2. 模擬初始化延遲，顯示吉祥物意象
      await Future.delayed(const Duration(seconds: 2));

      // 3. 檢查是否有 Pending Invite (這部分下一階段實作 Deep Link)
      // 目前預設導向 Home
      if (mounted) context.go('/home');
    } catch (e) {
      debugPrint("Auth Error: $e");
      // 錯誤處理...
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 之後放置艾隆·魯斯特 (Iron Rooster) 吉祥物
            Icon(Icons.BakeryDining, size: 80, color: Colors.blue), 
            SizedBox(height: 20),
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text("Iron Split 正在準備中...", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}