import 'package:flutter/material.dart';
import '../../widgets/product_card.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  // 👉 GIẢ LẬP DATA (sau này thay bằng DB / API)
  final List<Map<String, String>> favoriteList = const [
    {
      'title': 'Cappuccino',
      'price': '\$90',
      'oldPrice': '\$120',
      'image': 'assets/images/coffee1.png',
    },
    {
      'title': 'Latte',
      'price': '\$85',
      'oldPrice': '\$110',
      'image': 'assets/images/coffee2.png',
    },
    {
      'title': 'Mocha',
      'price': '\$95',
      'oldPrice': '\$130',
      'image': 'assets/images/coffee.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6EFE8),

      // ===== APP BAR =====
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Favorite Coffee',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      // ===== BODY =====
      body: favoriteList.isEmpty ? _buildEmptyState() : _buildFavoriteGrid(),
    );
  }

  // ===== EMPTY STATE =====
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.favorite_border, size: 72, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No favorite coffee yet',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          SizedBox(height: 6),
          Text(
            'Add your favorite coffee ❤️',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // ===== FAVORITE GRID =====
  Widget _buildFavoriteGrid() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        itemCount: favoriteList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.65,
        ),
        itemBuilder: (context, index) {
          final item = favoriteList[index];
          return ProductCard(
            title: item['title']!,
            price: item['price']!,
            oldPrice: item['oldPrice']!,
            imagePath: item['image']!,
          );
        },
      ),
    );
  }
}
