import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import '../../models/product.dart';
import '../../services/pb_client.dart';

class Category {
  final String id;
  final String name;
  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) =>
      Category(id: json['id'] ?? '', name: json['name'] ?? '');
}

class ProductManager extends ChangeNotifier {
  List<Product> _products = [];
  List<Category> _categories = [];
  String _selectedCategoryId = '';
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
  String get baseUrl => PbClient.baseUrl;

  Future<void> fetchAll() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final pb = await PbClient.instance;
      final results = await Future.wait([
        pb.collection('Category').getFullList(sort: 'name'),
        pb.collection('Product').getFullList(sort: 'title'),
      ]);

      _categories =
          results[0].map((r) => Category.fromJson(r.toJson())).toList();
      _products =
          results[1].map((r) => Product.fromJson(r.toJson())).toList();

      debugPrint(
          'PRODUCTS: ${_products.length} products, ${_categories.length} categories');
    } on ClientException catch (e) {
      debugPrint('PRODUCT FETCH ERROR: ${e.response}');
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