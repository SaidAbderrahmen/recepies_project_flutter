import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/recipe_controller.dart';
import '../controllers/favorites_controller.dart';
import '../controllers/profile_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    Get.lazyPut<RecipeController>(() => RecipeController(), fenix: true);
    Get.lazyPut<FavoritesController>(() => FavoritesController(), fenix: true);
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
  }
}
