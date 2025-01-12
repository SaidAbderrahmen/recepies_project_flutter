import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/recipe_model.dart';

class RecipeController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<Recipe> recipeList = <Recipe>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse('https://dummyjson.com/recipes'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['recipes'] != null) {
          recipeList.value = (data['recipes'] as List)
              .map((recipe) => Recipe.fromJson(recipe))
              .toList();
        }
      } else {
        Get.snackbar('Error', 'Failed to load recipes');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
