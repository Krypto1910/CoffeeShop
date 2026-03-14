import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:provider/provider.dart';
import '../ui/favorite/favorite_manager.dart';
import '../ui/cart/cart_manager.dart';
import '../providers/auth_provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCard({super.key, required this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartManager>();
    final imageUrl = product.imageUrl(cart.baseUrl);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── IMAGE ──────────────────────────────────────────
                  SizedBox(
                    height: 130,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _imageFallback(),
                              loadingBuilder: (_, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  color: const Color(0xFFEFE3D3),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF6F4E37),
                                      strokeWidth: 2,
                                    ),
                                  ),
                                );
                              },
                            )
                          : _imageFallback(),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ─── TITLE + HEART ──────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Consumer<FavoriteManager>(
                          builder: (context, favManager, _) {
                            final isFav = favManager.isFavorite(product.id);
                            return GestureDetector(
                              onTap: () => favManager.toggleFavorite(product),
                              child: TweenAnimationBuilder<double>(
                                duration: const Duration(milliseconds: 150),
                                tween: Tween(
                                  begin: 0.8,
                                  end: isFav ? 1.2 : 1.0,
                                ),
                                curve: Curves.easeOutBack,
                                builder: (_, scale, __) => Transform.scale(
                                  scale: scale,
                                  child: Icon(
                                    isFav
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    size: 22,
                                    color: isFav ? Colors.red : Colors.grey,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // ─── PRICE ──────────────────────────────────────────
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6F4E37),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // ─── ADD TO CART BUTTON ─────────────────────────────────
            Positioned(
              bottom: 0,
              right: 0,
              child: _AddButton(product: product),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageFallback() {
    return Container(
      color: const Color(0xFFEFE3D3),
      child: const Center(
        child: Icon(Icons.coffee, color: Color(0xFF6F4E37), size: 40),
      ),
    );
  }
}

// ─── ADD BUTTON ───────────────────────────────────────────────────
class _AddButton extends StatefulWidget {
  final Product product;
  const _AddButton({required this.product});

  @override
  State<_AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<_AddButton> {
  bool _animate = false;

  Future<void> _handleTap() async {
    setState(() => _animate = true);
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() => _animate = false);

    final userId = context.read<AuthProvider>().user?.id;
    if (userId == null) return;

    await context.read<CartManager>().addToCart(userId, widget.product);

    if (mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('${widget.product.title} added to cart'),
            duration: const Duration(milliseconds: 1500),
            behavior: SnackBarBehavior.floating,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedScale(
        scale: _animate ? 0.9 : 1.0,
        duration: const Duration(milliseconds: 80),
        curve: Curves.easeInOut,
        child: Container(
          height: 40,
          width: 40,
          decoration: const BoxDecoration(
            color: Color(0xFF6F4E37),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}