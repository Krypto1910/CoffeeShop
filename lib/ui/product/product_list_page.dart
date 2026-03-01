import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/product_card.dart';
import '../../models/product.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final products = [
      Product(
        id: 1,
        name: 'Chocolate Coffee',
        category: 'Chocolate',
        price: 80.0,
        oldPrice: 120.0,
        imagePath: 'assets/images/coffee1.png',
      ),
      Product(
        id: 2,
        name: 'Doppio Coffee',
        category: 'Doppio',
        price: 70.0,
        oldPrice: 100.0,
        imagePath: 'assets/images/coffee2.png',
      ),
      Product(
        id: 3,
        name: 'Mocha Coffee',
        category: 'Mocha',
        price: 85.0,
        oldPrice: 110.0,
        imagePath: 'assets/images/coffee1.png',
      ),
      Product(
        id: 4,
        name: 'Caramel Macchiato',
        category: 'Caramel',
        price: 90.0,
        oldPrice: 100.0,
        imagePath: 'assets/images/coffee.png',
      ),
    ];

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
      body: LayoutBuilder(builder: (context, constraints) {
        const crossAxisCount = 2;
        const spacing = 16.0;
        const padding = 16.0;

        final cardWidth =
            (constraints.maxWidth - padding * 2 - spacing) / crossAxisCount;
        final aspectRatio = cardWidth / (cardWidth * 260 / 180);

        return Padding(
          padding: const EdgeInsets.all(padding),
          child: GridView.builder(
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: spacing,
              crossAxisSpacing: spacing,
              childAspectRatio: aspectRatio,
            ),
            itemBuilder: (context, index) {
              final product = products[index];
              return ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: SizedBox(
                    width: 180,
                    height: 260,
                    child: OverflowBox(
                      alignment: Alignment.topLeft,
                      maxWidth: 196,
                      maxHeight: 260,
                      child: ProductCard(
                        product: product,
                        onTap: () => context.push(
                          '/home/product/${product.id}',
                          extra: product,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}