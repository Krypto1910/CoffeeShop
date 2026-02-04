import 'package:flutter/material.dart';

class QuantitySelector extends StatelessWidget {
  const QuantitySelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('With Milk', style: TextStyle(fontWeight: FontWeight.bold)),
        const Spacer(),
        _buildButton(Icons.remove),
        const SizedBox(width: 12),
        const Text('2', style: TextStyle(fontSize: 16)),
        const SizedBox(width: 12),
        _buildButton(Icons.add),
      ],
    );
  }

  Widget _buildButton(IconData icon) {
    return Container(
      height: 32,
      width: 32,
      decoration: BoxDecoration(
        color: const Color(0xFFF2E3D5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 18),
    );
  }
}
