import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../core/constants/firebase_constants.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Save user profile after signup
  Future<void> saveUserToFirestore(String uid, String name, String email) async {
    await _db.collection(FirebaseConstants.usersCollection).doc(uid).set({
      'id': uid,
      'name': name,
      'email': email,
      'profilePic': '',
      'isOnline': true,
    });
  }

  // Get stream of all users (for starting new chats)
  Stream<List<UserModel>> getAllUsersStream() {
    return _db.collection(FirebaseConstants.usersCollection).snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data()))
          .toList(),
    );
  }
}