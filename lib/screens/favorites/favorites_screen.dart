import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/recipe_provider.dart';
import '../../widgets/recipe_card.dart';
import '../recipe/details_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    final favoriteRecipes = recipeProvider.recipes
        .where((r) => favoritesProvider.isFavorite(r.id))
        .toList();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: favoriteRecipes.isEmpty
            ? const Center(
                child: Text("No favorites yet 💔"),
              )
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.8,
                ),
                itemCount: favoriteRecipes.length,
                itemBuilder: (context, index) {
                  final recipe = favoriteRecipes[index];
                  return RecipeCard(
                    recipe: recipe,
                    isFavorite: true,
                    onFavoriteToggle: () =>
                        favoritesProvider.toggleFavorite(recipe.id),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => DetailsScreen(recipe: recipe)),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
