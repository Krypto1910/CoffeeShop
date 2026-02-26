import 'package:flutter/material.dart';
import '../../widgets/hero_section.dart';
import '../../widgets/category_item.dart';
import '../../widgets/product_card.dart';
import '../search/search_page.dart';
import 'package:go_router/go_router.dart';
import '../../models/product.dart';

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
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                highlightColor: Colors.transparent,
                onTap: () {
                  context.push('/home/products');
                },
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
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
                      context.push('/home/products');
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
                      context.push('/home/products');
                    },
                  ),
                  ProductCard(
                    product: Product(
                      id: 3,
                      title: 'Mocha Coffee',
                      price: 85.0,
                      oldPrice: 110.0,
                      imagePath: 'assets/images/coffee1.png',
                    ),
                    onTap: () {
                      context.push('/home/products');
                    },
                  ),
                  ProductCard(
                    product: Product(
                      id: 4,
                      title: 'Caramel Macchiato',
                      price: 90.0,
                      oldPrice: 100.0,
                      imagePath: 'assets/images/coffee.png',
                    ),
                    onTap: () {
                      context.push('/home/products');
                    },
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
