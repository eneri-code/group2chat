

// group_tile.dart
import 'package:flutter/material.dart';
import '../models/group_model.dart';

class GroupTile extends StatelessWidget {
  final GroupModel group;
  final VoidCallback onTap;

  const GroupTile({super.key, required this.group, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      leading: const CircleAvatar(
        radius: 25,
        backgroundColor: Color(0xFFE0E0E0),
        child: Icon(Icons.group, color: Colors.black54),
      ),
      title: Text(
        group.name,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        group.lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.grey),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
    );
  }
}
