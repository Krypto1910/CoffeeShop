import 'package:flutter/material.dart';
import '../../widgets/quantity_selector.dart';
import '../../widgets/option_chip.dart';

class ProductDetailPage extends StatelessWidget {
  final String title;
  final String price;
  final String imagePath;

  const ProductDetailPage({
    super.key,
    required this.title,
    required this.price,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6EFE8),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ===== IMAGE =====
            Padding(
              padding: const EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Image.asset(
                  imagePath,
                  height: 260,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // ===== CONTENT =====
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6F4E37),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: const [
                      Icon(Icons.star, color: Colors.orange, size: 18),
                      SizedBox(width: 4),
                      Text(
                        '4.8 (200 Reviews)',
                        style: TextStyle(color: Colors.grey),
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
                  const Text(
                    'It’s a simple drink that combines creamy dark chocolate '
                    'and freshly brewed coffee. Feel free to use any coffee '
                    'brand or flavor you enjoy.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'See More',
                    style: TextStyle(
                      color: Color(0xFF6F4E37),
                      fontWeight: FontWeight.bold,
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
                    children: const [
                      OptionChip(label: 'Hot', selected: true),
                      OptionChip(label: 'Cold'),
                    ],
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
                    children: const [
                      OptionChip(label: '30%', selected: true),
                      OptionChip(label: '40%'),
                      OptionChip(label: '50%'),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Quantity
                  const QuantitySelector(),

                  const SizedBox(height: 24),

                  // Add to cart
                  Container(
                    height: 56,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6F4E37),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: const Center(
                      child: Text(
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
    );
  }
}
