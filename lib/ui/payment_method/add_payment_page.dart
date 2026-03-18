import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../ui/payment_method/payment_method_manager.dart';

class AddPaymentPage extends StatefulWidget {
  final String type;

  const AddPaymentPage({super.key, required this.type});

  @override
  State<AddPaymentPage> createState() => _AddPaymentPageState();
}

class _AddPaymentPageState extends State<AddPaymentPage> {
  final numberCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final expiryCtrl = TextEditingController();

  late String provider; // ✅ đổi sang late

  @override
  void initState() {
    super.initState();

    // ✅ FIX: set provider mặc định theo type
    if (widget.type == 'card') {
      provider = 'visa';
    } else {
      provider = 'momo';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCard = widget.type == 'card';

    return Scaffold(
      appBar: AppBar(title: const Text('Thêm phương thức')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: provider,
              items: (isCard ? ['visa', 'mastercard'] : ['momo', 'zalopay'])
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e.toUpperCase()),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => provider = v!),
              decoration: const InputDecoration(labelText: 'Provider'),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: numberCtrl,
              decoration: const InputDecoration(
                labelText: 'Số tài khoản / số thẻ',
              ),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 12),

            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Tên chủ tài khoản'),
            ),

            const SizedBox(height: 12),

            if (isCard)
              TextField(
                controller: expiryCtrl,
                decoration: const InputDecoration(labelText: 'Expiry (MM/YY)'),
                keyboardType: TextInputType.datetime,
              ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final userId = context.read<AuthProvider>().user!.id;

                  await context.read<PaymentMethodManager>().add(
                    userId: userId,
                    type: widget.type,
                    provider: provider,
                    number: numberCtrl.text,
                    name: nameCtrl.text,
                    expiry: isCard ? expiryCtrl.text : null,
                  );

                  if (!mounted) return;
                  Navigator.pop(context);
                },
                child: const Text('Lưu'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
