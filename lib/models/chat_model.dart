// this is our chat model for the group

class ChatModel {
  final String id;
  final String receiverName;
  final String receiverId;
  final String lastMessage;
  final String lastSenderId;
  final DateTime lastTime;

  ChatModel( {
    required this.id,
    required this.receiverName,
    required this.receiverId,
    required this.lastMessage,
    required this.lastSenderId,
    required this.lastTime,
  });

  factory ChatModel.fromMap(Map<String, dynamic> map, String chatId) {
    return ChatModel(
      id: chatId,
      receiverName: map['receiverName'] ?? '',
      receiverId: map['receiverId'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
      lastSenderId: map['lastSenderId'] ?? '',
      lastTime: (map['lastTime'] != null)
          ? (map['lastTime'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'receiverName': receiverName,
      'receiverId': receiverId,
      'lastMessage': lastMessage,
      'lastSenderId': lastSenderId,
      'lastTime': lastTime,
    };
  }
}

class Timestamp {
  toDate() {}
}
