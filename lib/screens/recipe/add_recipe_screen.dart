//import '../models/recipe.dart';
import 'package:recipe/services/firestore_service.dart';
import 'package:recipe/models/recipe.dart';

final firestore = FirestoreService();

Future<void> addSampleRecipes() async {
  await firestore.addRecipe(Recipe(
    id: '', // Firestore assigns ID
    name: 'Spaghetti Carbonara',
    description: 'Creamy Italian pasta with bacon and cheese.',
    imageUrl: 'https://images.unsplash.com/photo-1589307001871-2e66c6a74d0d',
    category: 'vegan',
    ingredients: [
      '200g spaghetti',
      '100g bacon',
      '2 eggs',
      '50g Parmesan cheese',
      'Salt & pepper'
    ],
    steps: [
      'Boil spaghetti until al dente.',
      'Fry bacon until crispy.',
      'Whisk eggs and Parmesan together.',
      'Mix spaghetti with bacon and egg mixture.',
      'Serve with extra Parmesan and black pepper.'
    ],
  ));

  await firestore.addRecipe(Recipe(
    id: '',
    name: 'Avocado Toast',
    description: 'Simple breakfast with mashed avocado on toast.',
    imageUrl: 'https://images.unsplash.com/photo-1551183053-bf91a1d81141',
    category: 'vegan',
    ingredients: [
      '2 slices of bread',
      '1 ripe avocado',
      'Salt & pepper',
      'Lemon juice'
    ],
    steps: [
      'Toast the bread slices.',
      'Mash avocado with salt, pepper, and lemon juice.',
      'Spread avocado on toast.',
      'Serve immediately.'
    ],
  ));

}
