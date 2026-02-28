import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import '../models/product.dart';
import 'package:provider/provider.dart';
import '../ui/favorite/favorite_manager.dart';
import '../ui/cart/cart_manager.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCard({super.key, required this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
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
                  /// IMAGE
                  SizedBox(
                    height: 130,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(product.imagePath, fit: BoxFit.cover),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// TITLE + HEART
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
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 18),
                        child: Consumer<FavoriteManager>(
                          builder: (context, favManager, child) {
                            final isFav = favManager.isFavorite(product.id);

                            return GestureDetector(
                              onTap: () {
                                favManager.toggleFavorite(product);
                              },
                              child: TweenAnimationBuilder<double>(
                                duration: const Duration(milliseconds: 150),
                                tween: Tween(
                                  begin: 0.8,
                                  end: isFav ? 1.2 : 1.0,
                                ),
                                curve: Curves.easeOutBack,
                                builder: (context, scale, child) {
                                  return Transform.scale(
                                    scale: scale,
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 50,
                                      ),
                                      padding: const EdgeInsets.all(4),

                                      child: Icon(
                                        isFav
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        size: 22,
                                        color: isFav ? Colors.red : Colors.grey,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  /// PRICE
                  Row(
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6F4E37),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '\$${product.oldPrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// ADD BUTTON (bottom right)
            Positioned(
              bottom: 0,
              right: 0,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: _AddButton(product: product),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddButton extends StatefulWidget {
  final Product product;

  const _AddButton({required this.product});

  @override
  State<_AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<_AddButton> {
  bool _animate = false;

  void _handleTap() async {
    setState(() => _animate = true);

    // chờ animation scale xuống
    await Future.delayed(const Duration(milliseconds: 100));

    setState(() => _animate = false);

    // Add to cart
    context.read<CartManager>().addToCart(widget.product);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.title} added to cart'),
        duration: const Duration(milliseconds: 1500),
        behavior: SnackBarBehavior.floating,
      ),
    );
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