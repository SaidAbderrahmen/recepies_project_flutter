import 'package:get/get.dart';
import '../models/recipe_model.dart';

class FavoritesController extends GetxController {
  RxList<Recipe> favoriteRecipes = <Recipe>[].obs;

  void addToFavorites(Recipe recipe) {
    if (!favoriteRecipes.contains(recipe)) {
      favoriteRecipes.add(recipe);
      Get.snackbar('Success', 'Recipe added to favorites!');
    }
  }

  void removeFromFavorites(Recipe recipe) {
    favoriteRecipes.remove(recipe);
    Get.snackbar('Removed', 'Recipe removed from favorites.');
  }

  bool isFavorite(Recipe recipe) {
    return favoriteRecipes.contains(recipe);
  }
  void clearFavorites() {

    favoriteRecipes.clear();

  }

}
