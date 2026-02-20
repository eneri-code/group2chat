import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/group_controller.dart';
import '../../controllers/chat_controller.dart'; // To fetch user list
import '../../widgets/custom_textfield.dart';
import '../../widgets/user_tile.dart';
import '../../core/theme/app_colors.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final GroupController _groupController = Get.find<GroupController>();
  final ChatController _chatController = Get.find<ChatController>();
  
  final _nameController = TextEditingController();
  final RxList<String> _selectedUserIds = <String>[].obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Group"),
        actions: [
          Obx(() => TextButton(
            onPressed: (_selectedUserIds.isNotEmpty && _nameController.text.isNotEmpty)
                ? () => _groupController.createGroup(
                      _nameController.text.trim(),
                      _selectedUserIds.toList(),
                    )
                : null,
            child: const Text("CREATE", style: TextStyle(fontWeight: FontWeight.bold)),
          )),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomTextField(
              controller: _nameController,
              hintText: "Enter your group name",
              prefixIcon: Icons.group_add_outlined,
              onChanged: (_) => setState(() {}), // Refresh CREATE button state
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Select Members", style: TextStyle(color: Colors.grey)),
            ),
          ),
          Expanded(
            child: Obx(() {
              final users = _chatController.allUsers; // Assuming you have this list
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Obx(() {
                    final isSelected = _selectedUserIds.contains(user.id);
                    return UserTile(
                      user: user,
                      trailing: Checkbox(
                        value: isSelected,
                        activeColor: AppColors.primary,
                        onChanged: (val) {
                          if (val == true) {
                            _selectedUserIds.add(user.id);
                          } else {
                            _selectedUserIds.remove(user.id);
                          }
                        },
                      ),
                    );
                  });
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}