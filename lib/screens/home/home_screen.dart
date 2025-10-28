import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:animations/animations.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/recipe.dart';
import '../../providers/recipe_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/shopping_provider.dart';
import '../../services/auth_service.dart';
import '../../widgets/recipe_card.dart';
import '../recipe/details_screen.dart';
import '../cart/shopping_cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  String _searchQuery = '';
  String _sortOption = 'Top Rated';
  String _selectedCategory = "All";
  late AnimationController _fabController;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RecipeProvider>(context, listen: false).listenToRecipes();
    });
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  void _logout() async {
    await AuthService().signOut();
  }

  void _openProfileMenu() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SizedBox(
        height: 150,
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                _logout();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _openFilterMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sort & Filter Recipes',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    leading: Radio<String>(
                      value: 'Top Rated',
                      groupValue: _sortOption,
                      onChanged: (value) {
                        setModalState(() => _sortOption = value!);
                      },
                    ),
                    title: const Text('Top Rated'),
                  ),
                  ListTile(
                    leading: Radio<String>(
                      value: 'Quick',
                      groupValue: _sortOption,
                      onChanged: (value) {
                        setModalState(() => _sortOption = value!);
                      },
                    ),
                    title: const Text('Quick Recipes'),
                  ),
                  ListTile(
                    leading: Radio<String>(
                      value: 'Easy',
                      groupValue: _sortOption,
                      onChanged: (value) {
                        setModalState(() => _sortOption = value!);
                      },
                    ),
                    title: const Text('Easy Recipes (<=20 min)'),
                  ),
                  ListTile(
                    leading: Radio<String>(
                      value: 'Recent',
                      groupValue: _sortOption,
                      onChanged: (value) {
                        setModalState(() => _sortOption = value!);
                      },
                    ),
                    title: const Text('Recently Added'),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {});
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('Apply'),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  List<Recipe> _getFilteredRecipes(List<Recipe> recipes) {
    if (_selectedCategory != "All") {
      recipes = recipes.where((r) => r.category == _selectedCategory).toList();
    }
    recipes = recipes
        .where((r) => r.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    switch (_sortOption) {
      case 'Quick':
        return recipes..sort((a, b) => a.cookingTime.compareTo(b.cookingTime));
      case 'Recent':
        return recipes..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      case 'Easy':
        return recipes.where((r) => r.cookingTime <= 20).toList();
      default:
        return recipes..sort((a, b) => b.rating.compareTo(a.rating));
    }
  }

  Widget _buildDiscoverTab() {
    final recipeProvider = Provider.of<RecipeProvider>(context);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final shoppingProvider = Provider.of<ShoppingProvider>(context);

    if (recipeProvider.isLoading) {
      return _buildShimmerList();
    }

    final recipes = _getFilteredRecipes(recipeProvider.recipes);

    return RefreshIndicator(
      onRefresh: () async {
        Provider.of<RecipeProvider>(context, listen: false).listenToRecipes();
      },
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Find a Recipe 🍳",
                  style: GoogleFonts.poppins(
                      fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                GestureDetector(
                  onTap: _openProfileMenu,
                  child: CircleAvatar(
                    backgroundColor: Colors.orangeAccent,
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                ),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (value) => setState(() => _searchQuery = value),
                        decoration: InputDecoration(
                          hintText: 'Search recipes...',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Filter Button
                    ElevatedButton(
                      onPressed: _openFilterMenu,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(14),
                        backgroundColor: Colors.orangeAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Icon(Icons.filter_list, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 45,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  _buildCategoryChip("All"),
                  _buildCategoryChip("Breakfast"),
                  _buildCategoryChip("Lunch"),
                  _buildCategoryChip("Dinner"),
                  _buildCategoryChip("Dessert"),
                  _buildCategoryChip("Vegan"),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            sliver: recipes.isEmpty
                ? SliverToBoxAdapter(child: _buildEmptyState())
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final recipe = recipes[index];
                        final isFavorite = favoritesProvider.isFavorite(recipe.id);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: OpenContainer(
                            closedElevation: 0,
                            closedShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            transitionDuration: const Duration(milliseconds: 500),
                            closedBuilder: (context, openContainer) =>
                                RecipeCard(
                              recipe: recipe,
                              isFavorite: isFavorite,
                              onFavoriteToggle: () =>
                                  favoritesProvider.toggleFavorite(recipe.id),
                              onTap: openContainer,
                            ),
                            openBuilder: (context, _) =>
                                DetailsScreen(recipe: recipe),
                          ),
                        );
                      },
                      childCount: recipes.length,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesTab() {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final recipeProvider = Provider.of<RecipeProvider>(context);

    final favoriteRecipes = recipeProvider.recipes
        .where((r) => favoritesProvider.isFavorite(r.id))
        .toList();

    if (favoriteRecipes.isEmpty) return _buildEmptyState();

    return ListView.builder(
      padding: const EdgeInsets.all(12),
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
            MaterialPageRoute(builder: (_) => DetailsScreen(recipe: recipe)),
          ),
        );
      },
    );
  }

  Widget _buildCreateRecipeTab() {
    return Center(
      child: Text(
        'AI Recipe Creator\nComing Soon!',
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(fontSize: 20),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.fastfood, size: 60, color: Colors.grey),
          const SizedBox(height: 12),
          Text(
            "No recipes found",
            style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 6,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          height: 120,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    final isSelected = _selectedCategory == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => setState(() => _selectedCategory = label),
        selectedColor: Colors.orangeAccent,
        backgroundColor: Colors.grey[100],
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      _buildDiscoverTab(),
      _buildFavoritesTab(),
      _buildCreateRecipeTab(),
    ];

    final shoppingProvider = Provider.of<ShoppingProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: tabs[_currentIndex],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const ShoppingCartScreen()));
        },
        icon: const Icon(Icons.shopping_cart),
        label: Text('${shoppingProvider.itemCount}'),
        backgroundColor: Colors.orangeAccent,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 252, 248, 244),
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Discover'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Create'),
        ],
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
