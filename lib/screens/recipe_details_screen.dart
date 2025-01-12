import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/favorites_controller.dart';
import '../models/recipe_model.dart';

class RecipeDetailsScreen extends StatelessWidget {
  const RecipeDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recipe = Get.arguments as Recipe;
    final FavoritesController favoritesController = Get.find<FavoritesController>();

    return Scaffold(
      body: Obx(() {
        bool isFavorite = favoritesController.isFavorite(recipe);
        
        return CustomScrollView(
          slivers: [
            // Collapsible app bar with image
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  recipe.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(color: Colors.black45, blurRadius: 2)],
                  ),
                ),
                background: Hero(
                  tag: 'recipe_${recipe.id}',
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        recipe.thumbnail,
                        fit: BoxFit.cover,
                      ),
                      // Gradient overlay for better text visibility
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black54],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.white,
                  ),
                  onPressed: () {
                    if (isFavorite) {
                      favoritesController.removeFromFavorites(recipe);
                    } else {
                      favoritesController.addToFavorites(recipe);
                    }
                  },
                ),
              ],
            ),

            // Recipe quick info
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildInfoCard(
                          Icons.timer,
                          '${recipe.prepTime + recipe.cookTime} min',
                          'Total Time',
                        ),
                        _buildInfoCard(
                          Icons.restaurant,
                          recipe.difficulty,
                          'Difficulty',
                        ),
                        _buildInfoCard(
                          Icons.local_fire_department,
                          '${recipe.calories}',
                          'Calories',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSection(
                      'Tags',
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: recipe.tags.map((tag) => Chip(
                          label: Text(tag),
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        )).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Ingredients section
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: _buildSection(
                  'Ingredients',
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recipe.ingredients.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            const Icon(Icons.fiber_manual_record, size: 8),
                            const SizedBox(width: 8),
                            Expanded(child: Text(recipe.ingredients[index])),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // Instructions section
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: _buildSection(
                  'Instructions',
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recipe.instructions.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(recipe.instructions[index]),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // Reviews section
          
          
          ],
        );
      }),
    );
  }

  Widget _buildInfoCard(IconData icon, String value, String label) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            Icon(icon),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        content,
        const SizedBox(height: 24),
      ],
    );
  }
}