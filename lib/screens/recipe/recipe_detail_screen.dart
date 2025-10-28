import 'package:flutter/material.dart';
import '../../models/recipe.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;
  const RecipeDetailScreen({required this.recipe, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recipe.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Image.network(recipe.imageUrl),
          const SizedBox(height: 16),
          Text(recipe.description, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 16),
          const Text('Ingredients', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ...recipe.ingredients.map((i) => Text("• $i")),
          const SizedBox(height: 16),
          const Text('Steps', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ...recipe.steps.asMap().entries.map((e) => Text("${e.key + 1}. ${e.value}")),
        ],
      ),
    );
  }
}
