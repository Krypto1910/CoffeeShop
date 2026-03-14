import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/product.dart';

class FavoriteManager extends ChangeNotifier {
  List<Product> _favorites = [];

  List<Product> get favorites => List.unmodifiable(_favorites);

  FavoriteManager() {
    _loadFavorites();
  }

  bool isFavorite(String productId) {
    return _favorites.any((item) => item.id == productId);
  }

  Future<void> toggleFavorite(Product product) async {
    final index = _favorites.indexWhere((item) => item.id == product.id);
    if (index >= 0) {
      _favorites.removeAt(index);
    } else {
      _favorites.add(product);
    }
    await _saveFavorites();
    notifyListeners();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = _favorites.map((p) => jsonEncode({
          'id': p.id,
          'categoryID': p.categoryID,
          'title': p.title,
          'price': p.price,
          'stock': p.stock,
          'description': p.description,
          'imagePath': p.imagePath,
        })).toList();
    await prefs.setStringList('favorites', encoded);
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('favorites');
    if (data != null) {
      _favorites = data.map((item) {
        final decoded = jsonDecode(item) as Map<String, dynamic>;
        return Product.fromJson(decoded);
      }).toList();
      notifyListeners();
    }
  }
}