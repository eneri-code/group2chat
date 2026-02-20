import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/chat_controller.dart';
import '../../models/chat_model.dart';
import '../../widgets/message_bubble.dart';
import '../../core/theme/app_colors.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}
class _ChatScreenState extends State<ChatScreen> {
  final ChatController _chatController = Get.find<ChatController>();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Get chat data passed from arguments
  final ChatModel chat = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: Text(chat.receiverName[0]),
            ),
            const SizedBox(width: 12),
            Text(chat.receiverName, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Message List
          Expanded(
            child: Obx(() {
              final messages = _chatController.messages;
              
              if (messages.isEmpty) {
                return const Center(child: Text("Say hello! 👋"));
              }

              return ListView.builder(
                controller: _scrollController,
                reverse: true, // Newest messages at the bottom
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  // Logic to check if message is from the current user
                  bool isMe = message.senderId == _chatController.currentUserId;

                  return MessageBubble(
                    message: message,
                    isMe: isMe,
                    showSenderName: !isMe,                // Only show sender name if message is from others
                    senderName: message.senderName,       // Pass the actual sender's name from Firestore
                  );

                },
              );
            }),
          ),

          // Input Field
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: "Type a message...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Colors.grey[200],
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: AppColors.primary,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: () {
                  if (_messageController.text.trim().isNotEmpty) {
                    _chatController.sendMessage(
                      chatId: chat.id,
                      text: _messageController.text.trim(),
                      receiverId: chat.receiverId,
                      receiverName: chat.receiverName,
                    );
                    _messageController.clear();
                  }
                },

              ),
            ),
          ],
        ),
      ),
    );
  }
}
