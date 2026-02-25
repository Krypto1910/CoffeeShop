import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/product_card.dart';
import 'favorite_manager.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoriteManager>().favorites;

    return Scaffold(
      backgroundColor: const Color(0xFFF6EFE8),

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

      body: favorites.isEmpty
          ? _buildEmptyState()
          : _buildFavoriteGrid(favorites),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border,
              size: 72, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No favorite coffee yet',
            style:
                TextStyle(fontSize: 16, color: Colors.grey),
          ),
          SizedBox(height: 6),
          
        ],
      ),
    );
  }

  Widget _buildFavoriteGrid(List favorites) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        itemCount: favorites.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.65,
        ),
        itemBuilder: (context, index) {
          return ProductCard(
            product: favorites[index],
          );
        },
      ),
    );
  }
}