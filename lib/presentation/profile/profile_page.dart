import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6EFE8),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Profile', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ===== AVATAR =====
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: const [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Color(0xFF6F4E37),
                    child: Icon(Icons.person, size: 48, color: Colors.white),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Tong Khanh Linh',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 4),
                  Text('linh@email.com', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ===== MENU =====
            _ProfileItem(
              icon: Icons.edit,
              title: 'Edit Profile',
              onTap: () {
                context.push('/profile/edit');
              },
            ),
            _ProfileItem(
              icon: Icons.receipt_long,
              title: 'Order History',
              onTap: () {
                context.push('/profile/orders');
              },
            ),
            _ProfileItem(
              icon: Icons.location_on,
              title: 'My Address',
              onTap: () {
                context.push('/profile/addresses');
              },
            ),
            _ProfileItem(
              icon: Icons.credit_card,
              title: 'Payment Method',
              onTap: () {
                context.push('/profile/payment');
              },
            ),

            const SizedBox(height: 12),

            // ===== LOGOUT =====
            _ProfileItem(
              icon: Icons.logout,
              title: 'Logout',
              isLogout: true,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

// ===== ITEM WIDGET =====
class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isLogout;

  const _ProfileItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Icon(icon, color: isLogout ? Colors.red : const Color(0xFF6F4E37)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: isLogout ? Colors.red : Colors.black,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14),
          ],
        ),
      ),
    );
  }
}
