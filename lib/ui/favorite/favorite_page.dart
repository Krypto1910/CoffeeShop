import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
          : _buildFavoriteGrid(context, favorites),
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
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteGrid(BuildContext context, List favorites) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 16.0;
        const padding = 16.0;

        int crossAxisCount = 2;

        if (constraints.maxWidth > 900) {
          crossAxisCount = 4;
        } else if (constraints.maxWidth > 600) {
          crossAxisCount = 3;
        }

        return GridView.builder(
          padding: const EdgeInsets.all(padding),
          itemCount: favorites.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: spacing,
            crossAxisSpacing: spacing,
            childAspectRatio: 0.70, // 🔥 đã fix overflow
          ),
          itemBuilder: (context, index) {
            final product = favorites[index];

            return ProductCard(
              product: product,
              onTap: () => context.push(
                '/favorite/product/${product.id}',
                extra: product,
              ),
            );
          },
        );
      },
    );
  }
}