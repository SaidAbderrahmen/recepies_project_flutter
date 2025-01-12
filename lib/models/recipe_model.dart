class Recipe {
  final int id;
  final String name;
  final String thumbnail; 
  final double rating;
  final List<String> tags;
  final List<String> ingredients;
  final List<String> instructions;
  final int prepTime;
  final int cookTime;
  final int servings;
  final String difficulty;
  final String cuisine;
  final int calories;

  Recipe({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.rating,
    required this.tags,
    required this.ingredients,
    required this.instructions,
    required this.prepTime,
    required this.cookTime,
    required this.servings,
    required this.difficulty,
    required this.cuisine,
    required this.calories,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      thumbnail: json['image'] ?? 'https://placehold.co/400',
       
      rating: double.tryParse(json['rating'].toString()) ?? 0.0,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      ingredients: json['ingredients'] != null
          ? List<String>.from(json['ingredients'])
          : [],
       instructions: json['instructions'] != null
          ? List<String>.from(json['instructions'])
          : [],
      prepTime: json["prepTimeMinutes"] ?? 0,
      cookTime: json["cookTimeMinutes"] ?? 0,
      servings: json['servings'] ?? 1,
      difficulty: json['difficulty'] ?? 'Unknown',
      cuisine: json['cuisine'] ?? 'Unknown',
      calories: json["caloriesPerServing"] ?? 0,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Recipe && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
