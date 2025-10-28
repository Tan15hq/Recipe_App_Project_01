import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/firestore_service.dart';

class RecipeProvider extends ChangeNotifier {
  final _firestore = FirestoreService();
  List<Recipe> _recipes = [];
  bool isLoading = true;

  List<Recipe> get recipes => _recipes;

  void listenToRecipes() {
    isLoading = true;
    notifyListeners();

    _firestore.streamRecipes().listen((data) {
      print('Recipes fetched: ${data.length}');
      _recipes = data;
      isLoading = false;
      notifyListeners();
    }, onError: (error) {
      print('Error fetching recipes: $error');
      isLoading = false;
      notifyListeners();
    });

  }
}
