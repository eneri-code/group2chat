class ChatModel {
  final String id;
  final String receiverName;
  final String receiverId;
  final String lastMessage;
  final DateTime lastTime;

  ChatModel({
    required this.id,
    required this.receiverName,
    required this.receiverId,
    required this.lastMessage,
    required this.lastTime,
  });

  factory ChatModel.fromMap(Map<String, dynamic> map, String chatId) {
    return ChatModel(
      id: chatId,
      receiverName: map['receiverName'] ?? '',
      receiverId: map['receiverId'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
      lastTime: (map['lastTime'] as dynamic).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'receiverName': receiverName,
      'receiverId': receiverId,
      'lastMessage': lastMessage,
      'lastTime': lastTime,
    };
  }
}
