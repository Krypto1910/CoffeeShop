import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../ui/cart/cart_manager.dart';
import '../../ui/address/address_manager.dart';
import '../../ui/order/order_manager.dart';
import '../../ui/payment_method/payment_method_manager.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String? _paymentMethodId;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userId = context.read<AuthProvider>().user?.id;
      if (userId != null) {
        await context.read<AddressManager>().fetchAddresses(userId);

        final paymentMgr = context.read<PaymentMethodManager>();
        await paymentMgr.fetch(userId);

        if (paymentMgr.methods.isNotEmpty) {
          final defaultMethod = paymentMgr.methods.firstWhere(
            (e) => e.isDefault == true,
            orElse: () => paymentMgr.methods.first,
          );
          setState(() {
            _paymentMethodId = defaultMethod.id;
          });
        } else {
          setState(() {
            _paymentMethodId = 'cod';
          });
        }
      }
    });
  }


  Widget _getIcon(String provider) {
    switch (provider.toLowerCase()) {
      case 'momo':
        return const Icon(Icons.account_balance_wallet, color: Colors.pink);
      case 'zalopay':
        return const Icon(Icons.account_balance_wallet, color: Colors.blue);
      case 'visa':
      case 'mastercard':
        return const Icon(Icons.credit_card, color: Colors.indigo);
      default:
        return const Icon(Icons.payment, color: Colors.grey);
    }
  }

  Future<void> _placeOrder() async {
    final auth = context.read<AuthProvider>();
    final cart = context.read<CartManager>();
    final addressMgr = context.read<AddressManager>();
    final orderMgr = context.read<OrderManager>();

    final userId = auth.user?.id;
    if (userId == null) return;

    final defaultAddr = addressMgr.defaultAddress;
    if (defaultAddr == null) {
      _showSnack('Please select a delivery address', isError: true);
      return;
    }

    if (_paymentMethodId == null) {
      _showSnack('Please select a payment method', isError: true);
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
      paymentMethod: _paymentMethodId!,
      totalAmount: total,
    );

    if (!mounted) return;

    if (success) {
      await cart.clearCart();
      context.go('/cart/checkout/success');
    } else {
      _showSnack(orderMgr.errorMessage ?? 'Failed to place order', isError: true);
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red : const Color(0xFF6F4E37),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartManager>();
    final addressMgr = context.watch<AddressManager>();
    final orderMgr = context.watch<OrderManager>();
    final paymentMgr = context.watch<PaymentMethodManager>();

    final defaultAddr = addressMgr.defaultAddress;

    final subtotal = cart.subtotal;
    const taxPercent = 0.08;
    final taxes = subtotal * taxPercent;
    final shipping = subtotal > 20 ? 0.0 : 2.0;
    final total = subtotal + taxes + shipping;

    // Check if ewallet or card parent is selected
    final isEwalletSelected = _paymentMethodId != null &&
        paymentMgr.ewallets.any((e) => e.id == _paymentMethodId);
    final isCardSelected = _paymentMethodId != null &&
        paymentMgr.cards.any((c) => c.id == _paymentMethodId);

    return Scaffold(
      backgroundColor: const Color(0xFFF6EFE8),
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ─── ADDRESS ─────────────────────────────
            _sectionTitle('Delivery Address'),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => context.push('/cart/checkout/address'),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: defaultAddr != null
                    ? Text('${defaultAddr.title}: ${defaultAddr.detail}')
                    : const Text(
                        'Chọn địa chỉ giao hàng',
                        style: TextStyle(color: Colors.red),
                      ),
              ),
            ),

            const SizedBox(height: 20),

            /// ─── PAYMENT METHOD (SHOPEE STYLE) ────────
            _sectionTitle('Payment Method'),
            const SizedBox(height: 10),

            if (paymentMgr.isLoading)
              const Center(child: CircularProgressIndicator())
            else ...[
              // ===== COD =====
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: RadioListTile<String>(
                  value: 'cod',
                  groupValue: _paymentMethodId,
                  onChanged: (v) => setState(() => _paymentMethodId = v),
                  secondary: const Icon(Icons.payments, color: Colors.brown),
                  title: const Text('Cash on Delivery (COD)'),
                ),
              ),

              const SizedBox(height: 10),

              // ===== EWALLET =====
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    RadioListTile<String>(
                      value: 'ewallet_group',
                      groupValue: isEwalletSelected ? 'ewallet_group' : null,
                      onChanged: (v) {
                        if (paymentMgr.ewallets.isEmpty) {
                          context.push('/payment/add?type=ewallet');
                        } else {
                          // Auto-select first ewallet if exists
                          setState(() => _paymentMethodId = paymentMgr.ewallets.first.id);
                        }
                      },
                      secondary: const Icon(
                        Icons.account_balance_wallet,
                        color: Colors.orange,
                      ),
                      title: const Text('E-Wallet'),
                    ),

                    // Only show child methods if parent is selected
                    if (isEwalletSelected)
                      ...paymentMgr.ewallets.map((m) {
                        final acc = m.accountNumber;
                        final last4 = acc.length >= 4
                            ? acc.substring(acc.length - 4)
                            : acc;

                        return Card(
                          color: _paymentMethodId == m.id
                              ? Colors.brown.shade50
                              : Colors.white,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          child: ListTile(
                            onTap: () =>
                                setState(() => _paymentMethodId = m.id),
                            leading: _getIcon(m.provider),
                            title: Text(
                              '${m.provider.toUpperCase()} **** $last4',
                            ),
                            trailing: _paymentMethodId == m.id
                                ? const Icon(Icons.check_circle,
                                    color: Colors.brown)
                                : null,
                          ),
                        );
                      }),

                    if (isEwalletSelected)
                      TextButton(
                        onPressed: () =>
                            context.push('/payment/add?type=ewallet'),
                        child: const Text('+ Add new e-wallet'),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // ===== CREDIT/DEBIT CARD =====
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    RadioListTile<String>(
                      value: 'card_group',
                      groupValue: isCardSelected ? 'card_group' : null,
                      onChanged: (v) {
                        if (paymentMgr.cards.isEmpty) {
                          context.push('/payment/add?type=card');
                        } else {
                          // Auto-select first card if exists
                          setState(() => _paymentMethodId = paymentMgr.cards.first.id);
                        }
                      },
                      secondary: const Icon(
                        Icons.credit_card,
                        color: Colors.blue,
                      ),
                      title: const Text('Credit/Debit Card'),
                    ),

                    // Only show child methods if parent is selected
                    if (isCardSelected)
                      ...paymentMgr.cards.map((m) {
                        final acc = m.accountNumber;
                        final last4 = acc.length >= 4
                            ? acc.substring(acc.length - 4)
                            : acc;

                        return Card(
                          color: _paymentMethodId == m.id
                              ? Colors.brown.shade50
                              : Colors.white,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          child: ListTile(
                            onTap: () =>
                                setState(() => _paymentMethodId = m.id),
                            leading: _getIcon(m.provider),
                            title: Text(
                              '${m.provider.toUpperCase()} **** $last4',
                            ),
                            trailing: _paymentMethodId == m.id
                                ? const Icon(Icons.check_circle,
                                    color: Colors.blue)
                                : null,
                          ),
                        );
                      }),

                    if (isCardSelected)
                      TextButton(
                        onPressed: () =>
                            context.push('/payment/add?type=card'),
                        child: const Text('+ Add new card'),
                      ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),

            /// ─── ORDER ITEMS ─────────────────────────
            _sectionTitle('Order Items (${cart.items.length})'),
            const SizedBox(height: 8),
            Column(
              children: cart.items.map((item) {
                return ListTile(
                  title: Text('${item.product.title} x ${item.quantity}'),
                  trailing: Text(
                    '\$${(item.product.price * item.quantity).toStringAsFixed(2)}',
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            /// ─── SUMMARY ─────────────────────────────
            _sectionTitle('Order Summary'),
            _priceRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
            _priceRow(
              'Shipping',
              shipping == 0 ? 'Free' : '\$${shipping.toStringAsFixed(2)}',
            ),
            _priceRow('Tax', '\$${taxes.toStringAsFixed(2)}'),
            _priceRow('Total', '\$${total.toStringAsFixed(2)}', isBold: true),

            const SizedBox(height: 30),

            /// ─── BUTTON ──────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: (orderMgr.isLoading || _paymentMethodId == null)
                    ? null
                    : _placeOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6F4E37),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: orderMgr.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Place Order'),
              ),
            ),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          value,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}