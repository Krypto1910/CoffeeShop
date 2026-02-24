import 'package:flutter/material.dart';
import '../../widgets/product_card.dart';
import '../product/product_detail_page.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6EFE8),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Search Coffee',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== SEARCH BAR =====
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search),
                  hintText: 'Search your coffee...',
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ===== POPULAR =====
            const Text(
              'Popular Coffee',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            // ===== RESULT GRID =====
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.65,
                children: [
                  ProductCard(
                    title: 'Cappuccino',
                    price: '\$90',
                    oldPrice: '\$120',
                    imagePath: 'assets/images/coffee1.png',
                  ),
                  ProductCard(
                    title: 'Latte',
                    price: '\$85',
                    oldPrice: '\$110',
                    imagePath: 'assets/images/coffee2.png',
                  ),
                  ProductCard(
                    title: 'Espresso',
                    price: '\$70',
                    oldPrice: '\$95',
                    imagePath: 'assets/images/coffee.png',
                  ),
                  ProductCard(
                    title: 'Mocha',
                    price: '\$95',
                    oldPrice: '\$130',
                    imagePath: 'assets/images/coffee2.png',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
