import 'package:flutter/material.dart';
import 'router/app_router.dart';


void main() {
  runApp(const CoffeeApp());
}

class CoffeeApp extends StatelessWidget {
  const CoffeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Coffee Shop',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF6F4E37),
      ),
      routerConfig: appRouter,
    );
  }
}