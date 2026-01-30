import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:iron_split/features/onboarding/application/pending_invite_provider.dart';

/// Page Key: S00_System.Bootstrap
class S00SystemBootstrapPage extends StatefulWidget {
  const S00SystemBootstrapPage({super.key});
  @override
  State<S00SystemBootstrapPage> createState() => _S00SystemBootstrapPageState();
}

class _S00SystemBootstrapPageState extends State<S00SystemBootstrapPage> {
  @override
  void initState() {
    super.initState();
    _executeBootstrap();
  }

  Future<void> _executeBootstrap() async {
    await Future.delayed(const Duration(milliseconds: 800)); // 平滑過渡
    if (!mounted) return;

    final user = FirebaseAuth.instance.currentUser;
    final pendingInvite = context.read<PendingInviteProvider>().pendingCode;

    if (user == null) {
      context.go('/tos-consent');
      return;
    }

    if (user.displayName == null || user.displayName!.isEmpty) {
      context.go('/onboarding/name');
      return;
    }

    if (pendingInvite != null) {
      context.go('/invite/confirm?code=$pendingInvite');
      return;
    }

    context.go('/tasks');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: const Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }
}
