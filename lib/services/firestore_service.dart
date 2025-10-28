import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  Stream<List<Recipe>> streamRecipes() {
    return _db.collection('recipes').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Recipe.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  Future<void> addRecipe(Recipe recipe) async {
    await _db.collection('recipes').add(recipe.toMap());
  }

  Future<void> deleteRecipe(String id) async {
    await _db.collection('recipes').doc(id).delete();
  }

  Future<void> updateRating(String id, double newRating) async {
    final docRef = _db.collection('recipes').doc(id);
    await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) return;

      final currentRating = (snapshot['rating'] ?? 0).toDouble();
      final currentCount = (snapshot['ratingCount'] ?? 0).toInt();

      final updatedCount = currentCount + 1;
      final updatedRating =
          ((currentRating * currentCount) + newRating) / updatedCount;

      transaction.update(docRef, {
        'rating': updatedRating,
        'ratingCount': updatedCount,
      });
    });
  }

  Future<void> addReview(String recipeId, String text, double rating) async {
    await _db.collection('recipes/$recipeId/reviews').add({
      'text': text,
      'rating': rating,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
  Future<void> updateRecipeRating(String recipeId, double newRating) async {
    final recipeRef = _db.collection('recipes').doc(recipeId);

    await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(recipeRef);
      if (!snapshot.exists) return;

      final currentRating = (snapshot['rating'] ?? 0).toDouble();
      final ratingCount = (snapshot['ratingCount'] ?? 0).toInt();

      final total = (currentRating * ratingCount) + newRating;
      final newCount = ratingCount + 1;
      final updatedAverage = total / newCount;

      transaction.update(recipeRef, {
        'rating': updatedAverage,
        'ratingCount': newCount,
      });
    });
  }
  Stream<List<Map<String, dynamic>>> streamReviews(String recipeId) {
    return _db
        .collection('recipes/$recipeId/reviews')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => doc.data()).toList());
  }
}
