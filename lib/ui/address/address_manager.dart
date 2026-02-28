import 'package:flutter/material.dart';
import '/models/address.dart';

class AddressManager extends ChangeNotifier {
  final List<Address> _addresses = [];
  int _autoIncrementId = 0;

  List<Address> get addresses => List.unmodifiable(_addresses);

  /// Select address
  void selectAddress(int id) {
    for (var address in _addresses) {
      address.isSelected = address.id == id;
    }
    notifyListeners();
  }

  /// Add address (auto ID safe)
  void addAddress(Address address) {
    final newAddress = Address(
      id: _autoIncrementId++,
      title: address.title,
      detail: address.detail,
      isSelected: _addresses.isEmpty,
    );

    _addresses.add(newAddress);
    notifyListeners();
  }

  /// Update address
  void updateAddress(Address updated) {
    final index = _addresses.indexWhere((a) => a.id == updated.id);

    if (index != -1) {
      _addresses[index] = updated;
      notifyListeners();
    }
  }

  /// Delete address (NO CRASH VERSION)
  void deleteAddress(int id) {
    final index = _addresses.indexWhere((a) => a.id == id);

    if (index == -1) return;

    final wasSelected = _addresses[index].isSelected;

    _addresses.removeAt(index);

    /// Nếu xoá address đang chọn
    if (wasSelected && _addresses.isNotEmpty) {
      _addresses.first.isSelected = true;
    }

    notifyListeners();
  }
}