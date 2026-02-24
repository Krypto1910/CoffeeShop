import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../presentation/auth/splash_page.dart';
import '../presentation/auth/login_page.dart';
import '../presentation/home/home_page.dart';
import '../presentation/favorite/favorite_page.dart';
import '../presentation/cart/cart_page.dart';
import '../presentation/profile/profile_page.dart';
import '../presentation/profile/edit_profile_page.dart';
import '../presentation/order/order_history_page.dart';
import '../presentation/address/my_addresses_page.dart';
import '../presentation/checkout/payment_method_page.dart';
import '../presentation/checkout/checkout_page.dart';
import '../presentation/checkout/order_success_page.dart';
import '../presentation/search/search_page.dart';
import '../presentation/product/product_detail_page.dart';
import '../presentation/product/product_list_page.dart';
import '../presentation/checkout/choose_address_page.dart';

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
          ? BottomNavigationBar(
              currentIndex: navigationShell.currentIndex,
              onTap: (index) {
                navigationShell.goBranch(
                  index,
                  initialLocation: true, // always go to root of the branch
                );
              },
              type: BottomNavigationBarType.fixed,
              selectedItemColor: const Color(0xFF6F4E37),
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite_border),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_bag_outlined),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  label: '',
                ),
              ],
            )
          : null, // hide bottom nav on subpages
    );
  }
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/home',

  routes: [
    // global product detail route
    // GoRoute(
    //   name: 'productDetail',
    //   path: '/product/:id',
    //   builder: (context, state) {
    //     final productId = state.pathParameters['id']!;
    //     return ProductDetailPage(productId: productId);
    //   },
    // ),
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
                      builder: (context, state) => const ChooseAddressPage(),
                    ),
                    GoRoute(
                      path: 'payment', 
                      builder: (context, state) => const PaymentMethodPage(),
                    ),
                    GoRoute(
                      path: 'success',
                      builder: (context, state) => const OrderSuccessPage(),
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
                  builder: (context, state) => const MyAddressesPage(),
                ),
                GoRoute(
                  path: 'payment',
                  builder: (context, state) => const PaymentMethodPage(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
