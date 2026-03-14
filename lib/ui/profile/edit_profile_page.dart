import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;

  File? _pickedImage; // ảnh vừa chọn từ gallery, chưa upload

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    _nameCtrl  = TextEditingController(text: user?.name ?? '');
    _emailCtrl = TextEditingController(text: user?.email ?? '');
    _phoneCtrl = TextEditingController(text: user?.phone ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  // ─── PICK ẢNH ─────────────────────────────────────────────────────
  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 512,
    );
    if (picked == null) return;
    setState(() => _pickedImage = File(picked.path));
  }

  // ─── SAVE ─────────────────────────────────────────────────────────
  Future<void> _save() async {
    final auth = context.read<AuthProvider>();

    // 1. Upload avatar nếu có ảnh mới
    if (_pickedImage != null) {
      final ok = await auth.uploadAvatar(_pickedImage!);
      if (!ok && mounted) {
        _showSnack(auth.errorMessage ?? 'Upload avatar thất bại', isError: true);
        return;
      }
    }

    // 2. Update text fields
    final ok = await auth.updateProfile(
      name: _nameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
    );

    if (!mounted) return;
    if (ok) {
      _showSnack('Cập nhật thành công!');
      context.pop();
    } else {
      _showSnack(auth.errorMessage ?? 'Cập nhật thất bại', isError: true);
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red[700] : const Color(0xFF6F4E37),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // ─── BUILD ────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final avatarUrl = auth.getAvatarUrl();

    return Scaffold(
      backgroundColor: const Color(0xFFF6EFE8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('Edit Profile', style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ─── AVATAR ─────────────────────────────────────────────
            Center(
              child: GestureDetector(
                onTap: auth.isLoading ? null : _pickImage,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: const Color(0xFF6F4E37),
                      // Ưu tiên: ảnh vừa pick > avatar từ server > icon
                      backgroundImage: _pickedImage != null
                          ? FileImage(_pickedImage!) as ImageProvider
                          : (avatarUrl != null ? NetworkImage(avatarUrl) : null),
                      child: (_pickedImage == null && avatarUrl == null)
                          ? const Icon(Icons.person, size: 55, color: Colors.white)
                          : null,
                    ),

                    // Loading overlay khi đang upload
                    if (auth.isLoading)
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.black38,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      ),

                    // Edit icon
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 34,
                        width: 34,
                        decoration: const BoxDecoration(
                          color: Color(0xFF6F4E37),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),
            Text(
              'Nhấn vào ảnh để thay đổi',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),

            const SizedBox(height: 28),

            // ─── FORM ────────────────────────────────────────────────
            _buildField(
              label: 'Full Name',
              controller: _nameCtrl,
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 16),
            _buildField(
              label: 'Email',
              controller: _emailCtrl,
              icon: Icons.email_outlined,
              enabled: false, // email không cho sửa
            ),
            const SizedBox(height: 16),
            _buildField(
              label: 'Phone Number',
              controller: _phoneCtrl,
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 32),

            // ─── SAVE BUTTON ─────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6F4E37),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                onPressed: auth.isLoading ? null : _save,
                child: auth.isLoading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Save Changes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ─── FIELD WIDGET ─────────────────────────────────────────────────
  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6F4E37),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF6F4E37)),
            filled: true,
            fillColor: enabled ? Colors.white : Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}