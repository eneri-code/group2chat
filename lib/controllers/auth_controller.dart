import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../routes/app_routes.dart';
import '../core/utils/helpers.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  RxBool isLoading = false.obs;
  Rx<User?> firebaseUser = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    // Listen to authentication state changes
    firebaseUser.bindStream(_authService.authStateChanges);
  }

  // 🔹 Get Current User ID
  String get currentUserId => firebaseUser.value?.uid ?? '';

  // 🔹 Sign Up
  Future<void> signUp(String name, String email, String password) async {
    try {
      isLoading.value = true;

      UserCredential? cred =
      await _authService.registerWithEmail(email, password);

      if (cred != null && cred.user != null) {
        // Save user info in Firestore
        await _firestoreService.saveUserToFirestore(
          cred.user!.uid,
          name,
          email,
        );

        Get.offAllNamed(AppRoutes.home);
      }
    } on FirebaseAuthException catch (e) {
      Helpers.showSnackBar("Sign Up Failed", e.message ?? "Unknown error",
          isError: true);
    } catch (e) {
      Helpers.showSnackBar("Error", e.toString(), isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  // 🔹 Login
  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;

      await _authService.loginWithEmail(email, password);

      Get.offAllNamed(AppRoutes.home);
    } on FirebaseAuthException catch (e) {
      Helpers.showSnackBar(
        "Login Failed",
        e.message ?? "Invalid credentials",
        isError: true,
      );
    } catch (e) {
      Helpers.showSnackBar("Error", e.toString(), isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  // 🔹 Forgot Password
  Future<void> forgotPassword(String email) async {
    try {
      if (email.isEmpty) {
        Helpers.showSnackBar(
          "Error",
          "Please enter your email first",
          isError: true,
        );
        return;
      }

      isLoading.value = true;

      await _authService.resetPassword(email);

      Helpers.showSnackBar(
        "Success",
        "Password reset email sent",
      );
    } on FirebaseAuthException catch (e) {
      Helpers.showSnackBar(
        "Reset Failed",
        e.message ?? "Something went wrong",
        isError: true,
      );
    } catch (e) {
      Helpers.showSnackBar("Error", e.toString(), isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  // 🔹 Logout
  Future<void> signOut() async {
    await _authService.logout();
    Get.offAllNamed(AppRoutes.login);
  }
}
