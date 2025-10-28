// lib/utils/add_sample_recipes.dart
import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/firestore_service.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firestore = FirestoreService();

  final recipes = [
    Recipe(
      id: '', // Firestore will assign an ID
      name: 'Spaghetti Carbonara',
      description: 'Creamy Italian pasta with bacon and cheese.',
      imageUrl: 'https://images.unsplash.com/photo-1589307001871-2e66c6a74d0d',
      ingredients: [
        '200g spaghetti',
        '100g bacon',
        '2 eggs',
        '50g Parmesan cheese',
        'Salt & pepper'
      ],
      category: 'vegan',
      steps: [
        'Boil spaghetti until al dente.',
        'Fry bacon until crispy.',
        'Whisk eggs and Parmesan together.',
        'Mix spaghetti with bacon and egg mixture.',
        'Serve with extra Parmesan and black pepper.'
      ],
    ),
    Recipe(
      id: '',
      name: 'Avocado Toast',
      description: 'Simple breakfast with mashed avocado on toast.',
      imageUrl: 'https://images.unsplash.com/photo-1551183053-bf91a1d81141',
      ingredients: [
        '2 slices of bread',
        '1 ripe avocado',
        'Salt & pepper',
        'Lemon juice'
      ],
      category: 'vegan',
      steps: [
        'Toast the bread slices.',
        'Mash avocado with salt, pepper, and lemon juice.',
        'Spread avocado on toast.',
        'Serve immediately.'
      ],
    ),
    // Add more recipes here...
  ];

  for (var recipe in recipes) {
    await firestore.addRecipe(recipe);
    print('Added recipe: ${recipe.name}');
  }

  print('All sample recipes added!');
}
