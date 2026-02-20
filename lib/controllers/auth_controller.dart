import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../core/utils/helpers.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  // Reactive Firebase user
  Rx<User?> firebaseUser = Rx<User?>(null);

  // Reactive username
  RxString userName = ''.obs;

  // Loading indicator
  RxBool isLoading = false.obs;

  // Tracks whether first auth state has been received
  RxBool isAuthReady = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Bind Firebase auth state changes
    firebaseUser.bindStream(_authService.authStateChanges);

    // Listen to auth changes
    ever(firebaseUser, (User? user) async {
      // Mark auth as ready after first emission
      if (!isAuthReady.value) {
        isAuthReady.value = true;
      }

      if (user != null) {
        await _loadUserName(user.uid);
      } else {
        userName.value = '';
      }
    });
  }

  /// Load user name from Firestore
  Future<void> _loadUserName(String uid) async {
    try {
      final userData = await _firestoreService.getUserById(uid);
      userName.value = userData['name'] ?? "User";
    } catch (e) {
      userName.value = "User";
      print("Username load failed: $e");
    }
  }

  /// Current user ID
  String get currentUserId => firebaseUser.value?.uid ?? '';

  /// Current user name
  String get currentUserName => userName.value;

  /// Sign Up
  Future<void> signUp(String name, String email, String password) async {
    try {
      isLoading.value = true;

      final UserCredential? cred =
          await _authService.registerWithEmail(email, password);

      if (cred != null && cred.user != null) {
        // Save user info to Firestore
        await _firestoreService.saveUserToFirestore(
          cred.user!.uid,
          name,
          email,
        );

        userName.value = name;
        // Navigation handled by Root
      }
    } on FirebaseAuthException catch (e) {
      Helpers.showSnackBar(
        "Sign Up Failed",
        e.message ?? "Unknown error",
        isError: true,
      );
    } catch (e) {
      Helpers.showSnackBar("Error", e.toString(), isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  /// Login
  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;

      await _authService.loginWithEmail(email, password);

      // Navigation handled by Root via auth state
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

  /// Forgot Password
  Future<void> forgotPassword(String email) async {
    try {
      if (email.isEmpty) {
        Helpers.showSnackBar(
          "Error",
          "Please enter your email first to change your password ",
          isError: true,
        );
        return;
      }

      isLoading.value = true;
      await _authService.resetPassword(email);

      Helpers.showSnackBar("Success", "Password reset email sent");
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

  /// Logout
  Future<void> signOut() async {
    await _authService.logout();
    // Root will handle navigation automatically
  }
}