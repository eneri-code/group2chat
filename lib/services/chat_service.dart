import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';
import '../core/constants/firebase_constants.dart';

class ChatService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  get _chatService => null;

  get currentUserId => null;

  // Fetch list of active chats for a user
  Stream<List<ChatModel>> getChatStream(String userId) {
    return _db
        .collection(FirebaseConstants.usersCollection)
        .doc(userId)
        .collection(FirebaseConstants.chatsCollection)
        .orderBy('lastTime', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => ChatModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Send a message and update lastMessage for both users
  Future<void> sendTextMessage({
    required String chatId,
    required String senderId,
    required String senderName,
    required String receiverId,
    required String receiverName,
    required String text,
  }) async {
    final messageId = DateTime.now().millisecondsSinceEpoch.toString();
    final now = DateTime.now();

    final message = MessageModel(
      senderId: senderId,
      senderName: senderName,
      text: text,
      timestamp: now,
      messageId: messageId,
    );

    // 1️⃣ Save the actual message
    await _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());

    // 2️⃣ Update SENDER'S list (I sent it, so lastSenderId is ME)
    await _db
        .collection('users')
        .doc(senderId)
        .collection('chats')
        .doc(chatId)
        .set({
      'id': chatId,
      'receiverId': receiverId,
      'receiverName': receiverName,
      'lastMessage': text,
      'lastTime': now,
      'lastSenderId': senderId, // 👈 Added
    });

    // 3️⃣ Update RECEIVER'S list (I sent it, so lastSenderId is STILL ME)
    await _db
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(chatId)
        .set({
      'id': chatId,
      'receiverId': senderId,
      'receiverName': senderName, // They see MY name
      'lastMessage': text,
      'lastTime': now,
      'lastSenderId': senderId, // 👈 Added
    });
  }

  Stream<List<MessageModel>> getMessageStream(String chatId) {
    return _db
        .collection(FirebaseConstants.chatsCollection)
        .doc(chatId)
        .collection(FirebaseConstants.messagesCollection)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => MessageModel.fromMap(doc.data()))
            .toList());
  }
}

extension on String {
  String? get name => null;
}