import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final List<String> ingredients;
  final List<String> steps;
  final double rating;        // average rating
  final int ratingCount;      // total number of ratings
  final int cookingTime;      // in minutes
  final DateTime createdAt;
  final String category;

  Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.ingredients,
    required this.steps,
    this.rating = 0.0,
    this.ratingCount = 0,
    this.cookingTime = 30,
    DateTime? createdAt,
    required this.category,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Recipe.fromMap(Map<String, dynamic> data, String documentId) {
    final dynamic createdVal = data['createdAt'];
    DateTime resolvedCreatedAt;

    if (createdVal is Timestamp) {
      resolvedCreatedAt = createdVal.toDate();
    } else if (createdVal is String) {
      resolvedCreatedAt = DateTime.tryParse(createdVal) ?? DateTime.now();
    } else {
      resolvedCreatedAt = DateTime.now();
    }

    return Recipe(
      id: documentId,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      ingredients: List<String>.from(data['ingredients'] ?? []),
      steps: List<String>.from(data['steps'] ?? []),
      rating: (data['rating'] ?? 0).toDouble(),
      ratingCount: (data['ratingCount'] ?? 0).toInt(),
      cookingTime: (data['cookingTime'] ?? 30).toInt(),
      category: data['category'] ?? 'General',
      createdAt: resolvedCreatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'ingredients': ingredients,
      'steps': steps,
      'rating': rating,
      'ratingCount': ratingCount,
      'cookingTime': cookingTime,
      'category': category,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Create a new updated Recipe with new average rating
  Recipe copyWithRating(double newRating, int newCount) {
    return Recipe(
      id: id,
      name: name,
      description: description,
      imageUrl: imageUrl,
      ingredients: ingredients,
      steps: steps,
      rating: newRating,
      ratingCount: newCount,
      cookingTime: cookingTime,
      category: category,
      createdAt: createdAt,
    );
  }
}
