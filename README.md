# group2_chat

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.








lib/
│
├── main.dart
│
├── core/
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_theme.dart
│   │
│   ├── constants/
│   │   ├── strings.dart
│   │   ├── firebase_constants.dart
│   │
│   ├── utils/
│   │   ├── validators.dart
│   │   ├── helpers.dart
│
│
├── models/
│   ├── user_model.dart
│   ├── message_model.dart
│   ├── chat_model.dart
│   ├── group_model.dart
│
│
├── services/
│   ├── auth_service.dart
│   ├── chat_service.dart
│   ├── group_service.dart
│   ├── firestore_service.dart
│
│
├── controllers/
│   ├── auth_controller.dart
│   ├── chat_controller.dart
│   ├── group_controller.dart
│
│
├── screens/
│   │
│   ├── auth/
│   │   ├── login_screen.dart
│   │   ├── signup_screen.dart
│   │
│   ├── home/
│   │   ├── home_screen.dart      // Chat list + FAB
│   │
│   ├── chat/
│   │   ├── chat_screen.dart      // 1-to-1 chat
│   │   ├── chat_room_screen.dart
│   │
│   ├── group/
│   │   ├── create_group_screen.dart
│   │   ├── group_chat_screen.dart
│   │
│   ├── new_chat/
│   │   ├── start_chat_screen.dart
│
│
├── widgets/
│   ├── chat_tile.dart
│   ├── message_bubble.dart
│   ├── group_tile.dart
│   ├── user_tile.dart
│   ├── custom_button.dart
│   ├── custom_textfield.dart
│
│
├── routes/
│   ├── app_routes.dart
│
│
└── firebase/
    ├── firebase_options.dart
