import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../providers/auth_provider.dart';
import '../../ui/cart/cart_manager.dart';
import '../../widgets/quantity_selector.dart';
import '../../widgets/option_chip.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _quantity = 1;
  String _type = 'Hot';
  String _sugar = '30%';

  Future<void> _addToCart() async {
    final userId = context.read<AuthProvider>().user?.id;
    if (userId == null) return;

    await context.read<CartManager>().addToCart(
      userId,
      widget.product,
      qty: _quantity,
    );

    if (mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('${widget.product.title} added to cart'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color(0xFF6F4E37),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartManager>();
    final imageUrl = widget.product.imageUrl(cart.baseUrl);

    return Scaffold(
      backgroundColor: const Color(0xFFF6EFE8),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 72),

                // ─── IMAGE ────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl,
                            height: 260,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _imageFallback(),
                          )
                        : _imageFallback(),
                  ),
                ),

                // ─── CONTENT ──────────────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(32)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title + Price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.product.title,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            '\$${widget.product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6F4E37),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Stock
                      Row(
                        children: [
                          const Icon(Icons.inventory_2_outlined,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            'In stock: ${widget.product.stock}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Description
                      const Text(
                        'Description',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.product.description.isNotEmpty
                            ? widget.product.description
                            : 'No description available.',
                        style: const TextStyle(
                          color: Colors.grey,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Type
                      const Text(
                        'Type Of Coffee',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: ['Hot', 'Cold'].map((t) {
                          return GestureDetector(
                            onTap: () => setState(() => _type = t),
                            child: OptionChip(
                              label: t,
                              selected: _type == t,
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 20),

                      // Sugar
                      const Text(
                        'Sugar',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: ['30%', '50%', '70%', '100%'].map((s) {
                          return GestureDetector(
                            onTap: () => setState(() => _sugar = s),
                            child: OptionChip(
                              label: s,
                              selected: _sugar == s,
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 20),

                      // Quantity
                      QuantitySelector(
                        quantity: _quantity,
                        onChanged: (q) => setState(() => _quantity = q),
                      ),

                      const SizedBox(height: 24),

                      // Add to Cart
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6F4E37),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          onPressed: _addToCart,
                          child: const Text(
                            'Add to Cart',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageFallback() {
    return Container(
      height: 260,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFEFE3D3),
        borderRadius: BorderRadius.circular(32),
      ),
      child: const Center(
        child: Icon(Icons.coffee, color: Color(0xFF6F4E37), size: 80),
      ),
    );
  }
}