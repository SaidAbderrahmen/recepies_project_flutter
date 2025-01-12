import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../routes/app_pages.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Rxn<User> firebaseUser = Rxn<User>();
  var isLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
    // Bind user state changes
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  void _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAllNamed(Routes.login);
    } else {
      Get.offAllNamed(Routes.home);
    }
  }

  Future<void> register(String email, String password) async {
        isLoading.value = true;

    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
    finally {
      isLoading.value = false;
    }
  }

  Future<void> login(String email, String password) async {
        isLoading.value = true;

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (_auth.currentUser != null) {
        Get.offAllNamed(Routes.home);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
    finally {
      isLoading.value = false;
    }
  }

  Future<void> googleSignIn() async {
    isLoading.value = true;
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return; // canceled

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
    finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  User? get user => firebaseUser.value;
}
