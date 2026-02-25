import 'package:flutter/material.dart';
import '../../widgets/address_card.dart';

class MyAddressesPage extends StatelessWidget {
  const MyAddressesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6EFE8),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'My Addresses',
          style: TextStyle(color: Colors.black),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ADDRESS LIST
            const AddressCard(
              title: 'Home',
              address: '123 Nguyen Van Linh, Ninh Kieu, Can Tho',
              isSelected: true,
            ),
            const AddressCard(
              title: 'Office',
              address: 'University Campus, Can Tho City',
            ),
            const AddressCard(
              title: 'Other',
              address: 'Cafe Street, Ward 5, District 3',
            ),

            const Spacer(),

            // ADD NEW ADDRESS BUTTON
            Container(
              height: 56,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF6F4E37),
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Center(
                child: Text(
                  '+ Add New Address',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
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
