import 'package:flutter/material.dart';

class ShoppingProvider extends ChangeNotifier {
  final List<String> _ingredients = [];

  List<String> get ingredients => List.unmodifiable(_ingredients);

  int get itemCount => _ingredients.length; // ✅ Item count for cart badge

  void addIngredient(String ingredient) {
    _ingredients.add(ingredient);
    notifyListeners();
  }

  void addIngredients(List<String> ingredients) {
    _ingredients.addAll(ingredients);
    notifyListeners();
  }

  void removeIngredient(String ingredient) {
    _ingredients.remove(ingredient);
    notifyListeners();
  }

  void clearCart() {
    _ingredients.clear();
    notifyListeners();
  }
}
