import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF6F1),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: size.width * 0.85,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                // 🔝 IMAGE HEADER
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                  child: Image.asset(
                    'assets/images/coffee_login.jpg',
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 20),

                // 🔘 SIGN IN / SIGN UP TOGGLE
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _tabButton("Sign In", true),
                    _tabButton("Sign Up", false),
                  ],
                ),

                const SizedBox(height: 24),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      _inputField(
                        icon: Icons.email_outlined,
                        hint: "Email Address",
                      ),
                      const SizedBox(height: 16),
                      _inputField(
                        icon: Icons.lock_outline,
                        hint: "Password",
                        isPassword: true,
                      ),

                      const SizedBox(height: 24),

                      // 🔘 SIGN IN BUTTON
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8B5E3C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {},
                          child: const Text(
                            "Sign In",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(color: Color(0xFF6F4E37)),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // 🌐 SOCIAL LOGIN
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          _SocialIcon(icon: Icons.facebook),
                          SizedBox(width: 16),
                          _SocialIcon(icon: Icons.g_mobiledata),
                        ],
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= COMPONENTS =================

  Widget _tabButton(String text, bool active) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: active ? const Color(0xFF8B5E3C) : Colors.transparent,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: active ? Colors.white : const Color(0xFF8B5E3C),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _inputField({
    required IconData icon,
    required String hint,
    bool isPassword = false,
  }) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF8B5E3C)),
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFEFE3D3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

// 🌐 SOCIAL ICON
class _SocialIcon extends StatelessWidget {
  final IconData icon;
  const _SocialIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 22,
      backgroundColor: const Color(0xFFEFE3D3),
      child: Icon(icon, color: const Color(0xFF8B5E3C)),
    );
  }
}
