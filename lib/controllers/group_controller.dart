import 'package:get/get.dart';
import '../models/group_model.dart';
import '../models/message_model.dart';
import '../services/group_service.dart';
import 'auth_controller.dart';
import '../core/utils/helpers.dart';
import '../services/notification_service.dart';


class GroupController extends GetxController {
  final GroupService _groupService = GroupService();

  String get currentUserId => Get.find<AuthController>().currentUserId;
  String get currentUserName => Get.find<AuthController>().currentUserName;

  RxList<GroupModel> groups = <GroupModel>[].obs;
  RxList<MessageModel> groupMessages = <MessageModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserGroups();

    // Listen to message changes for notifications
    ever(groupMessages, (List<MessageModel> messages) {
      if (messages.isNotEmpty) {
        final lastMessage = messages.first; // Assuming first is the newest

        // Only show notification if the message is from someone else
        if (lastMessage.senderId != currentUserId) {
          NotificationService.showNotification(
              "New Group Message",
              lastMessage.text
          );
        }
      }
    });
  }

  void fetchUserGroups() {
    groups.bindStream(_groupService.getGroupsStream(currentUserId));
  }

  void bindGroupMessages(String groupId, String groupName) {

    _groupService.getGroupMessageStream(groupId).listen((messages) {

      if (messages.isNotEmpty) {

        final latestMessage = messages.first;

        // 🚨 Don't notify yourself
        if (latestMessage.senderId != currentUserId) {

          NotificationService.showNotification(
            "$groupName • ${latestMessage.senderName}",
            latestMessage.text,
          );
        }
      }

      groupMessages.assignAll(messages);
    });
  }


  Future<void> createGroup(String name, List<String> members) async {
    try {
      isLoading.value = true;
      // Add the creator to the group
      members.add(currentUserId);
      members.add(currentUserName);
      
      await _groupService.createNewGroup(name, members, currentUserId);
      Get.back(); // Go back to Home
      Helpers.showSnackBar("Success", "Group '$name' created!");
    } catch (e) {
      Helpers.showSnackBar("Error", e.toString(), isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendGroupMessage({required String groupId, required String text}) async {
    await _groupService.sendGroupTextMessage(
      groupId: groupId,
      senderId: currentUserId,
      senderName: currentUserName,
      text: text,
    );
  }
}