import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../ui/auth/splash_page.dart';
import '../ui/auth/login_page.dart';
import '../ui/home/home_page.dart';
import '../ui/favorite/favorite_page.dart';
import '../ui/cart/cart_page.dart';
import '../ui/cart/cart_manager.dart';
import '../ui/profile/profile_page.dart';
import '../ui/profile/edit_profile_page.dart';
import '../ui/order/order_history_page.dart';
import '../ui/address/my_address_page.dart';
import '../ui/payment_method/payment_method_page.dart';
import '../ui/payment_method/add_payment_page.dart';
import '../ui/checkout/checkout_page.dart';
import '../ui/checkout/order_success_page.dart';
import '../ui/product/product_detail_page.dart';
import '../ui/product/product_list_page.dart';
import '../ui/checkout/choose_address_page.dart';
import '../ui/search/search_page.dart'; // 🔥 ADD

import '../models/product.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createAppRouter(AuthProvider authProvider) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    refreshListenable: authProvider,

    redirect: (context, state) {
      if (!authProvider.initialized) return '/splash';

      final loggedIn = authProvider.isLoggedIn;
      final path = state.uri.path;
      final isAuthPage = path == '/splash' || path == '/login';

      if (!loggedIn && !isAuthPage) return '/login';
      if (loggedIn && isAuthPage) return '/home';

      return null;
    },

    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashPage()),
      GoRoute(path: '/login', builder: (_, __) => const LoginPage()),

      GoRoute(
        path: '/payment/add',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final type = state.uri.queryParameters['type'] ?? 'card';
          return AddPaymentPage(type: type);
        },
      ),

      // 🔥 MAIN SHELL
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            BottomNavBar(navigationShell: navigationShell),

        branches: [
          // ─── HOME ─────────────────────────────
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (_, __) => const HomePage(),
                routes: [
                  // 🔥 ADD SEARCH PAGE
                  GoRoute(
                    path: 'search',
                    builder: (_, __) => const SearchPage(),
                  ),

                  GoRoute(
                    path: 'product',
                    builder: (_, __) => const ProductListPage(),
                    routes: [
                      GoRoute(
                        path: ':id',
                        builder: (_, state) =>
                            ProductDetailPage(product: state.extra as Product),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          // ─── FAVORITE ─────────────────────────
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/favorite',
                builder: (_, __) => const FavoritePage(),
                routes: [
                  GoRoute(
                    path: 'product/:id',
                    builder: (_, state) =>
                        ProductDetailPage(product: state.extra as Product),
                  ),
                ],
              ),
            ],
          ),

          // ─── CART ─────────────────────────────
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/cart',
                builder: (_, __) => const CartPage(),
                routes: [
                  GoRoute(
                    path: 'checkout',
                    builder: (_, __) => const CheckoutPage(),
                    routes: [
                      GoRoute(
                        path: 'address',
                        builder: (_, __) => const ChooseAddressPage(),
                      ),
                      GoRoute(
                        path: 'payment',
                        builder: (_, __) => const PaymentMethodPage(),
                      ),
                      GoRoute(
                        path: 'success',
                        builder: (_, __) => const OrderSuccessPage(),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          // ─── PROFILE ─────────────────────────
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (_, __) => const ProfilePage(),
                routes: [
                  GoRoute(
                    path: 'edit',
                    builder: (_, __) => const EditProfilePage(),
                  ),
                  GoRoute(
                    path: 'orders',
                    builder: (_, __) => const OrderHistoryPage(),
                  ),
                  GoRoute(
                    path: 'addresses',
                    builder: (_, __) => const MyAddressPage(),
                  ),
                  GoRoute(
                    path: 'payment',
                    builder: (_, __) => const PaymentMethodPage(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

// ─── BOTTOM NAV BAR ─────────────────
class BottomNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const BottomNavBar({super.key, required this.navigationShell});

  bool _isRootRoute(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    return path == '/home' ||
        path == '/favorite' ||
        path == '/cart' ||
        path == '/profile';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Material(color: Colors.transparent, child: navigationShell),
      ),
      bottomNavigationBar: _isRootRoute(context)
          ? BottomNavigationBar(
              currentIndex: navigationShell.currentIndex,
              onTap: (i) => navigationShell.goBranch(i, initialLocation: true),
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.favorite), label: ''),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart),
                  label: '',
                ),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
              ],
            )
          : null,
    );
  }
}
