import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import '../../models/product.dart';
import '../../services/pb_client.dart';

class CartItem {
  final String id;
  final Product product;
  int quantity;

  CartItem({required this.id, required this.product, required this.quantity});
}

class CartManager extends ChangeNotifier {
  List<CartItem> _items = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<CartItem> get items => List.unmodifiable(_items);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isEmpty => _items.isEmpty;
  int get totalItems => _items.fold(0, (s, i) => s + i.quantity);
  double get subtotal =>
      _items.fold(0.0, (s, i) => s + i.product.price * i.quantity);
  String get baseUrl => PbClient.baseUrl;

  // ─── FETCH ────────────────────────────────────────────────────────
  Future<void> fetchCart(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final pb = await PbClient.instance;
      final records = await pb.collection('CartItem').getFullList(
        filter: 'userID = "$userId"',
        expand: 'productID',
      );

      _items = records.map((r) {
        final productRecord = r.expand['productID']?.first;
        final product = productRecord != null
            ? Product.fromJson(productRecord.toJson())
            : Product(
                id: r.getStringValue('productID'),
                categoryID: '',
                title: 'Unknown',
                price: 0,
                stock: 0,
                description: '',
                imagePath: '',
              );
        return CartItem(
          id: r.id,
          product: product,
          quantity: r.getIntValue('quantity'),
        );
      }).toList();

      debugPrint('CART: loaded ${_items.length} items');
    } on ClientException catch (e) {
      debugPrint('CART FETCH ERROR: ${e.response}');
      _errorMessage = e.response['message']?.toString() ?? 'Lỗi tải giỏ hàng';
    } catch (e) {
      debugPrint('CART EXCEPTION: $e');
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ─── ADD TO CART ──────────────────────────────────────────────────
  Future<void> addToCart(String userId, Product product, {int qty = 1}) async {
    try {
      final pb = await PbClient.instance;
      final existingIndex =
          _items.indexWhere((i) => i.product.id == product.id);

      if (existingIndex >= 0) {
        final item = _items[existingIndex];
        final newQty = item.quantity + qty;
        await pb.collection('CartItem').update(
          item.id,
          body: {'quantity': newQty},
        );
        _items[existingIndex].quantity = newQty;
        debugPrint('CART: qty updated ${product.title} → $newQty');
      } else {
        final record = await pb.collection('CartItem').create(body: {
          'userID': userId,
          'productID': product.id,
          'quantity': qty,
          'options': {},
        });
        _items.add(CartItem(id: record.id, product: product, quantity: qty));
        debugPrint('CART: added ${product.title}');
      }
      notifyListeners();
    } on ClientException catch (e) {
      debugPrint('ADD TO CART ERROR: ${e.response}');
      _errorMessage = e.response['message']?.toString() ?? 'Lỗi thêm vào giỏ';
      notifyListeners();
    } catch (e) {
      debugPrint('ADD TO CART EXCEPTION: $e');
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // ─── INCREASE / DECREASE / UPDATE / REMOVE ────────────────────────
  Future<void> increase(CartItem item) async =>
      _updateQty(item, item.quantity + 1);

  Future<void> decrease(CartItem item) async {
    if (item.quantity <= 1) {
      await remove(item);
    } else {
      await _updateQty(item, item.quantity - 1);
    }
  }

  Future<void> updateQuantity(CartItem item, int newQty) async {
    if (newQty <= 0) {
      await remove(item);
    } else {
      await _updateQty(item, newQty);
    }
  }

  Future<void> remove(CartItem item) async {
    try {
      final pb = await PbClient.instance;
      await pb.collection('CartItem').delete(item.id);
      _items.removeWhere((i) => i.id == item.id);
      notifyListeners();
    } on ClientException catch (e) {
      _errorMessage = e.response['message']?.toString() ?? 'Lỗi xóa';
      notifyListeners();
    }
  }

  Future<void> clearCart() async {
    try {
      final pb = await PbClient.instance;
      for (final item in List.from(_items)) {
        await pb.collection('CartItem').delete(item.id);
      }
      _items = [];
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> _updateQty(CartItem item, int newQty) async {
    try {
      final pb = await PbClient.instance;
      await pb.collection('CartItem').update(
        item.id,
        body: {'quantity': newQty},
      );
      item.quantity = newQty;
      notifyListeners();
    } on ClientException catch (e) {
      _errorMessage = e.response['message']?.toString() ?? 'Lỗi cập nhật';
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}