import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'router/app_router.dart';
import 'ui/favorite/favorite_manager.dart';
import 'ui/cart/cart_manager.dart';
import 'ui/address/address_manager.dart';
import 'ui/product/product_manager.dart';
import 'ui/order/order_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Đảm bảo dotenv load xong trước khi tạo AuthProvider
  await dotenv.load(fileName: '.env');

  runApp(const CoffeeApp());
}

class CoffeeApp extends StatefulWidget {
  const CoffeeApp({super.key});

  @override
  State<CoffeeApp> createState() => _CoffeeAppState();
}

class _CoffeeAppState extends State<CoffeeApp> {
  // Tạo AuthProvider ở đây — sau khi dotenv đã load
  late final AuthProvider _authProvider;
  late final _router;

  @override
  void initState() {
    super.initState();
    _authProvider = AuthProvider();
    _router = createAppRouter(_authProvider);
  }

  @override
  void dispose() {
    _authProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _authProvider),
        ChangeNotifierProvider(create: (_) => FavoriteManager()),
        ChangeNotifierProvider(create: (_) => CartManager()),
        ChangeNotifierProvider(create: (_) => AddressManager()),
        ChangeNotifierProvider(create: (_) => ProductManager()),
        ChangeNotifierProvider(create: (_) => OrderManager()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Coffee Shop',
        theme: ThemeData(
          useMaterial3: true,
          primaryColor: const Color(0xFF6F4E37),
        ),
        routerConfig: _router,
      ),
    );
  }
}