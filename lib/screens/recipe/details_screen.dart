import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/recipe.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/shopping_provider.dart';
import '../../services/firestore_service.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:animations/animations.dart';
import 'package:shimmer/shimmer.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailsScreen extends StatefulWidget {
  final Recipe recipe;
  const DetailsScreen({Key? key, required this.recipe}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen>
    with TickerProviderStateMixin {
  final _firestore = FirestoreService();
  double _userRating = 0.0;
  final _reviewController = TextEditingController();

  late AnimationController _imageController;
  late Animation<double> _imageAnimation;

  @override
  void initState() {
    super.initState();

    // Animation for image fade-in
    _imageController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _imageAnimation = CurvedAnimation(
      parent: _imageController,
      curve: Curves.easeOut,
    );
    _imageController.forward();
  }

  @override
  void dispose() {
    _reviewController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  void _submitRating() async {
    if (_userRating == 0.0) return;
    await _firestore.updateRating(widget.recipe.id, _userRating);

    if (_reviewController.text.isNotEmpty) {
      await _firestore.addReview(
        widget.recipe.id,
        _reviewController.text.trim(),
        _userRating,
      );
    }

    _reviewController.clear();
    setState(() => _userRating = 0.0);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Thanks for your feedback!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final shoppingProvider = Provider.of<ShoppingProvider>(context);
    final isFavorite = favoritesProvider.isFavorite(widget.recipe.id);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFCF5), // Cream
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.transparent,
            expandedHeight: 250,
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.orangeAccent,
                ),
                onPressed: () =>
                    favoritesProvider.toggleFavorite(widget.recipe.id),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: FadeTransition(
                opacity: _imageAnimation,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(24),
                  ),
                  child: Image.network(
                    widget.recipe.imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 250,
                          width: double.infinity,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Text(widget.recipe.name,
                      style: GoogleFonts.poppins(
                          fontSize: 26, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange[400]),
                      const SizedBox(width: 4),
                      Text(
                        "${widget.recipe.rating.toStringAsFixed(1)} (${widget.recipe.ratingCount})",
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(widget.recipe.description,
                      style: GoogleFonts.poppins(fontSize: 16)),
                  const SizedBox(height: 24),

                  // Ingredients & Steps Side by Side
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Ingredients",
                                style: GoogleFonts.poppins(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            for (var i in widget.recipe.ingredients)
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 2),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.orange[50],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text("• $i",
                                    style: GoogleFonts.poppins(fontSize: 16)),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Steps",
                                style: GoogleFonts.poppins(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            for (var s in widget.recipe.steps)
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 2),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.green[50],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text("• $s",
                                    style: GoogleFonts.poppins(fontSize: 16)),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Add to Cart Button
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: Colors.orangeAccent),
                    onPressed: () {
                      shoppingProvider.addIngredients(widget.recipe.ingredients);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Added to shopping cart!")),
                      );
                    },
                    icon: const Icon(Icons.shopping_cart),
                    label: Text("Add Ingredients to Cart",
                        style: GoogleFonts.poppins(fontSize: 16)),
                  ),
                  const SizedBox(height: 24),

                  // Rating Section
                  Text("Rate this recipe",
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  RatingBar.builder(
                    initialRating: 0,
                    minRating: 1,
                    allowHalfRating: true,
                    itemBuilder: (context, _) =>
                        const Icon(Icons.star, color: Colors.orangeAccent),
                    onRatingUpdate: (r) => setState(() => _userRating = r),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _reviewController,
                    decoration: InputDecoration(
                      hintText: "Leave a review (optional)",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _submitRating,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        minimumSize: const Size.fromHeight(45)),
                    child: Text("Submit",
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w500)),
                  ),

                  const SizedBox(height: 24),

                  // User Reviews
                  Text("User Reviews",
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  StreamBuilder<List<Map<String, dynamic>>>(
                    stream: _firestore.streamReviews(widget.recipe.id),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            height: 80,
                            color: Colors.white,
                          ),
                        );
                      }
                      final reviews = snapshot.data!;
                      if (reviews.isEmpty) {
                        return Text("No reviews yet.", style: GoogleFonts.poppins());
                      }
                      return Column(
                        children: reviews.map((r) {
                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            margin: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 0),
                            child: ListTile(
                              leading: Icon(Icons.star,
                                  color: Colors.orange[400], size: 20),
                              title: Text(r['text'] ?? "",
                                  style: GoogleFonts.poppins()),
                              subtitle: Text(
                                  "Rating: ${r['rating']?.toStringAsFixed(1)}",
                                  style: GoogleFonts.poppins(fontSize: 12)),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
