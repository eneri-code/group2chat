import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/chat_controller.dart';
import 'chat_screen.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final ChatController _chatController = Get.find<ChatController>();

  @override
  void initState() {
    super.initState();
    // Start listening to messages for the current chat
    final String chatId = Get.arguments.id;
    _chatController.bindMessageStream(chatId);
  }

  @override
  void dispose() {
    // Clean up listeners when leaving the room
    _chatController.disposeMessageStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This acts as a wrapper that ensures the data stream is ready
    return const ChatScreen();
  }
}