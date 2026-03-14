import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../address/address_manager.dart';
import '../../providers/auth_provider.dart';
import '/models/address.dart';

class MyAddressPage extends StatefulWidget {
  const MyAddressPage({super.key});

  @override
  State<MyAddressPage> createState() => _MyAddressPageState();
}

class _MyAddressPageState extends State<MyAddressPage> {
  static const _brown = Color(0xFF6F4E37);
  static const _lightBrown = Color(0xFFEFE3D3);
  static const _bg = Color(0xFFF6EFE8);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthProvider>().user?.id;
      if (userId != null) {
        context.read<AddressManager>().fetchAddresses(userId);
      }
    });
  }

  // ─── BOTTOM SHEET THÊM / SỬA ─────────────────────────────────────
  void _showAddressSheet(BuildContext context, {Address? existing}) {
    final titleCtrl = TextEditingController(text: existing?.title ?? '');
    final detailCtrl = TextEditingController(text: existing?.detail ?? '');
    final formKey = GlobalKey<FormState>();
    final isEdit = existing != null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        // Đẩy sheet lên khi bàn phím xuất hiện
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Title
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _lightBrown,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        isEdit ? Icons.edit_location_alt : Icons.add_location_alt,
                        color: _brown,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      isEdit ? 'Edit Address' : 'New Address',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C1810),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Label field
                _SheetField(
                  controller: titleCtrl,
                  label: 'Label',
                  hint: 'e.g. Home, Office, Gym...',
                  icon: Icons.label_outline,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Vui lòng nhập label' : null,
                ),

                const SizedBox(height: 16),

                // Detail field
                _SheetField(
                  controller: detailCtrl,
                  label: 'Full Address',
                  hint: '123 Nguyen Van Linh, Q7, TP.HCM',
                  icon: Icons.location_on_outlined,
                  maxLines: 3,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Vui lòng nhập địa chỉ' : null,
                ),

                const SizedBox(height: 28),

                // Buttons
                Row(
                  children: [
                    // Cancel
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Color(0xFFD4B896)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: _brown, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Save
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _brown,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () async {
                          if (!formKey.currentState!.validate()) return;
                          Navigator.pop(ctx);

                          final manager = context.read<AddressManager>();
                          bool ok;

                          if (!isEdit) {
                            final userId =
                                context.read<AuthProvider>().user?.id ?? '';
                            ok = await manager.addAddress(
                              userId: userId,
                              title: titleCtrl.text.trim(),
                              detail: detailCtrl.text.trim(),
                            );
                          } else {
                            ok = await manager.updateAddress(
                              addressId: existing.id,
                              title: titleCtrl.text.trim(),
                              detail: detailCtrl.text.trim(),
                            );
                          }

                          if (!ok && context.mounted) {
                            _showSnack(
                              context,
                              manager.errorMessage ?? 'Có lỗi xảy ra',
                              isError: true,
                            );
                          }
                        },
                        child: Text(
                          isEdit ? 'Save Changes' : 'Add Address',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── DELETE DIALOG ────────────────────────────────────────────────
  void _confirmDelete(BuildContext context, Address address) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.delete_outline, color: Colors.red[400], size: 32),
              ),

              const SizedBox(height: 16),

              const Text(
                'Delete Address',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              Text(
                'Xóa "${address.title}"?\nHành động này không thể hoàn tác.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600], height: 1.5),
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: Color(0xFFD4B896)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: _brown, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[400],
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () async {
                        Navigator.pop(ctx);
                        final ok = await context
                            .read<AddressManager>()
                            .deleteAddress(address.id);
                        if (!ok && context.mounted) {
                          _showSnack(context, 'Xóa thất bại', isError: true);
                        }
                      },
                      child: const Text(
                        'Delete',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnack(BuildContext context, String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red[700] : _brown,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // ─── BUILD ────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF2C1810)),
        title: const Text(
          'My Addresses',
          style: TextStyle(
            color: Color(0xFF2C1810),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Consumer<AddressManager>(
        builder: (context, manager, _) {
          if (manager.isLoading && manager.addresses.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: _brown),
            );
          }

          return Stack(
            children: [
              // ─── LIST ──────────────────────────────────────────────
              manager.addresses.isEmpty
                  ? _EmptyState(
                      onAdd: () => _showAddressSheet(context),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                      itemCount: manager.addresses.length,
                      itemBuilder: (context, index) {
                        final addr = manager.addresses[index];
                        return _AddressCard(
                          address: addr,
                          isLoading: manager.isLoading,
                          onSetDefault: () => manager.setDefault(addr.id),
                          onEdit: () =>
                              _showAddressSheet(context, existing: addr),
                          onDelete: () => _confirmDelete(context, addr),
                        );
                      },
                    ),

              // ─── FAB ADD BUTTON ────────────────────────────────────
              if (manager.addresses.isNotEmpty)
                Positioned(
                  bottom: 24,
                  left: 16,
                  right: 16,
                  child: _AddButton(
                    isLoading: manager.isLoading,
                    onTap: () => _showAddressSheet(context),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

// ─── EMPTY STATE ──────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: const Color(0xFFEFE3D3),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_off_outlined,
              size: 48,
              color: Color(0xFF6F4E37),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No addresses yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C1810),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your delivery address to\nget started',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[500], height: 1.5),
          ),
          const SizedBox(height: 32),
          _AddButton(onTap: onAdd),
        ],
      ),
    );
  }
}

// ─── ADD BUTTON ───────────────────────────────────────────────────
class _AddButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isLoading;
  const _AddButton({required this.onTap, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6F4E37),
          elevation: 4,
          shadowColor: const Color(0xFF6F4E37).withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        onPressed: isLoading ? null : onTap,
        icon: const Icon(Icons.add_location_alt_outlined,
            color: Colors.white, size: 22),
        label: const Text(
          'Add New Address',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// ─── ADDRESS CARD ─────────────────────────────────────────────────
class _AddressCard extends StatelessWidget {
  final Address address;
  final bool isLoading;
  final VoidCallback onSetDefault;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AddressCard({
    required this.address,
    required this.isLoading,
    required this.onSetDefault,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDefault = address.isDefault;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isDefault
            ? Border.all(color: const Color(0xFF6F4E37), width: 2)
            : Border.all(color: Colors.transparent, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── ICON ───────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDefault
                    ? const Color(0xFF6F4E37)
                    : const Color(0xFFEFE3D3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isDefault ? Icons.home_rounded : Icons.location_on_outlined,
                color: isDefault ? Colors.white : const Color(0xFF6F4E37),
                size: 22,
              ),
            ),

            const SizedBox(width: 14),

            // ─── CONTENT ────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        address.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF2C1810),
                        ),
                      ),
                      if (isDefault) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6F4E37).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Default',
                            style: TextStyle(
                              color: Color(0xFF6F4E37),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 6),

                  Text(
                    address.detail,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),

                  if (!isDefault) ...[
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: isLoading ? null : onSetDefault,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.radio_button_unchecked,
                              size: 14, color: Colors.grey[400]),
                          const SizedBox(width: 4),
                          Text(
                            'Set as default',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // ─── ACTIONS ────────────────────────────────────────────
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ActionButton(
                  icon: Icons.edit_outlined,
                  color: const Color(0xFF6F4E37),
                  onTap: isLoading ? null : onEdit,
                ),
                const SizedBox(height: 4),
                _ActionButton(
                  icon: Icons.delete_outline,
                  color: Colors.red[400]!,
                  onTap: isLoading ? null : onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── ACTION BUTTON ────────────────────────────────────────────────
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }
}

// ─── SHEET FIELD ──────────────────────────────────────────────────
class _SheetField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final int maxLines;
  final String? Function(String?)? validator;

  const _SheetField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
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
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            prefixIcon: Icon(icon, color: const Color(0xFF6F4E37), size: 20),
            filled: true,
            fillColor: const Color(0xFFF6EFE8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFEFE3D3), width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
                  const BorderSide(color: Color(0xFF6F4E37), width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}