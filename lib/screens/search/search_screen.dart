import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/recipe_provider.dart';
import '../../widgets/recipe_card.dart';
import '../recipe/details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final recipes = Provider.of<RecipeProvider>(context).recipes
        .where((r) => r.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text("Find a Recipe 🔍",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search recipes...',
                prefixIcon: const Icon(Icons.search),
                filled: true, // enables background color
                fillColor: const Color.fromARGB(209, 244, 244, 241),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none
                ),
              ),
              onChanged: (value) => setState(() => query = value),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: recipes.isEmpty
                  ? const Center(child: Text("No recipes found"))
                  : ListView.builder(
                      itemCount: recipes.length,
                      itemBuilder: (context, i) {
                        final recipe = recipes[i];
                        return RecipeCard(
                          recipe: recipe,
                          isFavorite: false,
                          onFavoriteToggle: () {},
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => DetailsScreen(recipe: recipe)),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
