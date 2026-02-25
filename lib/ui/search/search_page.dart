import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/product_card.dart';
import '../../models/product.dart';

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
            const Text(
              'Popular Coffee',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.65,
                children: [
                  ProductCard(
                    product: Product(
                      id: 1,
                      title: 'Cappuccino',
                      price: 90.0,
                      oldPrice: 120.0,
                      imagePath: 'assets/images/coffee1.png',
                    ),
                    onTap: () {
                      context.push(
                        '/product',
                        extra: Product(
                          id: 1,
                          title: 'Cappuccino',
                          price: 90.0,
                          oldPrice: 120.0,
                          imagePath: 'assets/images/coffee1.png',
                        ),
                      );
                    },
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
