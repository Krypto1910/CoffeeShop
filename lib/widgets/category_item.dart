import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final String title;

  const CategoryItem({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.coffee, color: Color(0xFF6F4E37)),
          ),
          const SizedBox(height: 8),
          Text(title),
        ],
      ),
    );
  }
}
