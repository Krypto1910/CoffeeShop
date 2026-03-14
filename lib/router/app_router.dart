import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../ui/auth/splash_page.dart';
import '../ui/auth/login_page.dart';
import '../ui/home/home_page.dart';
import '../ui/favorite/favorite_page.dart';
import '../ui/cart/cart_page.dart';
import '../ui/profile/profile_page.dart';
import '../ui/profile/edit_profile_page.dart';
import '../ui/order/order_history_page.dart';
import '../ui/address/my_address_page.dart';
import '../ui/checkout/payment_method_page.dart';
import '../ui/checkout/checkout_page.dart';
import '../ui/checkout/order_success_page.dart';
import '../ui/product/product_detail_page.dart';
import '../ui/product/product_list_page.dart';
import '../ui/checkout/choose_address_page.dart';
import '../models/product.dart';

GoRouter createAppRouter(AuthProvider authProvider) {
  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: authProvider, // rebuild khi auth thay đổi

    redirect: (context, state) {
      // Chưa khởi tạo xong (đang restore session) → giữ ở splash
      if (!authProvider.initialized) return '/splash';

      final loggedIn = authProvider.isLoggedIn;
      final path = state.uri.path;
      final isAuthPage = path == '/splash' || path == '/login';

      // Chưa đăng nhập mà vào trang cần auth → về login
      if (!loggedIn && !isAuthPage) return '/login';

      // Đã đăng nhập mà vào login/splash → về home
      if (loggedIn && isAuthPage) return '/home';

      return null;
    },

    routes: [
      GoRoute(
        path: '/splash',
        builder: (_, __) => const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginPage(),
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            BottomNavBar(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/home',
              builder: (_, __) => const HomePage(),
              routes: [
                GoRoute(
                  path: 'product',
                  builder: (_, __) => const ProductListPage(),
                  routes: [
                    GoRoute(
                      path: ':id',
                      builder: (context, state) =>
                          ProductDetailPage(product: state.extra as Product),
                    ),
                  ],
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/favorite',
              builder: (_, __) => const FavoritePage(),
              routes: [
                GoRoute(
                  path: 'product/:id',
                  builder: (context, state) =>
                      ProductDetailPage(product: state.extra as Product),
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/cart',
              builder: (_, __) => const CartPage(),
              routes: [
                GoRoute(
                  path: 'checkout',
                  builder: (_, __) => const CheckoutPage(),
                  routes: [
                    GoRoute(path: 'address', builder: (_, __) => const ChooseAddressPage()),
                    GoRoute(path: 'payment', builder: (_, __) => const PaymentMethodPage()),
                    GoRoute(path: 'success',  builder: (_, __) => const OrderSuccessPage()),
                  ],
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/profile',
              builder: (_, __) => const ProfilePage(),
              routes: [
                GoRoute(path: 'edit',      builder: (_, __) => const EditProfilePage()),
                GoRoute(path: 'orders',    builder: (_, __) => const OrderHistoryPage()),
                GoRoute(path: 'addresses', builder: (_, __) => const MyAddressPage()),
                GoRoute(path: 'payment',   builder: (_, __) => const PaymentMethodPage()),
              ],
            ),
          ]),
        ],
      ),
    ],
  );
}

// ─── BOTTOM NAV ──────────────────────────────────────────────────
class BottomNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const BottomNavBar({super.key, required this.navigationShell});

  bool _isRootRoute(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    return path == '/home' || path == '/favorite' ||
           path == '/cart'  || path == '/profile';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: _isRootRoute(context)
          ? Theme(
              data: Theme.of(context).copyWith(
                splashFactory: InkRipple.splashFactory,
                splashColor: const Color(0xFF6F4E37).withOpacity(0.12),
                highlightColor: Colors.transparent,
              ),
              child: BottomNavigationBar(
                currentIndex: navigationShell.currentIndex,
                onTap: (i) => navigationShell.goBranch(i, initialLocation: true),
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.white,
                selectedItemColor: const Color(0xFF6F4E37),
                showSelectedLabels: false,
                showUnselectedLabels: false,
                enableFeedback: false,
                elevation: 8,
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.home_outlined),      activeIcon: Icon(Icons.home),          label: ''),
                  BottomNavigationBarItem(icon: Icon(Icons.favorite_border),    activeIcon: Icon(Icons.favorite),      label: ''),
                  BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), activeIcon: Icon(Icons.shopping_bag), label: ''),
                  BottomNavigationBarItem(icon: Icon(Icons.person_outline),     activeIcon: Icon(Icons.person),        label: ''),
                ],
              ),
            )
          : null,
    );
  }
}