import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/chat_controller.dart';
import '../../widgets/user_tile.dart';
import '../../routes/app_routes.dart';
import '../../models/chat_model.dart';
import '../../core/theme/app_colors.dart';

class StartChatScreen extends StatefulWidget {
  const StartChatScreen({super.key});

  @override
  State<StartChatScreen> createState() => _StartChatScreenState();
}

class _StartChatScreenState extends State<StartChatScreen> {
  final ChatController _chatController = Get.find<ChatController>();
  final TextEditingController _searchController = TextEditingController();

  // Observable list for local filtering
  final RxList _filteredUsers = [].obs;

  @override
  void initState() {
    super.initState();
    // Initialize filtered list with all users
    _filteredUsers.assignAll(_chatController.allUsers);
  }

  // Helper to generate a consistent Chat ID between two users
  String _getChatId(String id1, String id2) {
    return id1.hashCode <= id2.hashCode ? '${id1}_$id2' : '${id2}_$id1';
  }

  void _runFilter(String enteredKeyword) {
    if (enteredKeyword.isEmpty) {
      _filteredUsers.assignAll(_chatController.allUsers);
    } else {
      _filteredUsers.assignAll(
        _chatController.allUsers
            .where((user) =>
            user.name.toLowerCase().contains(enteredKeyword.toLowerCase()))
            .toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Start New Chat"),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => _runFilter(value),
              decoration: InputDecoration(
                hintText: "Search users...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),

          // Combined List: New Group Button + Users
          Expanded(
            child: Obx(() {
              if (_chatController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                // We add +1 to the length to include the "New Group" button at the top
                itemCount: _filteredUsers.length + 1,
                itemBuilder: (context, index) {

                  // POSITION 0: THE "NEW GROUP" BUTTON
                  if (index == 0) {
                    return ListTile(
                      onTap: () => Get.toNamed(AppRoutes.createGroup), // Route to group creation
                      leading: const CircleAvatar(
                        backgroundColor: AppColors.primary,
                        child: Icon(Icons.group_add, color: Colors.white),
                      ),
                      title: const Text(
                        "New Group",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text("Create a Group conversation"),
                    );
                  }

                  // REMAINING POSITIONS: THE USERS
                  final user = _filteredUsers[index - 1]; // Offset by 1 because of the Group button

                  // Skip if the user is the current logged-in user
                  if (user.id == _chatController.currentUserId) {
                    return const SizedBox.shrink();
                  }

                  return UserTile(
                    user: user,
                    onTap: () {
                      // Generate a unique ID based on both users
                      final String chatId = _getChatId(_chatController.currentUserId, user.id);

                      // Create the ChatModel to pass to the Chat Room
                      final chatToOpen = ChatModel(
                        id: chatId,
                        receiverName: user.name,
                        receiverId: user.id,
                        lastMessage: "",
                        lastTime: DateTime.now(), lastSenderId: '',
                      );

                      // Open Chat Room
                      Get.toNamed(AppRoutes.chatRoom, arguments: chatToOpen);
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
