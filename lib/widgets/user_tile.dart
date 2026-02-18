import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserTile extends StatelessWidget {
  final UserModel user;
  final Widget? trailing;
  final VoidCallback? onTap;

  const UserTile({super.key, required this.user, this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundImage: user.profilePic.isNotEmpty
            ? NetworkImage(user.profilePic)
            : null,
        child: user.profilePic.isEmpty ? Text(user.name[0]) : null,
      ),
      title: Text(user.name),
      subtitle: Text(user.email),
      trailing: trailing,
    );
  }
}
