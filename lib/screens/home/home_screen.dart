import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../controllers/chat_controller.dart';
import '../../controllers/group_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/chat_tile.dart';
import '../../widgets/group_tile.dart';
import '../../routes/app_routes.dart';
import '../../core/theme/app_colors.dart';



class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  // Controllers to handle data fetching and logic
  // These will automatically start listening to Firestore streams onInit
  final ChatController _chatController = Get.put(ChatController());
  final GroupController _groupController = Get.put(GroupController());
  final AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Messages', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: false,
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.settings),
              onSelected: (value) {
                if (value == 'theme') {
                  // Change theme logic
                  Get.changeThemeMode(
                    Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
                  );
                } else if (value == 'profile') {
                  Get.toNamed(AppRoutes.profile); // Make sure route exists
                } else if (value == 'logout') {
                  _authController.signOut();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'theme',
                  child: Text('Change Theme'),
                ),
                const PopupMenuItem(
                  value: 'profile',
                  child: Text('My Profile'),
                ),
                const PopupMenuItem(
                  value: 'logout',
                  child: Text('Logout'),
                ),
              ],
            ),

          ],
          bottom: const TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: "Chats"),
              Tab(text: "Groups"),
            ],
          ),
        ),

        body: TabBarView(
          children: [
            _buildChatList(),
            _buildGroupList(),
          ],
        ),

        // Updated FAB to handle the "New Chat" logic which now includes Group Creation
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.add_comment_rounded, color: Colors.white),
          onPressed: () {
            // This navigates to the screen we updated earlier
            // The StartChatScreen now contains the "New Group" button at the top
            Get.toNamed(AppRoutes.startChat);
          },
        ),
      ),
    );
  }

  // Section 1: 1-to-1 Conversations
  // This updates automatically when a message is sent because of .bindStream()
  Widget _buildChatList() {
    return Obx(() {
      if (_chatController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (_chatController.chats.isEmpty) {
        return _buildEmptyState("No messages yet. Start a conversation!");
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: _chatController.chats.length,
        itemBuilder: (context, index) {
          final chat = _chatController.chats[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ChatTile(
              chat: chat,
              onTap: () {
                Get.toNamed(AppRoutes.chatRoom, arguments: chat);
              },
            ),
          );
        },
      );

    });
  }

  // Section 2: Group Conversations
  Widget _buildGroupList() {
    return Obx(() {
      if (_groupController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (_groupController.groups.isEmpty) {
        return _buildEmptyState("You haven't joined any groups yet.");
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: _groupController.groups.length,   // ✅ FIXED
        itemBuilder: (context, index) {
          final group = _groupController.groups[index];   // ✅ FIXED

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: GroupTile(
              group: group,
              onTap: () {
                Get.toNamed(AppRoutes.groupChat, arguments: group);
              },
            ),
          );
        },
      );
    });
  }


}




  // Reusable Empty State UI
  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.forum_outlined, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
