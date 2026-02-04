import 'package:flutter/material.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6EFE8),

      // ===== APP BAR =====
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Order History',
          style: TextStyle(color: Colors.black),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.separated(
          itemCount: demoOrders.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final order = demoOrders[index];

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===== ORDER ID + STATUS =====
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Order #${order.id}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: order.status == 'Completed'
                              ? Colors.green.withOpacity(0.15)
                              : Colors.red.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          order.status,
                          style: TextStyle(
                            color: order.status == 'Completed'
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // ===== DATE =====
                  Text(order.date, style: const TextStyle(color: Colors.grey)),

                  const SizedBox(height: 12),

                  // ===== TOTAL =====
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total', style: TextStyle(color: Colors.grey)),
                      Text(
                        order.total,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF6F4E37),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ===== DEMO DATA (sau này thay bằng API / SQLite) =====
class OrderModel {
  final String id;
  final String date;
  final String total;
  final String status;

  OrderModel({
    required this.id,
    required this.date,
    required this.total,
    required this.status,
  });
}

final List<OrderModel> demoOrders = [
  OrderModel(
    id: '102345',
    date: 'Sep 20, 2025',
    total: '\$250',
    status: 'Completed',
  ),
  OrderModel(
    id: '102112',
    date: 'Sep 15, 2025',
    total: '\$180',
    status: 'Completed',
  ),
  OrderModel(
    id: '101998',
    date: 'Sep 10, 2025',
    total: '\$90',
    status: 'Cancelled',
  ),
];
