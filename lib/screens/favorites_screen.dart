import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/favorites_controller.dart';
import '../models/recipe_model.dart';
import '../routes/app_pages.dart';

class FavoritesScreen extends StatelessWidget {
  FavoritesScreen({Key? key}) : super(key: key);

  final FavoritesController _favoritesController = Get.find<FavoritesController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Favorites',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Obx(() {
            if (_favoritesController.favoriteRecipes.isNotEmpty) {
              return IconButton(
                icon: const Icon(Icons.delete_sweep),
                onPressed: () {
                  _showClearConfirmation(context);
                },
                tooltip: 'Clear all favorites',
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: Obx(() {
        if (_favoritesController.favoriteRecipes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No favorites yet',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Start adding your favorite recipes!',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[500],
                      ),
                ),
              ],
            ),
          );
        }

        return AnimatedList(
          key: GlobalKey<AnimatedListState>(),
          initialItemCount: _favoritesController.favoriteRecipes.length,
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index, animation) {
            final recipe = _favoritesController.favoriteRecipes[index];
            return SlideTransition(
              position: animation.drive(Tween(
                begin: const Offset(1, 0),
                end: Offset.zero,
              )),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: FavoriteRecipeCard(
                  recipe: recipe,
                  onDelete: () => _showDeleteConfirmation(context, recipe),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Recipe recipe) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove from Favorites'),
        content: Text('Are you sure you want to remove "${recipe.name}" from your favorites?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
                                          Get.back();

              _favoritesController.removeFromFavorites(recipe);

              Get.snackbar(
                'Recipe Removed',
                '${recipe.name} has been removed from your favorites',
                snackPosition: SnackPosition.BOTTOM,
                margin: const EdgeInsets.all(16),
              );
                           
                                          Get.back();


            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _showClearConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Favorites'),
        content: const Text('Are you sure you want to remove all recipes from your favorites?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _favoritesController.clearFavorites();
              Get.back();
              Get.snackbar(
                'Favorites Cleared',
                'All recipes have been removed from your favorites',
                snackPosition: SnackPosition.BOTTOM,
                margin: const EdgeInsets.all(16),
              );
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}

class FavoriteRecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onDelete;

  const FavoriteRecipeCard({
    Key? key,
    required this.recipe,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => Get.toNamed(Routes.recipeDetails, arguments: recipe),
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            // Recipe Image
            Hero(
              tag: 'recipe_${recipe.id}',
              child: ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(12),
                ),
                child: Image.network(
                  recipe.thumbnail,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Recipe Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            recipe.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: onDelete,
                          color: Colors.grey[600],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          recipe.rating.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.timer_outlined,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${recipe.prepTime + recipe.cookTime} min',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 4,
                      children: recipe.tags
                          .take(2)
                          .map((tag) => Chip(
                                label: Text(
                                  tag,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                padding: EdgeInsets.zero,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}