import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String title;
  final String price;
  final String oldPrice;
  final String imagePath;
  final VoidCallback? onTap; // ⭐ thêm onTap

  const ProductCard({
    super.key,
    required this.title,
    required this.price,
    required this.oldPrice,
    required this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // ⭐ bắt sự kiện tap
      child: Container(
        width: 170,
        child: Stack(
          children: [
            // CARD
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // IMAGE
                  Container(
                    height: 110,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E1D2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Image.asset(
                        imagePath,
                        height: 80,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // TITLE
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // RATING + HEART
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Row(
                        children: [
                          Icon(Icons.star, size: 14, color: Colors.orange),
                          SizedBox(width: 4),
                          Text('4.3 (105)', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      Icon(Icons.favorite_border, size: 18),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // PRICE
                  Row(
                    children: [
                      Text(
                        price,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        oldPrice,
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

            // ➕ BUTTON
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                height: 42,
                width: 42,
                decoration: const BoxDecoration(
                  color: Color(0xFF6F4E37),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
