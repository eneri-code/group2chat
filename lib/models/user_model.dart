class UserModel {
  final String id;
  final String name;
  final String email;
  final String profilePic;
  final bool isOnline;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profilePic = '',
    this.isOnline = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profilePic': profilePic,
      'isOnline': isOnline,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      profilePic: map['profilePic'] ?? '',
      isOnline: map['isOnline'] ?? false,
    );
  }
}