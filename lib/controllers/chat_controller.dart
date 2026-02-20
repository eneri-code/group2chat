import 'package:get/get.dart';
import 'package:collection/collection.dart'; // for firstWhereOrNull

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

  String get currentUserName => Get.find<AuthController>().currentUserName;
  String get currentUserId => Get.find<AuthController>().currentUserId;

  RxList<ChatModel> chats = <ChatModel>[].obs;
  RxList<MessageModel> messages = <MessageModel>[].obs;
  RxList<UserModel> allUsers = <UserModel>[].obs;
  RxBool isLoading = false.obs;

  RxString activeChatId = ''.obs;

  // ── NEW: Track the last processed timestamp per chat to detect REAL new messages ──
  final Map<String, DateTime> _lastProcessedTimestamps = {};

  @override
  void onInit() {
    super.onInit();
    NotificationService.init();

    fetchUserChats();
    fetchAllUsers();

    // Only setup listener after initial load
    ever(chats, (_) {
      // This runs after first bindStream emission
      setupNotificationListener();
    });
  }

  void fetchUserChats() {
    // bindStream already gives us real-time updates
    chats.bindStream(_chatService.getChatStream(currentUserId));
  }

  void setupNotificationListener() {
    // We use .listen on the stream directly instead of .listen on RxList
    // This avoids duplicate listeners if onInit is called multiple times
    _chatService.getChatStream(currentUserId).listen((updatedChats) {
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
      // Sort by lastTime descending → newest first
      updatedChats.sort((a, b) => b.lastTime.compareTo(a.lastTime));

      for (final chat in updatedChats) {
        // Skip if this is the currently open chat
        if (activeChatId.value == chat.id) continue;

        // Skip if message is from me
        if (chat.lastSenderId == currentUserId) continue;

        // NEW: Only notify for chats we have previously seen
        final previousTime = _lastProcessedTimestamps[chat.id];
        if (previousTime == null) {
          // First time seeing this chat → probably initial load → skip notify
          _lastProcessedTimestamps[chat.id] = chat.lastTime;
          continue;
        }

        // Only notify if there's a newer message
        if (chat.lastTime.isAfter(previousTime)) {
          NotificationService.showNotification(
            title: chat.receiverName ?? 'New message',
            body: chat.lastMessage ?? 'You have a new message',
            // Optional: payload with chat.id to open correct chat on tap
            payload: chat.id,
          );

          // Update last processed time
          _lastProcessedTimestamps[chat.id] = chat.lastTime;
        }
      }
    });
  }

  void fetchAllUsers() {
    allUsers.bindStream(_firestoreService.getAllUsersStream());
  }

  void bindMessageStream(String chatId) {
    activeChatId.value = chatId; // Set active chat to prevent popups while reading
    messages.bindStream;
    activeChatId.value = chatId;
    messages.bindStream(_chatService.getMessageStream(chatId));
  }

  void disposeMessageStream() {
    activeChatId.value = '';
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
      senderName: currentUserName,
      receiverId: receiverId,
      receiverName: receiverName,
      text: text, senderName: '',
    );
  }

  // Optional: Call this when app resumes (in main.dart or AppLifecycle observer)
  void onAppResumed() {
    // You can refresh critical data or clear stale in-memory state if needed
    // But usually not necessary with Firestore streams
  }
}