import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/product.dart';

class FavoriteManager with ChangeNotifier {
  List<Product> _favorites = [];

  List<Product> get favorites => [..._favorites];

  FavoriteManager() {
    _loadFavorites();
  }

  bool isFavorite(String productId) {
    return _favorites.any((item) => item.id == productId);
  }

  Future<void> toggleFavorite(Product product) async {
    final index =
        _favorites.indexWhere((item) => item.id == product.id);

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

    final encodedList = _favorites.map((product) {
      return jsonEncode({
        'id': product.id,
        'title': product.title,
        'price': product.price,
        'oldPrice': product.oldPrice,
        'imagePath': product.imagePath,
      });
    }).toList();

    await prefs.setStringList('favorites', encodedList);
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('favorites');

    if (data != null) {
      _favorites = data.map((item) {
        final decoded = jsonDecode(item);
        return Product(
          id: decoded['id'],
          title: decoded['title'],
          price: decoded['price'],
          oldPrice: decoded['oldPrice'],
          imagePath: decoded['imagePath'],
        );
      }).toList();

      notifyListeners();
    }
  }
}