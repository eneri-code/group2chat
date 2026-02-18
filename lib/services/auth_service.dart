import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 🔹 Get Current User
  User? get currentUser => _auth.currentUser;

  // 🔹 Auth State Changes Stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // 🔹 Register with Email & Password
  Future<UserCredential?> registerWithEmail(
      String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // 🔹 Login with Email & Password
  Future<UserCredential?> loginWithEmail(
      String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // 🔹 Reset Password
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // 🔹 Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}
