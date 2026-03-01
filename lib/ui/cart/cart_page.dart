import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../cart/cart_manager.dart';
import '../../models/product.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  /// If true → skip delete confirmation dialog
  bool _skipDeleteConfirm = false;

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartManager>();
    final items = cart.items;
    final subtotal = cart.subtotal;

    const taxPercent = 0.08;
    final taxes = subtotal * taxPercent;
    final shipping = subtotal > 20 ? 0.0 : 2.0;
    final total = subtotal + taxes + shipping;

    return Scaffold(
      backgroundColor: const Color(0xFFFBEFE9),

      /// ===================== APP BAR =====================
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('Cart', style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      /// ===================== BODY =====================
      body: items.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined,
                      size: 60, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    'Your cart is empty',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                /// ===================== ORDER LIST =====================
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ListView(
                      children: items.entries.map((entry) {
                        final product = entry.key;
                        final qty = entry.value;

                        return Dismissible(
                          key: ValueKey(product.id),
                          direction: DismissDirection.endToStart,

                          /// 🔥 CONFIRM BEFORE DELETE
                          confirmDismiss: (direction) async {
                            if (_skipDeleteConfirm) return true;
                            return await _confirmDeleteDialog(context);
                          },

                          background: _buildDeleteBackground(),

                          onDismissed: (_) {
                            final wasLastItem =
                                cart.items.length == 1;

                            cart.remove(product);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    const Text('Item removed'),
                                behavior:
                                    SnackBarBehavior.floating,
                                duration: const Duration(milliseconds: 500),
                                margin: wasLastItem
                                    ? const EdgeInsets.all(16)
                                    : const EdgeInsets.fromLTRB(
                                        16, 0, 16, 250),
                                backgroundColor:
                                    const Color.fromRGBO(0, 0, 0, 0.8),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(16),
                                ),
                              ),
                            );
                          },

                          /// ===================== CART ITEM CARD =====================
                          child: Container(
                            margin: const EdgeInsets.only(
                                bottom: 14),
                            padding:
                                const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(0.04),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(12),
                                  child: Image.asset(
                                    product.imagePath,
                                    width: 65,
                                    height: 65,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 14),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: const TextStyle(
                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                          height: 6),
                                      Text(
                                        '\$${(product.price * qty).toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          color:
                                              Color(0xFF6F4E37),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                _buildQuantitySelector(
                                    context,
                                    cart,
                                    product,
                                    qty),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                _buildSummarySection(
                    subtotal, shipping, taxes, total),
              ],
            ),
    );
  }

  /// ===================== DELETE CONFIRM DIALOG =====================
  Future<bool> _confirmDeleteDialog(
      BuildContext context) async {
    bool dontShowAgain = false;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            "Remove Item",
            style: TextStyle(
                fontWeight: FontWeight.bold),
          ),
          content: StatefulBuilder(
            builder: (context, setStateDialog) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Are you sure you want to remove this item?",
                  ),
                  const SizedBox(height: 20),

                  /// Don't show again checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: dontShowAgain,
                        onChanged: (value) {
                          setStateDialog(() {
                            dontShowAgain =
                                value ?? false;
                          });
                        },
                      ),
                      const Expanded(
                        child: Text(
                            "Don't show again"),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (dontShowAgain) {
                  setState(() {
                    _skipDeleteConfirm = true;
                  });
                }
                Navigator.pop(context, true);
              },
              child: const Text("Remove"),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  /// ===================== DELETE BACKGROUND =====================
  Widget _buildDeleteBackground() {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding:
          const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Icon(
        Icons.delete_outline,
        color: Color.fromRGBO(244, 67, 54, 0.8),
        size: 28,
      ),
    );
  }

  /// ===================== QUANTITY SELECTOR =====================
  Widget _buildQuantitySelector(
    BuildContext context,
    CartManager cart,
    Product product,
    int qty,
  ) {
    final controller =
        TextEditingController(text: qty.toString());

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color:
            const Color(0xFFF3E6E0).withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          _qtyBtn(
            icon: Icons.remove,
            onTap: () => cart.decrease(product),
          ),
          SizedBox(
            width: 50,
            child: TextField(
              controller: controller,
              textAlign: TextAlign.center,
              keyboardType:
                  TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter
                    .digitsOnly,
                LengthLimitingTextInputFormatter(
                    3),
              ],
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
              ),
              style: const TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
              onSubmitted: (value) {
                final newQty =
                    int.tryParse(value) ?? 1;
                if (newQty > 0) {
                  cart.updateQuantity(
                      product, newQty);
                }
              },
            ),
          ),
          _qtyBtn(
            icon: Icons.add,
            onTap: () =>
                cart.addToCart(product),
          ),
        ],
      ),
    );
  }

  /// ===================== SUMMARY SECTION =====================
  Widget _buildSummarySection(
    double subtotal,
    double shipping,
    double taxes,
    double total,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFFD45A32),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          _row('Subtotal',
              '\$${subtotal.toStringAsFixed(2)}'),
          _row(
              'Shipping',
              shipping == 0
                  ? 'Free'
                  : '\$${shipping.toStringAsFixed(2)}'),
          _row('Tax (8%)',
              '\$${taxes.toStringAsFixed(2)}'),
          const Divider(color: Colors.white70),
          _row('Total',
              '\$${total.toStringAsFixed(2)}',
              bold: true),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () =>
                context.push('/cart/checkout'),
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFF3A0F0A),
                borderRadius:
                    BorderRadius.circular(26),
              ),
              child: const Center(
                child: Text(
                  'Proceed to Checkout',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _row(
    String left,
    String right, {
    bool bold = false,
  }) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Text(
            left,
            style: TextStyle(
              color: Colors.white,
              fontWeight: bold
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
          Text(
            right,
            style: TextStyle(
              color: Colors.white,
              fontWeight: bold
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _qtyBtn({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: const Color(0xFF6F4E37)
              .withOpacity(0.04),
          borderRadius:
              BorderRadius.circular(15),
        ),
        child: Icon(icon,
            size: 18,
            color: const Color(0xFF6F4E37)),
      ),
    );
  }
}