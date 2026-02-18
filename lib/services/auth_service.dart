import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Register with Email & Password
  Future<UserCredential?> registerWithEmail(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email, 
      password: password
    );
  }

  // Login with Email & Password
  Future<UserCredential?> loginWithEmail(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email, 
      password: password
    );
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}