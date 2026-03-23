import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isSignIn = true;

  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // ─── HANDLERS ────────────────────────────────────────────────────
  // Future<void> _handleSubmit() async {
  //   final auth = context.read<AuthProvider>();
  //   final email    = _emailCtrl.text.trim();
  //   final password = _passwordCtrl.text;

  //   if (email.isEmpty || password.isEmpty) {
  //     _showError('Please fulfill the information');
  //     return;
  //   }

  //   if (!_isSignIn) {
  //     final confirmPassword = _confirmPasswordCtrl.text;
  //     if (password != confirmPassword) {
  //       _showError('Passwords do not match');
  //       return;
  //     }
  //   }

  //   final success = _isSignIn
  //       ? await auth.login(email, password)
  //       : await auth.signup(email, password);

  //   if (!mounted) return;
  //   if (success) {
  //     context.go('/home');
  //   } else if (auth.errorMessage != null) {
  //     _showError(auth.errorMessage!);
  //   }
  // }

  Future<void> _handleSubmit() async {
    final auth = context.read<AuthProvider>();
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;

    if (email.isEmpty || password.isEmpty) {
      _showError('Please fulfill the information');
      return;
    }

    if (!_isSignIn) {
      final confirmPassword = _confirmPasswordCtrl.text;
      if (password != confirmPassword) {
        _showError('Passwords do not match');
        return;
      }
    }

    print("==== LOGIN START ====");
    print("EMAIL: $email");
    print("PASSWORD: $password");

    final success = _isSignIn
        ? await auth.login(email, password)
        : await auth.signup(email, password);

    print("SUCCESS: $success");
    print("ERROR MSG: ${auth.errorMessage}");
    print("==== LOGIN END ====");

    if (!mounted) return;

    if (success) {
      print("➡️ LOGIN SUCCESS → NAVIGATE HOME");
      context.go('/home');
    } else {
      print("❌ LOGIN FAILED");
      _showError(auth.errorMessage ?? "Login failed (unknown error)");
    }
  }

  // Future<void> _handleGoogle() async {
  //   final auth = context.read<AuthProvider>();
  //   final success = await auth.loginWithOAuth2('google');
  //   if (!mounted) return;
  //   if (success) {
  //     context.go('/home');
  //   } else if (auth.errorMessage != null) {
  //     _showError(auth.errorMessage!);
  //   }
  // }

  // void _showError(String msg) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(msg),
  //       backgroundColor: Colors.red[700],
  //       behavior: SnackBarBehavior.floating,
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //     ),
  //   );
  // }

  Future<void> _handleGoogle() async {
    final auth = context.read<AuthProvider>();

    print("==== GOOGLE LOGIN START ====");

    final success = await auth.loginWithOAuth2('google');

    print("SUCCESS: $success");
    print("ERROR MSG: ${auth.errorMessage}");
    print("==== GOOGLE LOGIN END ====");

    if (!mounted) return;

    if (success) {
      context.go('/home');
    } else {
      _showError(auth.errorMessage ?? "Google login failed");
    }
  }

  // ─── BUILD ────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final auth = context.watch<AuthProvider>();

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
                // IMAGE HEADER
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                  child: Image.asset(
                    'assets/images/coffee_login.jpg',
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 220,
                      color: const Color(0xFF8B5E3C),
                      child: const Center(
                        child: Icon(
                          Icons.coffee,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // TOGGLE
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _tabButton(
                      'Log In',
                      _isSignIn,
                      () => setState(() {
                        _isSignIn = true;
                        context.read<AuthProvider>().clearError();
                      }),
                    ),
                    _tabButton(
                      'Sign Up',
                      !_isSignIn,
                      () => setState(() {
                        _isSignIn = false;
                        context.read<AuthProvider>().clearError();
                      }),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      _inputField(
                        controller: _emailCtrl,
                        icon: Icons.email_outlined,
                        hint: 'Email Address',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      _inputField(
                        controller: _passwordCtrl,
                        icon: Icons.lock_outline,
                        hint: 'Password',
                        isPassword: true,
                      ),
                      if (!_isSignIn) ...[
                        const SizedBox(height: 16),
                        _inputField(
                          controller: _confirmPasswordCtrl,
                          icon: Icons.lock_outline,
                          hint: 'Confirm Password',
                          isPassword: true,
                        ),
                      ],

                      const SizedBox(height: 24),

                      // SUBMIT BUTTON
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
                          onPressed: auth.isLoading ? null : _handleSubmit,
                          child: auth.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  _isSignIn ? 'Log In' : 'Create Account',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),

                      if (_isSignIn) ...[
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(color: Color(0xFF6F4E37)),
                          ),
                        ),
                      ],

                      const SizedBox(height: 8),

                      // DIVIDER
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'or continue with',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // GOOGLE BUTTON
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            side: const BorderSide(color: Color(0xFFDDCCBB)),
                          ),
                          onPressed: auth.isLoading ? null : _handleGoogle,
                          icon: const Icon(
                            Icons.g_mobiledata,
                            color: Color(0xFF8B5E3C),
                            size: 28,
                          ),
                          label: const Text(
                            'Log in with Google',
                            style: TextStyle(
                              color: Color(0xFF6F4E37),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
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

  // ─── WIDGETS ──────────────────────────────────────────────────────
  Widget _tabButton(String text, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
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
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
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
