import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteProvider with ChangeNotifier {
  Set<String> _favoriteIds = {};

  Set<String> get favoriteIds => _favoriteIds;

  FavoriteProvider() {
    _loadFavorites();
  }

  // Memuat data favorit dari penyimpanan
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? saved = prefs.getStringList('favorites');
    if (saved != null) {
      _favoriteIds = saved.toSet();
      notifyListeners();
    }
  }

  // Menyimpan data favorit ke penyimpanan
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', _favoriteIds.toList());
  }

  void toggleFavorite(String recipeId) async {
    if (_favoriteIds.contains(recipeId)) {
      _favoriteIds.remove(recipeId);
    } else {
      _favoriteIds.add(recipeId);
    }
    await _saveFavorites();
    notifyListeners();
  }

  bool isFavorite(String recipeId) {
    return _favoriteIds.contains(recipeId);
  }
}
