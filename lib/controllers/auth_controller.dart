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
    // Bind the firebase user to the observable to track auth state changes
    firebaseUser.bindStream(FirebaseAuth.instance.authStateChanges());
  }

  String get currentUserId => firebaseUser.value?.uid ?? '';

  Future<void> signUp(String name, String email, String password) async {
    try {
      isLoading.value = true;
      UserCredential? cred = await _authService.registerWithEmail(email, password);
      
      if (cred != null) {
        // Save user details to Firestore
        await _firestoreService.saveUserToFirestore(cred.user!.uid, name, email);
        Get.offAllNamed(AppRoutes.home);
      }
    } catch (e) {
      Helpers.showSnackBar("Error", e.toString(), isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      await _authService.loginWithEmail(email, password);
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      Helpers.showSnackBar("Login Failed", "Invalid credentials", isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  void signOut() async {
    await _authService.logout();
    Get.offAllNamed(AppRoutes.login);
  }
}