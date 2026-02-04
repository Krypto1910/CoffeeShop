import 'package:ct312h_project/presentation/checkout/order_success_page.dart';
import 'package:ct312h_project/presentation/checkout/payment_methpd_page.dart';
import 'package:ct312h_project/presentation/favorite/favorite_page.dart';
import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'presentation/product/product_detail_page.dart';
import 'presentation/product/product_list_page.dart';
import 'presentation/cart/cart_page.dart';
import 'presentation/checkout/checkout_page.dart';
import 'presentation/checkout/choose_address_page.dart';
import 'presentation/order/order_history_page.dart';
import 'presentation/profile/profile_page.dart';
import 'presentation/search/search_page.dart';
import 'presentation/favorite/favorite_page.dart';
import 'presentation/profile/edit_profile_page.dart';
import 'presentation/address/my_addresses_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyAddressesPage(),
    );
  }
}
