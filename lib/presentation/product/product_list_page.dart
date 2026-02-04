import 'package:flutter/material.dart';
import '../../widgets/product_card.dart';
import 'product_detail_page.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6EFE8),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Special Coffee',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.65,
          children: [
            ProductCard(
              title: 'Chocolate Coffee',
              price: '\$80',
              oldPrice: '\$120',
              imagePath: 'assets/images/coffee1.png',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProductDetailPage(
                      title: 'Chocolate Coffee',
                      price: '\$250',
                      imagePath: 'assets/images/coffee1.png',
                    ),
                  ),
                );
              },
            ),
            ProductCard(
              title: 'Doppio Coffee',
              price: '\$70',
              oldPrice: '\$100',
              imagePath: 'assets/images/coffee2.png',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProductDetailPage(
                      title: 'Doppio Coffee',
                      price: '\$220',
                      imagePath: 'assets/images/coffee2.png',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
