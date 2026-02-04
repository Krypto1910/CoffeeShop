import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String price;
  final String imagePath;

  const CartItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imagePath,
              height: 56,
              width: 56,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 12),

          // INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 6),
                Text(
                  price,
                  style: const TextStyle(
                    color: Color(0xFFD45A32),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // ➖ 1 ➕ (NẰM NGANG)
          Row(
            children: [
              _qtyButton(Icons.remove),
              const SizedBox(width: 8),
              const Text('1', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              _qtyButton(Icons.add),
            ],
          ),
        ],
      ),
    );
  }

  Widget _qtyButton(IconData icon) {
    return Container(
      height: 28,
      width: 28,
      decoration: BoxDecoration(
        color: const Color(0xFFF3E1D2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 16),
    );
  }
}
