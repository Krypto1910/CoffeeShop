import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
import '../ui/search/search_page.dart';
import '../ui/product/product_detail_page.dart';
import '../ui/product/product_list_page.dart';
import '../ui/checkout/choose_address_page.dart';
import '../models/product.dart';

class BottomNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const BottomNavBar({super.key, required this.navigationShell});

  bool _isRootRoute(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    return location == '/home' ||
        location == '/favorite' ||
        location == '/cart' ||
        location == '/profile';
  }

  @override
  Widget build(BuildContext context) {
    final showBottomNav = _isRootRoute(context);

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: showBottomNav
          ? Theme(
              data: Theme.of(context).copyWith(
                splashFactory: InkRipple.splashFactory,
                splashColor: const Color(0xFF6F4E37).withOpacity(0.12),
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
              ),
              child: BottomNavigationBar(
                currentIndex: navigationShell.currentIndex,
                onTap: (index) {
                  navigationShell.goBranch(
                    index,
                    initialLocation: true,
                  );
                },
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.white,
                selectedItemColor: const Color(0xFF6F4E37),
                showSelectedLabels: false,
                showUnselectedLabels: false,
                enableFeedback: false,
                elevation: 8,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    activeIcon: Icon(Icons.home),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.favorite_border),
                    activeIcon: Icon(Icons.favorite),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_bag_outlined),
                    activeIcon: Icon(Icons.shopping_bag),
                    label: '',
                  ),
                  BottomNavigationBarItem(
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

final GoRouter appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/product',
      builder: (context, state) {
        final product = state.extra as Product;
        return ProductDetailPage(product: product);
      },
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return BottomNavBar(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomePage(),
              routes: [
                GoRoute(
                  path: 'search',
                  builder: (context, state) => const SearchPage(),
                ),
                GoRoute(
                  path: 'products',
                  builder: (context, state) => const ProductListPage(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/favorite',
              builder: (context, state) => const FavoritePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/cart',
              builder: (context, state) => const CartPage(),
              routes: [
                GoRoute(
                  path: 'checkout',
                  builder: (context, state) => const CheckoutPage(),
                  routes: [
                    GoRoute(
                      path: 'address',
                      builder: (context, state) =>
                          const ChooseAddressPage(),
                    ),
                    GoRoute(
                      path: 'payment',
                      builder: (context, state) =>
                          const PaymentMethodPage(),
                    ),
                    GoRoute(
                      path: 'success',
                      builder: (context, state) =>
                          const OrderSuccessPage(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfilePage(),
              routes: [
                GoRoute(
                  path: 'edit',
                  builder: (context, state) => const EditProfilePage(),
                ),
                GoRoute(
                  path: 'orders',
                  builder: (context, state) => const OrderHistoryPage(),
                ),
                GoRoute(
                  path: 'addresses',
                  builder: (context, state) => const MyAddressPage(),
                ),
                GoRoute(
                  path: 'payment',
                  builder: (context, state) =>
                      const PaymentMethodPage(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);