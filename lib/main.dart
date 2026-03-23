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
import 'ui/payment_method/payment_method_manager.dart';
import 'services/notification_service.dart';

void main() async {
  // Bắt buộc phải có để khởi tạo các binding của Flutter
  WidgetsFlutterBinding.ensureInitialized();

  print("=== [1] BẮT ĐẦU CHẠY MAIN ===");

  // 1. Kiểm tra load .env
  try {
    print("=== [2] ĐANG LOAD .ENV ===");
    await dotenv.load(fileName: '.env');
    print("=== [3] LOAD .ENV THÀNH CÔNG ===");
  } catch (e) {
    print("=== [!] LỖI LOAD .ENV: $e ===");
    print("=== (App vẫn sẽ tiếp tục chạy bỏ qua .env) ===");
  }

  // 2. Kiểm tra khởi tạo Notification (Rất dễ gây treo app nếu chưa config native)
  try {
    print("=== [4] ĐANG INIT NOTIFICATION SERVICE ===");
    // TẠM THỜI COMMENT DÒNG NÀY LẠI ĐỂ TRÁNH TREO MÀN HÌNH ĐEN
    // await NotificationService().init();
    print("=== [5] INIT NOTIFICATION (Đã bỏ qua để test) ===");
  } catch (e) {
    print("=== [!] LỖI NOTIFICATION: $e ===");
  }

  print("=== [6] CHUẨN BỊ CHẠY RUNAPP ===");

  runApp(const CoffeeApp());
}

class CoffeeApp extends StatefulWidget {
  const CoffeeApp({super.key});

  @override
  State<CoffeeApp> createState() => _CoffeeAppState();
}

class _CoffeeAppState extends State<CoffeeApp> {
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

        // 🔥 QUAN TRỌNG: thêm PaymentMethodManager
        ChangeNotifierProvider(create: (_) => PaymentMethodManager()),
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
