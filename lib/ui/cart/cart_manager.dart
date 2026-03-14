import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/product.dart';

/// CartItem local — đại diện cho 1 dòng trong giỏ hàng
class CartItem {
  final String id;       // PocketBase record ID
  final Product product;
  int quantity;

  CartItem({
    required this.id,
    required this.product,
    required this.quantity,
  });
}

class CartManager extends ChangeNotifier {
  PocketBase? _pb;

  List<CartItem> _items = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<CartItem> get items => List.unmodifiable(_items);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isEmpty => _items.isEmpty;

  int get totalItems => _items.fold(0, (sum, i) => sum + i.quantity);
  double get subtotal =>
      _items.fold(0, (sum, i) => sum + i.product.price * i.quantity);

  // ─── BASE URL ─────────────────────────────────────────────────────
  String get _baseUrl {
    if (kIsWeb) return 'http://127.0.0.1:8090';
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8090';
    }
    return 'http://127.0.0.1:8090';
  }

  Future<PocketBase> _getPb() async {
    if (_pb != null) return _pb!;
    final prefs = await SharedPreferences.getInstance();
    final store = AsyncAuthStore(
      save: (data) async => prefs.setString('pb_auth', data),
      initial: prefs.getString('pb_auth'),
    );
    _pb = PocketBase(_baseUrl, authStore: store);
    return _pb!;
  }

  // ─── FETCH giỏ hàng của user ──────────────────────────────────────
  Future<void> fetchCart(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final pb = await _getPb();

      // Lấy CartItem kèm expand Product
      final records = await pb.collection('CartItem').getFullList(
        filter: 'userID = "$userId"',
        expand: 'productID', // expand relation để lấy thông tin product
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
    } on ClientException catch (e) {
      _errorMessage = e.response['message']?.toString() ?? 'Lỗi tải giỏ hàng';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ─── THÊM sản phẩm vào giỏ ───────────────────────────────────────
  Future<void> addToCart(String userId, Product product, {int qty = 1}) async {
    try {
      final pb = await _getPb();

      // Kiểm tra đã có trong giỏ chưa
      final existing = _items.where((i) => i.product.id == product.id);

      if (existing.isNotEmpty) {
        // Tăng quantity
        final item = existing.first;
        final newQty = item.quantity + qty;
        await pb.collection('CartItem').update(
          item.id,
          body: {'quantity': newQty},
        );
        item.quantity = newQty;
      } else {
        // Tạo mới
        final record = await pb.collection('CartItem').create(body: {
          'userID': userId,
          'productID': product.id,
          'quantity': qty,
          'options': {},
        });
        _items.add(CartItem(
          id: record.id,
          product: product,
          quantity: qty,
        ));
      }

      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // ─── TĂNG quantity ────────────────────────────────────────────────
  Future<void> increase(CartItem item) async {
    await _updateQty(item, item.quantity + 1);
  }

  // ─── GIẢM quantity (nếu về 0 thì xóa) ───────────────────────────
  Future<void> decrease(CartItem item) async {
    if (item.quantity <= 1) {
      await remove(item);
    } else {
      await _updateQty(item, item.quantity - 1);
    }
  }

  // ─── SET quantity trực tiếp ───────────────────────────────────────
  Future<void> updateQuantity(CartItem item, int newQty) async {
    if (newQty <= 0) {
      await remove(item);
    } else {
      await _updateQty(item, newQty);
    }
  }

  // ─── XÓA 1 item ──────────────────────────────────────────────────
  Future<void> remove(CartItem item) async {
    try {
      final pb = await _getPb();
      await pb.collection('CartItem').delete(item.id);
      _items.removeWhere((i) => i.id == item.id);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // ─── XÓA TOÀN BỘ giỏ hàng ────────────────────────────────────────
  Future<void> clearCart() async {
    try {
      final pb = await _getPb();
      for (final item in _items) {
        await pb.collection('CartItem').delete(item.id);
      }
      _items = [];
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // ─── HELPER ───────────────────────────────────────────────────────
  Future<void> _updateQty(CartItem item, int newQty) async {
    try {
      final pb = await _getPb();
      await pb.collection('CartItem').update(
        item.id,
        body: {'quantity': newQty},
      );
      item.quantity = newQty;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  String get baseUrl => _baseUrl;
}