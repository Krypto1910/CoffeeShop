import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../ui/product/product_manager.dart'; // Đảm bảo đường dẫn này đúng với project của bạn

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  // 🔥 Hàm hiển thị menu sắp xếp giá chuyển từ HomePage sang đây
  void _showSortDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                "Sort by",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.arrow_upward, color: Color(0xFF6F4E37)),
              title: const Text("Price: Low → High"),
              onTap: () {
                context.read<ProductManager>().setSort(SortType.priceAsc);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.arrow_downward,
                color: Color(0xFF6F4E37),
              ),
              title: const Text("Price: High → Low"),
              onTap: () {
                context.read<ProductManager>().setSort(SortType.priceDesc);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.restore, color: Colors.grey),
              title: const Text("Default"),
              onTap: () {
                context.read<ProductManager>().setSort(SortType.none);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 60, 16, 32),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF3E1D2), Color(0xFFE8CDB7)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + bell
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Enjoy your\nMorning Coffee!!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              Icon(Icons.notifications_none),
            ],
          ),

          const SizedBox(height: 20),

          // Search bar + Nút Sort
          Row(
            children: [
              Expanded(
                // Đã chuyển thành TextField để gõ trực tiếp
                child: TextField(
                  onChanged: (value) {
                    context.read<ProductManager>().setSearch(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search something',
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                // Gắn hàm show dialog sắp xếp vào nút này
                onTap: () => _showSortDialog(context),
                child: Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6F4E37),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.tune, color: Colors.white),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Hero image
          Center(
            child: Container(
              height: 160,
              width: 160,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/images/coffee.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
