GROUP MEMBERS

JULIANA LOTSON ABRAHAM  	NIT/BCS/2023/515 
GIDEON SAMWEL MSUYA 	      NIT/BCS/2023/550 
IDDY  ATHUMANI MSEMO 	   NIT/BCS/2023/523 
ZERA ELIAS MSIGALA 	      NIT/BCS/2023/556 
JOSELINE SADI  MWAMGIGA 	NIT/BCS/2023/569 
REHANI  EMANUEL PARII 	   NIT/BCS/2023/559 
IRENE ALPHONCE ROBERT 	   NIT/BCS/2023/522 
VICENT  KESSY  	         NIT/BCS/2023/510 
RAPHAEL AZARIA 	         NIT/BCS/2023/524
NOEL MAGABE             	NIT/BCS/2022/438






# group2_chat

A Flutter chat application with support for authentication, one-to-one chats, and group chats backed by Firebase (Auth + Firestore). This README covers setup, development, and the project structure.

## Table of contents
- About
- Features
- Tech stack
- Prerequisites
- Setup
- Firebase configuration
- Run
- Project structure
- Testing
- Contributing
- Troubleshooting
- Contact
- Repository info

## About
group2_chat is a starter Flutter chat app scaffolded to use Firebase for authentication and realtime/chat storage. It includes controllers, services, models, and screens for auth, chats, and groups.

## Features
- Email/password authentication
- One-to-one chat
- Group creation and group chat rooms
- Clean project organization: core, services, controllers, screens, widgets
- Firebase integration (Firestore + Auth). Generated Firebase options live at firebase/firebase_options.dart

## Tech stack
- Flutter (Dart)
- Firebase: Authentication, Firestore
- Recommended: FlutterFire CLI to generate firebase_options.dart

## Prerequisites
- Flutter SDK (stable channel) installed and configured
- Android Studio / Xcode (for device emulators) or connected device
- A Firebase project for Android/iOS/web
- FlutterFire CLI (optional but recommended) to configure firebase_options.dart





## Project structure

High-level tree (key files and folders):

```
lib/
├── main.dart
├── core/
│   ├── theme/
│   │   ├── app_colors.dart
│   │   └── app_theme.dart
│   ├── constants/
│   │   ├── strings.dart
│   │   └── firebase_constants.dart
│   └── utils/
│       ├── validators.dart
│       └── helpers.dart
├── models/
│   ├── user_model.dart
│   ├── message_model.dart
│   ├── chat_model.dart
│   └── group_model.dart
├── services/
│   ├── auth_service.dart
│   ├── chat_service.dart
│   ├── group_service.dart
│   └── firestore_service.dart
├── controllers/
│   ├── auth_controller.dart
│   ├── chat_controller.dart
│   └── group_controller.dart
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── signup_screen.dart
│   ├── home/
│   │   └── home_screen.dart
│   ├── chat/
│   │   ├── chat_screen.dart
│   │   └── chat_room_screen.dart
│   ├── group/
│   │   ├── create_group_screen.dart
│   │   └── group_chat_screen.dart
│   └── new_chat/
│       └── start_chat_screen.dart
├── widgets/
│   ├── chat_tile.dart
│   ├── message_bubble.dart
│   ├── group_tile.dart
│   ├── user_tile.dart
│   ├── custom_button.dart
│   └── custom_textfield.dart
├── routes/
│   └── app_routes.dart
└── firebase/
    └── firebase_options.dart
```
<img src="PICTURES/app icon.jpg">


