import 'package:get/get.dart';
import 'auth_controller.dart';

class ProfileController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();

  String get displayName => _authController.user?.displayName ?? 'No Name';
  String get email => _authController.user?.email ?? 'No Email';

  void signOut() {
    _authController.signOut();
  }
}
