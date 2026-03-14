import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _waitForAuth();
  }

  Future<void> _waitForAuth() async {
    final auth = context.read<AuthProvider>();

    // Nếu đã initialized rồi thì redirect ngay
    if (auth.initialized) {
      _redirect(auth);
      return;
    }

    // Chờ AuthProvider báo initialized xong
    auth.addListener(_onAuthChange);
  }

  void _onAuthChange() {
    final auth = context.read<AuthProvider>();
    if (auth.initialized) {
      auth.removeListener(_onAuthChange);
      _redirect(auth);
    }
  }

  void _redirect(AuthProvider auth) {
    if (!mounted) return;
    if (auth.isLoggedIn) {
      context.go('/home');
    } else {
      context.go('/login');
    }
  }

  @override
  void dispose() {
    // Đảm bảo remove listener nếu widget bị dispose trước khi auth xong
    try {
      context.read<AuthProvider>().removeListener(_onAuthChange);
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF6F1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0xFF8B5E3C),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(Icons.coffee, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              'CoffeeNow',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6F4E37),
              ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(
              color: Color(0xFF8B5E3C),
              strokeWidth: 2,
            ),
          ],
        ),
      ),
    );
  }
}