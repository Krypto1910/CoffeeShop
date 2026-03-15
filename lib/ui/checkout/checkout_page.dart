import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../ui/cart/cart_manager.dart';
import '../../ui/address/address_manager.dart';
import '../../ui/order/order_manager.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _paymentMethod = 'cash';

  static const _paymentOptions = [
    {'value': 'cash', 'label': 'Cash on Delivery', 'icon': Icons.payments_outlined},
    {'value': 'card', 'label': 'Credit / Debit Card', 'icon': Icons.credit_card},
    {'value': 'ewallet', 'label': 'E-Wallet', 'icon': Icons.account_balance_wallet_outlined},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthProvider>().user?.id;
      if (userId != null) {
        context.read<AddressManager>().fetchAddresses(userId);
      }
    });
  }

  Future<void> _placeOrder() async {
    final auth = context.read<AuthProvider>();
    final cart = context.read<CartManager>();
    final addressMgr = context.read<AddressManager>();
    final orderMgr = context.read<OrderManager>();

    final userId = auth.user?.id;
    if (userId == null) return;

    // Kiểm tra có địa chỉ không
    final defaultAddr = addressMgr.defaultAddress;
    if (defaultAddr == null) {
      _showSnack('Vui lòng chọn địa chỉ giao hàng', isError: true);
      return;
    }

    final subtotal = cart.subtotal;
    const taxPercent = 0.08;
    final taxes = subtotal * taxPercent;
    final shipping = subtotal > 20 ? 0.0 : 2.0;
    final total = subtotal + taxes + shipping;

    final addressText = '${defaultAddr.title}: ${defaultAddr.detail}';

    final success = await orderMgr.placeOrder(
      userId: userId,
      cartItems: cart.items.toList(),
      address: addressText,
      paymentMethod: _paymentMethod,
      totalAmount: total,
    );

    if (!mounted) return;

    if (success) {
      // Clear cart sau khi đặt hàng thành công
      await cart.clearCart();
      context.go('/cart/checkout/success');
    } else {
      _showSnack(orderMgr.errorMessage ?? 'Đặt hàng thất bại', isError: true);
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red[700] : const Color(0xFF6F4E37),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartManager>();
    final addressMgr = context.watch<AddressManager>();
    final orderMgr = context.watch<OrderManager>();
    final defaultAddr = addressMgr.defaultAddress;

    final subtotal = cart.subtotal;
    const taxPercent = 0.08;
    final taxes = subtotal * taxPercent;
    final shipping = subtotal > 20 ? 0.0 : 2.0;
    final total = subtotal + taxes + shipping;

    return Scaffold(
      backgroundColor: const Color(0xFFF6EFE8),
      appBar: AppBar(
        title: const Text('Checkout',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── DELIVERY ADDRESS ──────────────────────────────────
            _sectionTitle('Delivery Address'),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => context.push('/cart/checkout/address'),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: defaultAddr == null
                      ? Border.all(color: Colors.red.withOpacity(0.5))
                      : null,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFE3D3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.location_on,
                          color: Color(0xFF6F4E37), size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: defaultAddr != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  defaultAddr.title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  defaultAddr.detail,
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 13),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            )
                          : const Text(
                              'Chọn địa chỉ giao hàng',
                              style: TextStyle(color: Colors.red),
                            ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ─── PAYMENT METHOD ────────────────────────────────────
            _sectionTitle('Payment Method'),
            const SizedBox(height: 8),
            ..._paymentOptions.map((option) {
              final isSelected = _paymentMethod == option['value'];
              return GestureDetector(
                onTap: () =>
                    setState(() => _paymentMethod = option['value'] as String),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF6F4E37)
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF6F4E37)
                              : const Color(0xFFEFE3D3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          option['icon'] as IconData,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF6F4E37),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          option['label'] as String,
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Icon(Icons.check_circle,
                            color: Color(0xFF6F4E37), size: 20),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 20),

            // ─── ORDER ITEMS ───────────────────────────────────────
            _sectionTitle('Order Items (${cart.items.length})'),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: cart.items.map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.product.title,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Text('x${item.quantity}',
                            style: const TextStyle(color: Colors.grey)),
                        const SizedBox(width: 12),
                        Text(
                          '\$${(item.product.price * item.quantity).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6F4E37),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // ─── ORDER SUMMARY ─────────────────────────────────────
            _sectionTitle('Order Summary'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _priceRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
                  _priceRow('Shipping',
                      shipping == 0 ? 'Free' : '\$${shipping.toStringAsFixed(2)}'),
                  _priceRow('Tax (8%)', '\$${taxes.toStringAsFixed(2)}'),
                  const Divider(height: 20),
                  _priceRow('Total', '\$${total.toStringAsFixed(2)}',
                      isBold: true),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ─── PLACE ORDER BUTTON ────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6F4E37),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 4,
                  shadowColor: const Color(0xFF6F4E37).withOpacity(0.4),
                ),
                onPressed: orderMgr.isLoading ? null : _placeOrder,
                child: orderMgr.isLoading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : const Text(
                        'Place Order',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) => Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      );

  Widget _priceRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(color: isBold ? Colors.black : Colors.grey)),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 16 : 14,
              color: isBold ? const Color(0xFF6F4E37) : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}