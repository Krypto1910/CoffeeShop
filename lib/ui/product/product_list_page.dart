import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/product_card.dart';
import '../../models/product.dart';

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
              product: Product(
                id: 1,
                title: 'Chocolate Coffee',
                price: 80.0,
                oldPrice: 120.0,
                imagePath: 'assets/images/coffee1.png',
              ),
              onTap: () {
                context.push(
                  '/product',
                  extra: Product(
                    id: 1,
                    title: 'Chocolate Coffee',
                    price: 80.0,
                    oldPrice: 120.0,
                    imagePath: 'assets/images/coffee1.png',
                  ),
                );
              },
            ),
            ProductCard(
              product: Product(
                id: 2,
                title: 'Doppio Coffee',
                price: 70.0,
                oldPrice: 100.0,
                imagePath: 'assets/images/coffee2.png',
              ),
              onTap: () {
                context.push(
                  '/product',
                  extra: Product(
                    id: 2,
                    title: 'Doppio Coffee',
                    price: 70.0,
                    oldPrice: 100.0,
                    imagePath: 'assets/images/coffee2.png',
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
