import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../ui/address/address_manager.dart';

class ChooseAddressPage extends StatefulWidget {
  const ChooseAddressPage({super.key});

  @override
  State<ChooseAddressPage> createState() => _ChooseAddressPageState();
}

class _ChooseAddressPageState extends State<ChooseAddressPage> {
  String? _selectedId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userId = context.read<AuthProvider>().user?.id;
      if (userId != null) {
        await context.read<AddressManager>().fetchAddresses(userId);
        // Pre-select default address
        final defaultAddr = context.read<AddressManager>().defaultAddress;
        if (defaultAddr != null && mounted) {
          setState(() => _selectedId = defaultAddr.id);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final addressMgr = context.watch<AddressManager>();
    final addresses = addressMgr.addresses;

    return Scaffold(
      backgroundColor: const Color(0xFFF6EFE8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('Choose Address',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: addressMgr.isLoading && addresses.isEmpty
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF6F4E37)))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // ─── LIST ──────────────────────────────────────────
                  Expanded(
                    child: addresses.isEmpty
                        ? const Center(
                            child: Text('Chưa có địa chỉ nào',
                                style: TextStyle(color: Colors.grey)),
                          )
                        : ListView.separated(
                            itemCount: addresses.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final addr = addresses[index];
                              final isSelected = _selectedId == addr.id;

                              return GestureDetector(
                                onTap: () =>
                                    setState(() => _selectedId = addr.id),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFF6F4E37)
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.04),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      // Radio
                                      Container(
                                        height: 22,
                                        width: 22,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: const Color(0xFF6F4E37),
                                            width: 2,
                                          ),
                                        ),
                                        child: isSelected
                                            ? Center(
                                                child: Container(
                                                  height: 12,
                                                  width: 12,
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Color(0xFF6F4E37),
                                                  ),
                                                ),
                                              )
                                            : null,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  addr.title,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                if (addr.isDefault) ...[
                                                  const SizedBox(width: 8),
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 6,
                                                        vertical: 2),
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xFF6F4E37),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: const Text(
                                                      'Default',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10),
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              addr.detail,
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 13),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),

                  const SizedBox(height: 12),

                  // ─── CONFIRM BUTTON ────────────────────────────────
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
                      onPressed: _selectedId == null
                          ? null
                          : () async {
                              // Set address được chọn làm default
                              await context
                                  .read<AddressManager>()
                                  .setDefault(_selectedId!);
                              if (context.mounted) context.pop();
                            },
                      child: const Text(
                        'Confirm Address',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ─── ADD NEW ───────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF6F4E37)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      onPressed: () => context.push('/profile/addresses'),
                      icon: const Icon(Icons.add_location_alt_outlined,
                          color: Color(0xFF6F4E37)),
                      label: const Text(
                        'Add New Address',
                        style: TextStyle(
                          color: Color(0xFF6F4E37),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}