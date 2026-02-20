import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/group_model.dart';
import '../models/message_model.dart';
import '../core/constants/firebase_constants.dart';

class GroupService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createNewGroup(String name, List<String> members, String adminId) async {
    final docRef = _db.collection(FirebaseConstants.groupsCollection).doc();
    
    final newGroup = GroupModel(
      id: docRef.id,
      name: name,
      createdBy: adminId,
      members: members,
      lastMessage: 'Group created',
      lastTime: DateTime.now(),
    );

    await docRef.set(newGroup.toMap());
  }

  Stream<List<GroupModel>> getGroupsStream(String userId) {
    return _db
        .collection(FirebaseConstants.groupsCollection)
        .where('members', arrayContains: userId)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => GroupModel.fromMap(doc.data()))
            .toList());
  }

  Stream<List<MessageModel>> getGroupMessageStream(String groupId) {
    return _db
        .collection(FirebaseConstants.groupsCollection)
        .doc(groupId)
        .collection(FirebaseConstants.messagesCollection)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => MessageModel.fromMap(doc.data()))
            .toList());
  }

  Future<void> sendGroupTextMessage({
    required String groupId,
    required String senderId,
    required String senderName,
    required String text,
  }) async {
    final messageId = DateTime.now().millisecondsSinceEpoch.toString();
    
    await _db
        .collection(FirebaseConstants.groupsCollection)
        .doc(groupId)
        .collection(FirebaseConstants.messagesCollection)
        .doc(messageId)
        .set({
          'senderId': senderId,
          'senderName': senderName, // ✅ add this
          'text': text,
          'timestamp': FieldValue.serverTimestamp(),
          'messageId': messageId,
        });
  }
}