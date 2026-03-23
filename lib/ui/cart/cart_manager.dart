import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import '../../models/product.dart';
import '../../services/pb_client.dart';

class CartItem {
  final String id;
  final Product product;
  int quantity;

  CartItem({
    required this.id,
    required this.product,
    required this.quantity,
  });
}

class CartManager extends ChangeNotifier {
  final List<CartItem> _items = [];

  bool _isLoading = false;
  String? _errorMessage;

  // 🔥 LOCK + QUEUE (fix race condition)
  final Map<String, Future> _locks = {};
  bool _globalLock = false;

  List<CartItem> get items => List.unmodifiable(_items);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isEmpty => _items.isEmpty;

  int get totalItems =>
      _items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      _items.fold(0, (sum, item) => sum + item.product.price * item.quantity);

  String get baseUrl => PbClient.baseUrl;

  // ───────────────── FETCH ─────────────────
  Future<void> fetchCart(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final pb = await PbClient.instance;

      final records = await pb.collection('CartItem').getFullList(
        filter: 'userID = "$userId"',
        expand: 'productID',
      );

      _items.clear();

      for (final r in records) {
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

        _items.add(CartItem(
          id: r.id,
          product: product,
          quantity: r.getIntValue('quantity'),
        ));
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // ───────────────── CORE LOCK ─────────────────
  Future<void> _runLocked(String key, Future<void> Function() action) async {
    final prev = _locks[key] ?? Future.value();

    final completer = Completer();
    _locks[key] = completer.future;

    await prev;

    try {
      await action();
    } finally {
      completer.complete();
      _locks.remove(key);
    }
  }

  // ───────────────── ADD TO CART ─────────────────
  Future<void> addToCart(String userId, Product product,
      {int qty = 1}) async {
    await _runLocked(product.id, () async {
      final pb = await PbClient.instance;

      final index =
          _items.indexWhere((i) => i.product.id == product.id);

      if (index >= 0) {
        final item = _items[index];
        final newQty = item.quantity + qty;

        // optimistic update
        item.quantity = newQty;
        notifyListeners();

        await pb.collection('CartItem').update(
          item.id,
          body: {'quantity': newQty},
        );
      } else {
        final record = await pb.collection('CartItem').create(body: {
          'userID': userId,
          'productID': product.id,
          'quantity': qty,
        });

        _items.add(CartItem(
          id: record.id,
          product: product,
          quantity: qty,
        ));

        notifyListeners();
      }
    });
  }

  // ───────────────── UPDATE QTY ─────────────────
  Future<void> _updateQty(CartItem item, int newQty) async {
    await _runLocked(item.id, () async {
      final pb = await PbClient.instance;

      // optimistic
      final oldQty = item.quantity;
      item.quantity = newQty;
      notifyListeners();

      try {
        await pb.collection('CartItem').update(
          item.id,
          body: {'quantity': newQty},
        );
      } catch (e) {
        // rollback nếu fail
        item.quantity = oldQty;
        notifyListeners();
      }
    });
  }

  // ───────────────── REMOVE ─────────────────
  Future<void> remove(CartItem item) async {
    await _runLocked(item.id, () async {
      final pb = await PbClient.instance;

      _items.removeWhere((i) => i.id == item.id);
      notifyListeners();

      await pb.collection('CartItem').delete(item.id);
    });
  }

  // ───────────────── CLEAR CART ─────────────────
  Future<void> clearCart() async {
    if (_globalLock) return;
    _globalLock = true;

    final pb = await PbClient.instance;

    final backup = List<CartItem>.from(_items);
    _items.clear();
    notifyListeners();

    try {
      await Future.wait(
        backup.map((item) =>
            pb.collection('CartItem').delete(item.id)),
      );
    } catch (e) {
      _items.addAll(backup); // rollback
      notifyListeners();
    }

    _globalLock = false;
  }

  // ───────────────── LEGACY METHODS (FIX ERROR) ─────────────────
  // 👉 để UI cũ không bị lỗi

  Future<void> increase(CartItem item) async {
    await _updateQty(item, item.quantity + 1);
  }

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

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}