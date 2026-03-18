import 'package:flutter/material.dart';
import '../models/payment_method.dart';

class PaymentCard extends StatelessWidget {
  final PaymentMethodModel method;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentCard({
    super.key,
    required this.method,
    required this.isSelected,
    required this.onTap,
  });

  IconData _getIcon() {
    if (method.type == 'card') return Icons.credit_card;
    return Icons.account_balance_wallet;
  }

  Color _getColor() {
    if (method.provider == 'momo') return Colors.pink;
    if (method.provider == 'zalopay') return Colors.blue;
    return const Color(0xFF6F4E37);
  }

  String _maskNumber(String number) {
    if (number.length < 4) return number;
    return '**** ${number.substring(number.length - 4)}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSelected
                ? [_getColor(), _getColor().withOpacity(0.7)]
                : [Colors.white, Colors.white],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: isSelected ? _getColor() : Colors.grey.shade200,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: isSelected
                  ? Colors.white
                  : _getColor().withOpacity(0.1),
              child: Icon(
                _getIcon(),
                color: isSelected ? _getColor() : _getColor(),
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.accountName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _maskNumber(method.accountNumber),
                    style: TextStyle(
                      color: isSelected ? Colors.white70 : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            if (isSelected) const Icon(Icons.check_circle, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
