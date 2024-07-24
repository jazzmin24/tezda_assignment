import 'package:flutter/material.dart';

class FavoriteProvider with ChangeNotifier {
  final Set<String> _favorites = {};

  Set<String> get favorites => _favorites;

  void toggleFavorite(String productId) {
    if (_favorites.contains(productId)) {
      _favorites.remove(productId);
    } else {
      _favorites.add(productId);
    }
    notifyListeners();
  }

  bool isFavorite(String productId) {
    return _favorites.contains(productId);
  }
}
