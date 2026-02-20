import 'package:get/get.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';
import '../services/chat_service.dart';
import '../services/firestore_service.dart';
import '../services/notification_service.dart';
import 'auth_controller.dart';

class ChatController extends GetxController {
  final ChatService _chatService = ChatService();
  final FirestoreService _firestoreService = FirestoreService();

  String get currentUserId => Get.find<AuthController>().currentUserId;

  RxList<ChatModel> chats = <ChatModel>[].obs;
  RxList<MessageModel> messages = <MessageModel>[].obs;
  RxList<UserModel> allUsers = <UserModel>[].obs;
  RxBool isLoading = false.obs;

  // Track which chat the user is currently looking at
  RxString activeChatId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize Local Notifications
    NotificationService.init();

    fetchUserChats();
    fetchAllUsers();

    // Listen for changes in the chat list to trigger notifications
    setupNotificationListener();
  }

  void fetchUserChats() {
    chats.bindStream(_chatService.getChatStream(currentUserId));
  }

  void setupNotificationListener() {
    // .listen triggers every time the 'chats' collection updates in Firestore
    chats.listen((updatedChats) {
      if (updatedChats.isEmpty) return;

      // Get the most recently updated chat
      final latestChat = updatedChats.first;

      // 1. Don't notify if the message is from ME
      // Note: You need a 'lastSenderId' in your model for 100% accuracy,
      // but usually, if the chat list updates, it's because a message arrived.
      if (latestChat.lastSenderId != currentUserId) {
        NotificationService.showNotification(
            latestChat.receiverName, // The partner's name
            latestChat.lastMessage
        );
      }

      // 2. Don't notify if I am currently in this specific chat room
      if (activeChatId.value == latestChat.id) return;

      // 3. Only notify if the message is very recent (less than 5 seconds old)
      // This prevents "notification spam" when the app first opens.
      final messageTime = latestChat.lastTime;
      final now = DateTime.now();

      if (now.difference(messageTime).inSeconds < 5) {
        NotificationService.showNotification(
          latestChat.receiverName,
          latestChat.lastMessage,
        );
      }
    });
  }

  void fetchAllUsers() {
    allUsers.bindStream(_firestoreService.getAllUsersStream());
  }

  void bindMessageStream(String chatId) {
    activeChatId.value = chatId; // Set active chat to prevent popups while reading
    messages.bindStream(_chatService.getMessageStream(chatId));
  }

  void disposeMessageStream() {
    activeChatId.value = ''; // Reset when leaving the chat room
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
      text: text, senderName: '',
    );
  }
}