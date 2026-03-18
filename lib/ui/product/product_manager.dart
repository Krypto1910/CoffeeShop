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

enum SortType { none, priceAsc, priceDesc }

class ProductManager extends ChangeNotifier {
  List<Product> _products = [];
  List<Category> _categories = [];

  String _selectedCategoryId = '';
  String _searchQuery = '';
  double? _minPrice;
  double? _maxPrice;
  SortType _sortType = SortType.none;

  bool _isLoading = false;
  String? _errorMessage;

  List<Product> get products {
    List<Product> result = _products.where((p) {
      if (_selectedCategoryId.isNotEmpty && p.categoryID != _selectedCategoryId)
        return false;

      if (_searchQuery.isNotEmpty &&
          !p.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        return false;

      if (_minPrice != null && p.price < _minPrice!) return false;
      if (_maxPrice != null && p.price > _maxPrice!) return false;

      return true;
    }).toList();

    // SORT
    if (_sortType == SortType.priceAsc) {
      result.sort((a, b) => a.price.compareTo(b.price));
    } else if (_sortType == SortType.priceDesc) {
      result.sort((a, b) => b.price.compareTo(a.price));
    }

    return result;
  }

  List<Category> get categories => _categories;
  String get selectedCategoryId => _selectedCategoryId;
  SortType get sortType => _sortType;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  double? get minPrice => _minPrice;
  double? get maxPrice => _maxPrice;

  void setSearch(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  void setSort(SortType type) {
    _sortType = type;
    notifyListeners();
  }

  void setPriceFilter({double? min, double? max}) {
    _minPrice = min;
    _maxPrice = max;
    notifyListeners();
  }

  void clearFilter() {
    _searchQuery = '';
    _minPrice = null;
    _maxPrice = null;
    _selectedCategoryId = '';
    _sortType = SortType.none;
    notifyListeners();
  }

  void selectCategory(String categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  Future<void> fetchAll() async {
    _isLoading = true;
    notifyListeners();

    try {
      final pb = await PbClient.instance;

      final results = await Future.wait([
        pb.collection('Category').getFullList(sort: 'name'),
        pb.collection('Product').getFullList(sort: 'title'),
      ]);

      _categories = results[0]
          .map((e) => Category.fromJson(e.toJson()))
          .toList();

      _products = results[1].map((e) => Product.fromJson(e.toJson())).toList();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
