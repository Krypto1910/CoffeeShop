import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../presentation/auth/splash_page.dart';
import '../presentation/auth/login_page.dart';
import '../presentation/home/home_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashPage()),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/home', builder: (context, state) => const HomePage()),
  ],
);
