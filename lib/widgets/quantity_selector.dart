import 'package:flutter/material.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onChanged,
    this.min = 1,
    this.max = 99,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Quantity',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFEFE3D3).withOpacity(0.6),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              // ─── MINUS ─────────────────────────────────────────────
              _QtyButton(
                icon: Icons.remove,
                onTap: quantity > min
                    ? () => onChanged(quantity - 1)
                    : null,
              ),

              // ─── NUMBER ────────────────────────────────────────────
              SizedBox(
                width: 40,
                child: Text(
                  '$quantity',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

              // ─── PLUS ──────────────────────────────────────────────
              _QtyButton(
                icon: Icons.add,
                onTap: quantity < max
                    ? () => onChanged(quantity + 1)
                    : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _QtyButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: enabled ? const Color(0xFF6F4E37) : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          size: 18,
          color: enabled ? Colors.white : Colors.grey[500],
        ),
      ),
    );
  }
}