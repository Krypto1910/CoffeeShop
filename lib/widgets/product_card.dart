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

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        return GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                Column(
                  children: [
                    // ✅ IMAGE (flexible - không dùng height % nữa)
                    Expanded(
                      flex: 6,
                      child: SizedBox(
                        width: double.infinity,
                        child: imageUrl.isNotEmpty
                            ? Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    _imageFallback(),
                              )
                            : _imageFallback(),
                      ),
                    ),

                    // ✅ CONTENT (flexible)
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          width * 0.06,
                          8,
                          width * 0.06,
                          8,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            // TITLE (khóa chiều cao)
                            SizedBox(
                              height: 40,
                              child: Text(
                                product.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: width * 0.075,
                                  height: 1.2,
                                ),
                              ),
                            ),

                            // PRICE
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF6F4E37),
                                fontSize: width * 0.075,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // ❤️ FAVORITE
                Positioned(
                  top: 10,
                  right: 10,
                  child: Consumer<FavoriteManager>(
                    builder: (context, favManager, _) {
                      final isFav =
                          favManager.isFavorite(product.id);
                      return GestureDetector(
                        onTap: () =>
                            favManager.toggleFavorite(product),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isFav
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 18,
                            color:
                                isFav ? Colors.red : Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // ➕ ADD BUTTON
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: _AddButton(product: product),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _imageFallback() {
    return Container(
      color: const Color(0xFFEFE3D3),
      child: const Center(
        child: Icon(Icons.coffee,
            color: Color(0xFF6F4E37), size: 40),
      ),
    );
  }
}

// ─── ADD BUTTON ─────────────────────────
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

    await context
        .read<CartManager>()
        .addToCart(userId, widget.product);

    if (mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content:
                Text('${widget.product.title} added to cart'),
            duration: const Duration(milliseconds: 1500),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _animate ? 0.9 : 1.0,
      duration: const Duration(milliseconds: 100),
      child: Container(
        height: 42,
        width: 42,
        decoration: BoxDecoration(
          color: const Color(0xFF6F4E37),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
            ),
          ],
        ),
        child: const Icon(Icons.add,
            color: Colors.white, size: 20),
      ),
    );
  }
}