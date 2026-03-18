import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'payment_method_manager.dart';

class PaymentMethodPage extends StatefulWidget {
  const PaymentMethodPage({super.key});

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  @override
  void initState() {
    super.initState();
    final userId = context.read<AuthProvider>().user?.id;
    if (userId != null) {
      context.read<PaymentMethodManager>().fetch(userId);
    }
  }

  void _showAddDialog(bool isCard) {
    final numberCtrl = TextEditingController();
    final nameCtrl = TextEditingController();
    final expiryCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isCard ? 'Add Card' : 'Add E-Wallet'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: numberCtrl,
              decoration: const InputDecoration(labelText: 'Number'),
            ),
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            if (isCard)
              TextField(
                controller: expiryCtrl,
                decoration: const InputDecoration(labelText: 'Expiry'),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx), // ✅ FIX
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final userId = context.read<AuthProvider>().user?.id;

              if (userId == null) return;

              await context.read<PaymentMethodManager>().add(
                userId: userId,
                type: isCard ? 'card' : 'ewallet',
                provider: isCard ? 'visa' : 'momo',
                number: numberCtrl.text.trim(),
                name: nameCtrl.text.trim(),
                expiry: expiryCtrl.text.trim(),
              );

              if (!mounted) return;

              // 🔥 Reload lại list
              await context.read<PaymentMethodManager>().fetch(userId);

              Navigator.pop(ctx); // ✅ FIX QUAN TRỌNG
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  String _maskNumber(String number) {
    if (number.isEmpty) return '';
    if (number.length < 4) return number;
    return '**** ${number.substring(number.length - 4)}';
  }

  @override
  Widget build(BuildContext context) {
    final mgr = context.watch<PaymentMethodManager>();

    return Scaffold(
      appBar: AppBar(title: const Text('Payment Methods')),
      body: mgr.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (mgr.methods.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Text('No payment methods yet'),
                    ),
                  ),

                ...mgr.methods.map((m) {
                  final number = m.accountNumber ?? '';

                  return ListTile(
                    leading: Icon(
                      m.type == 'card'
                          ? Icons.credit_card
                          : Icons.account_balance_wallet,
                    ),
                    title: Text(m.accountName ?? ''),
                    subtitle: Text(_maskNumber(number)),
                  );
                }),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () => _showAddDialog(true),
                  child: const Text('Add Card'),
                ),

                ElevatedButton(
                  onPressed: () => _showAddDialog(false),
                  child: const Text('Add E-Wallet'),
                ),
              ],
            ),
    );
  }
}
