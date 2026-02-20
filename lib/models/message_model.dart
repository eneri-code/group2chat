import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String senderId;
  final String senderName; // Useful for group chats
  final String text;
  final DateTime timestamp;
  final String messageId;
  final int status;

  MessageModel( {
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.timestamp,
    required this.messageId,
    this.status = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderName': senderName,
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
      'messageId': messageId,
      'status': status,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      senderId: map['senderId'] ?? '',
      senderName: map['senderName'] ?? '',
      text: map['text'] ?? '',
      timestamp: map['timestamp'] != null
          ? (map['timestamp'] as Timestamp).toDate()
          : DateTime.now(),

      messageId: map['messageId'] ?? '',
      status: map['status'] ?? 1,
    );
  }
}
