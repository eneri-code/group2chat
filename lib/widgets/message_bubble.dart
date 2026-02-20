import 'package:flutter/material.dart';
import '../models/message_model.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/helpers.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMe;
  final bool showSenderName;
  final String? senderName;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    this.showSenderName = false,
    this.senderName,
  });
  // 1. HELPER METHOD FOR CHECKMARKS
  Widget _buildStatusIcon() {
    // Only show icons for my own messages
    if (!isMe) return const SizedBox.shrink();

    IconData icon;
    Color color;

    switch (message.status) {
      case 3: // Read
        icon = Icons.done_all;
        color = Colors.blueAccent; // Distinct blue for "Read"
        break;
      case 2: // Delivered
        icon = Icons.done_all;
        color = Colors.white70; // Double grey/white for "Delivered"
        break;
      default: // Sent (1)
        icon = Icons.done;
        color = Colors.white70; // Single grey/white for "Sent"
    }

    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Icon(icon, size: 14, color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primary : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showSenderName && senderName != null)
              Text(
                senderName!,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54),
              ),
            Text(
              message.text,
              style: TextStyle(color: isMe ? Colors.white : Colors.black87, fontSize: 15),
            ),
            const SizedBox(height: 4),
            Text(
              Helpers.formatTimestamp(message.timestamp),
              style: TextStyle(
                color: isMe ? Colors.white70 : Colors.black45,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}