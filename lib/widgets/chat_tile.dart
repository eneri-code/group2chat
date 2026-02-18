// chat_tile.dart
import 'package:flutter/material.dart';
import '../models/chat_model.dart';
import '../core/utils/helpers.dart';

class ChatTile extends StatelessWidget {
  final ChatModel chat;
  final VoidCallback onTap;

  const ChatTile({super.key, required this.chat, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        radius: 28,
        child: Text(chat.receiverName[0].toUpperCase()),
      ),
      title: Text(chat.receiverName, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(chat.lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Text(Helpers.formatTimestamp(chat.lastTime), style: const TextStyle(fontSize: 12, color: Colors.grey)),
    );
  }
}