import 'package:flutter/material.dart';
import '../../widgets/cart_item.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBEFE9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('Cart', style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: const [
          Padding(padding: EdgeInsets.only(right: 16), child: Icon(Icons.edit)),
        ],
      ),

      body: Column(
        children: [
          // ===== LIST =====
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'My Order',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'You have 2 items in your cart.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 16),

                  CartItem(
                    title: 'Espresso',
                    subtitle: 'with milk',
                    price: '\$2.50',
                    imagePath: 'assets/images/coffee1.png',
                  ),
                  CartItem(
                    title: 'Latte',
                    subtitle: 'with chocolate',
                    price: '\$3.20',
                    imagePath: 'assets/images/coffee2.png',
                  ),
                ],
              ),
            ),
          ),

          // ===== SUMMARY =====
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFFD45A32),
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: Column(
              children: [
                _row('Subtotal', '\$5.7'),
                _row('Shipping Cost', '\$1.00'),
                _row('Taxes', '\$1.00'),
                const Divider(color: Colors.white70),
                _row('Total', '\$7.7', bold: true),
                const SizedBox(height: 16),

                Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A0F0A),
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: const Center(
                    child: Text(
                      'Proceed to Checkout',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _row(String left, String right, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            left,
            style: TextStyle(
              color: Colors.white,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            right,
            style: TextStyle(
              color: Colors.white,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
