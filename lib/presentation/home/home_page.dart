import 'package:flutter/material.dart';
import '../../widgets/hero_section.dart';
import '../../widgets/category_item.dart';
import '../../widgets/product_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
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
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: Text(
                'Special Coffee',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(
              height: 270,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: const [
                  ProductCard(
                    title: 'Chocolate Coffee',
                    price: '\$80',
                    oldPrice: '\$120',
                    imagePath: 'assets/images/coffee1.png',
                  ),
                  ProductCard(
                    title: 'Doppio Coffee',
                    price: '\$70',
                    oldPrice: '\$100',
                    imagePath: 'assets/images/coffee2.png',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}