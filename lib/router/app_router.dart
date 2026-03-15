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

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            BottomNavBar(navigationShell: navigationShell),
        branches: [
          // HOME
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
                      builder: (_, state) =>
                          ProductDetailPage(product: state.extra as Product),
                    ),
                  ],
                ),
              ],
            ),
          ]),

          // FAVORITE
          StatefulShellBranch(routes: [
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
          ]),

          // CART
          StatefulShellBranch(routes: [
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
                        builder: (_, __) => const ChooseAddressPage()),
                    GoRoute(
                        path: 'payment',
                        builder: (_, __) => const PaymentMethodPage()),
                    GoRoute(
                        path: 'success',
                        builder: (_, __) => const OrderSuccessPage()),
                  ],
                ),
              ],
            ),
          ]),

          // PROFILE
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/profile',
              builder: (_, __) => const ProfilePage(),
              routes: [
                GoRoute(
                    path: 'edit', builder: (_, __) => const EditProfilePage()),
                GoRoute(
                    path: 'orders',
                    builder: (_, __) => const OrderHistoryPage()),
                GoRoute(
                    path: 'addresses',
                    builder: (_, __) => const MyAddressPage()),
                GoRoute(
                    path: 'payment',
                    builder: (_, __) => const PaymentMethodPage()),
              ],
            ),
          ]),
        ],
      ),
    ],
  );
}

// ─── BOTTOM NAV WITH CART BADGE ──────────────────────────────────
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
                onTap: (i) =>
                    navigationShell.goBranch(i, initialLocation: true),
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.white,
                selectedItemColor: const Color(0xFF6F4E37),
                showSelectedLabels: false,
                showUnselectedLabels: false,
                enableFeedback: false,
                elevation: 8,
                items: [
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    activeIcon: Icon(Icons.home),
                    label: '',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.favorite_border),
                    activeIcon: Icon(Icons.favorite),
                    label: '',
                  ),

                  // Cart với badge
                  BottomNavigationBarItem(
                    icon: _CartIcon(isActive: false),
                    activeIcon: _CartIcon(isActive: true),
                    label: '',
                  ),

                  const BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline),
                    activeIcon: Icon(Icons.person),
                    label: '',
                  ),
                ],
              ),
            )
          : null,
    );
  }
}

// ─── CART ICON WITH BADGE ────────────────────────────────────────
class _CartIcon extends StatelessWidget {
  final bool isActive;
  const _CartIcon({required this.isActive});

  @override
  Widget build(BuildContext context) {
    final totalItems = context.watch<CartManager>().totalItems;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(
          isActive ? Icons.shopping_bag : Icons.shopping_bag_outlined,
        ),
        if (totalItems > 0)
          Positioned(
            top: -6,
            right: -8,
            child: Container(
              padding: const EdgeInsets.all(3),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              decoration: const BoxDecoration(
                color: Color(0xFFD45A32),
                shape: BoxShape.circle,
              ),
              child: Text(
                totalItems > 99 ? '99+' : '$totalItems',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}