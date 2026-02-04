import 'package:flutter/material.dart';

class OrderSuccessPage extends StatelessWidget {
  const OrderSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6EFE8),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ===== SUCCESS ICON =====
            Container(
              height: 140,
              width: 140,
              decoration: const BoxDecoration(
                color: Color(0xFF6F4E37),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 80,
              ),
            ),

            const SizedBox(height: 32),

            // ===== TITLE =====
            const Text(
              'Order Successful!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            // ===== DESCRIPTION =====
            const Text(
              'Your order has been placed successfully.\n'
              'You can track your order anytime.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),

            const SizedBox(height: 40),

            // ===== BACK TO HOME =====
            Container(
              height: 56,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF6F4E37),
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Center(
                child: Text(
                  'Back to Home',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ===== VIEW ORDER (OPTIONAL) =====
            Container(
              height: 56,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: const Color(0xFF6F4E37)),
              ),
              child: const Center(
                child: Text(
                  'View Order',
                  style: TextStyle(
                    color: Color(0xFF6F4E37),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
