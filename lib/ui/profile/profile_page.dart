import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    final avatarUrl = auth.getAvatarUrl();

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
            // ─── AVATAR + INFO ───────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color(0xFF6F4E37),
                    backgroundImage: avatarUrl != null
                        ? NetworkImage(avatarUrl)
                        : null,
                    child: avatarUrl == null
                        ? const Icon(Icons.person, size: 48, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user?.displayName ?? '—',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? '',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  // Hiện phone nếu có
                  if (user?.phone != null && user!.phone!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      user.phone!,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ─── MENU ────────────────────────────────────────────────
            _ProfileItem(
              icon: Icons.edit,
              title: 'Edit Profile',
              onTap: () => context.push('/profile/edit'),
            ),
            _ProfileItem(
              icon: Icons.receipt_long,
              title: 'Order History',
              onTap: () => context.push('/profile/orders'),
            ),
            _ProfileItem(
              icon: Icons.location_on,
              title: 'My Address',
              onTap: () => context.push('/profile/addresses'),
            ),
            _ProfileItem(
              icon: Icons.credit_card,
              title: 'Payment Method',
              onTap: () => context.push('/profile/payment'),
            ),

            const SizedBox(height: 12),

            // ─── LOGOUT ──────────────────────────────────────────────
            _ProfileItem(
              icon: Icons.logout,
              title: 'Logout',
              isLogout: true,
              onTap: () => _confirmLogout(context, auth),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context, AuthProvider auth) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc muốn đăng xuất không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Huỷ'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(210, 223, 30, 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await auth.logout();
            },
            child: const Text(
              'Đăng xuất',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── ITEM WIDGET ─────────────────────────────────────────────────
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
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}