import 'package:flutter/material.dart';
import '../../models/product.dart';

class CartManager extends ChangeNotifier {
  final Map<Product, int> _items = {};

  Map<Product, int> get items => _items;

  void addToCart(Product product) {
    if (_items.containsKey(product)) {
      _items[product] = _items[product]! + 1;
    } else {
      _items[product] = 1;
    }
    notifyListeners();
  }

  void decrease(Product product) {
    if (!_items.containsKey(product)) return;

    if (_items[product]! > 1) {
      _items[product] = _items[product]! - 1;
    } else {
      _items.remove(product);
    }
    notifyListeners();
  }

  void updateQuantity(Product product, int quantity) {
    _items[product] = quantity;
    notifyListeners();
  }

  void remove(Product product) {
    _items.remove(product);
    notifyListeners();
  }

  int get totalItems => _items.values.fold(0, (sum, qty) => sum + qty);

  double get subtotal => _items.entries.fold(
    0,
    (sum, entry) => sum + entry.key.price * entry.value,
  );
}
