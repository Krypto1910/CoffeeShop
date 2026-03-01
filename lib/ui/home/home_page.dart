import 'package:flutter/material.dart';
import '../../widgets/hero_section.dart';
import '../../widgets/category_item.dart';
import '../../widgets/product_card.dart';
import 'package:go_router/go_router.dart';
import '../../models/product.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Product> specialCoffees = [
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeroSection(),

            // ===== Categories =====
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: Text(
                'Categories',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(
              height: 110,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: const [
                  CategoryItem(title: 'All Menu'),
                  CategoryItem(title: 'Latte'),
                  CategoryItem(title: 'Mocha'),
                  CategoryItem(title: 'Doppio'),
                ],
              ),
            ),

            // ===== Special Coffee =====
            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                highlightColor: Colors.transparent,
                onTap: () => context.push('/home/product'),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 4,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Special Coffee',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(
                        Icons.chevron_right,
                        size: 22,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(
              height: 270,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: specialCoffees.length,
                itemBuilder: (context, index) {
                  final product = specialCoffees[index];
                  return ProductCard(
                    product: product,
                    onTap: () => context.push(
                      '/home/product/${product.id}',
                      extra: product,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}