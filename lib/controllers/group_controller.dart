import 'package:get/get.dart';
import '../models/group_model.dart';
import '../models/message_model.dart';
import '../services/group_service.dart';
import 'auth_controller.dart';
import '../core/utils/helpers.dart';

class GroupController extends GetxController {
  final GroupService _groupService = GroupService();
  
  String get currentUserId => Get.find<AuthController>().currentUserId;

  RxList<GroupModel> groups = <GroupModel>[].obs;
  RxList<MessageModel> groupMessages = <MessageModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserGroups();
  }

  void fetchUserGroups() {
    groups.bindStream(_groupService.getGroupsStream(currentUserId));
  }

  void bindGroupMessages(String groupId) {
    groupMessages.bindStream(_groupService.getGroupMessageStream(groupId));
  }

  Future<void> createGroup(String name, List<String> members) async {
    try {
      isLoading.value = true;
      // Add the creator to the group
      members.add(currentUserId);
      
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
      text: text,
    );
  }
}