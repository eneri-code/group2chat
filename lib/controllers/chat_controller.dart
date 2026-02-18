import 'package:get/get.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';
import '../services/chat_service.dart';
import '../services/firestore_service.dart';
import 'auth_controller.dart';

class ChatController extends GetxController {
  final ChatService _chatService = ChatService();
  final FirestoreService _firestoreService = FirestoreService();

  String get currentUserId =>
      Get
          .find<AuthController>()
          .currentUserId;

  RxList<ChatModel> chats = <ChatModel>[].obs;
  RxList<MessageModel> messages = <MessageModel>[].obs;
  RxList<UserModel> allUsers = <UserModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserChats();
    fetchAllUsers();
  }

  // Fetch list of active 1-to-1 conversations
  void fetchUserChats() {
    chats.bindStream(_chatService.getChatStream(currentUserId));
  }

  // Fetch all users for the "New Chat" or "Create Group" screen
  void fetchAllUsers() {
    allUsers.bindStream(_firestoreService.getAllUsersStream());
  }

  // Bind to a specific conversation's messages
  void bindMessageStream(String chatId) {
    messages.bindStream(_chatService.getMessageStream(chatId));
  }

  void disposeMessageStream() {
    messages.clear();
  }

  Future<void> sendMessage({
    required String chatId,
    required String text,
    required String receiverId,
    required String receiverName,
  }) async {
    await _chatService.sendTextMessage(
      chatId: chatId,
      senderId: currentUserId,
      receiverId: receiverId,
      receiverName: receiverName,
      text: text,
    );
  }
}
