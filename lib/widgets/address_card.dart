import 'package:flutter/material.dart';

class AddressCard extends StatelessWidget {
  final String title;
  final String address;
  final bool isSelected;

  const AddressCard({
    super.key,
    required this.title,
    required this.address,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? const Color(0xFF6F4E37) : Colors.transparent,
          width: 2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ICON
          Container(
            height: 44,
            width: 44,
            decoration: const BoxDecoration(
              color: Color(0xFFF3E1D2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.location_on, color: Color(0xFF6F4E37)),
          ),

          const SizedBox(width: 12),

          // TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  address,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),

          // EDIT ICON
          const Icon(Icons.edit, size: 20, color: Colors.grey),
        ],
      ),
    );
  }
}
