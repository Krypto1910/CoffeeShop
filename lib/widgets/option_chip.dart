import 'package:flutter/material.dart';

class OptionChip extends StatelessWidget {
  final String label;
  final bool selected;

  const OptionChip({super.key, required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF6F4E37) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF6F4E37)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : const Color(0xFF6F4E37),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
