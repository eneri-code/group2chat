import 'package:get/get.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/chat/chat_room_screen.dart';
import '../screens/group/create_group_screen.dart';
import '../screens/group/group_chat_screen.dart';
import '../screens/new_chat/start_chat_screen.dart';

class AppRoutes {
  // Route Name Constants
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String chat = '/chat';
  static const String chatRoom = '/chat-room';
  static const String createGroup = '/create-group';
  static const String groupChat = '/group-chat';
  static const String startChat = '/start-chat';

  // List of GetPages
  static List<GetPage> routes = [
    GetPage(
      name: login,
      page: () => LoginScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: signup,
      page: () => SignupScreen(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(name: home, page: () => HomeScreen()),
    GetPage(
      name: chat,
      page: () => const ChatScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: chatRoom,
      page: () => const ChatRoomScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: createGroup,
      page: () => const CreateGroupScreen(),
      fullscreenDialog: true, // Slides up from bottom
    ),
    GetPage(
      name: groupChat,
      page: () => const GroupChatScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(name: startChat, page: () => const StartChatScreen()),
  ];

  static String? get chatDetail => null;
}
