class GroupModel {
  final String id;
  final String name;
  final String createdBy;
  final List<String> members;
  final String lastMessage;
  final DateTime lastTime;

  GroupModel({
    required this.id,
    required this.name,
    required this.createdBy,
    required this.members,
    required this.lastMessage,
    required this.lastTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'createdBy': createdBy,
      'members': members,
      'lastMessage': lastMessage,
      'lastTime': lastTime,
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      createdBy: map['createdBy'] ?? '',
      members: List<String>.from(map['members'] ?? []),
      lastMessage: map['lastMessage'] ?? '',
      lastTime: (map['lastTime'] as dynamic).toDate(),
    );
  }
}
