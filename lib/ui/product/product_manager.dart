import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/product.dart';

class Category {
  final String id;
  final String name;
  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json['id'] ?? '', name: json['name'] ?? '');
  }
}

class ProductManager extends ChangeNotifier {
  PocketBase? _pb;

  List<Product> _products = [];
  List<Category> _categories = [];
  String _selectedCategoryId = ''; // '' = All
  bool _isLoading = false;
  String? _errorMessage;

  List<Product> get products => _selectedCategoryId.isEmpty
      ? List.unmodifiable(_products)
      : List.unmodifiable(
          _products.where((p) => p.categoryID == _selectedCategoryId).toList(),
        );

  List<Category> get categories => List.unmodifiable(_categories);
  String get selectedCategoryId => _selectedCategoryId;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String get _baseUrl {
    if (kIsWeb) return 'http://127.0.0.1:8090';
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8090';
    }
    return 'http://127.0.0.1:8090';
  }

  String get baseUrl => _baseUrl;

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

  // ─── FETCH TẤT CẢ ────────────────────────────────────────────────
  Future<void> fetchAll() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final pb = await _getPb();

      final results = await Future.wait([
        pb.collection('Category').getFullList(),
        pb.collection('Product').getFullList(sort: 'title'),
      ]);

      _categories = results[0]
          .map((r) => Category.fromJson(r.toJson()))
          .toList();

      _products = results[1]
          .map((r) => Product.fromJson(r.toJson()))
          .toList();
    } on ClientException catch (e) {
      _errorMessage = e.response['message']?.toString() ?? 'Lỗi tải sản phẩm';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectCategory(String categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }
}