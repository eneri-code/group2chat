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

## Setup

1. Clone the repo
   ```
   git clone https://github.com/eneri-code/group2chat.git
   cd group2chat
   ```

2. Install dependencies
   ```
   flutter pub get
   ```

3. Configure Firebase (see next section)

4. Run the app
   ```
   flutter run
   ```

## Firebase configuration

This project includes a firebase/firebase_options.dart file. To configure Firebase for your platforms:

Option A — use FlutterFire CLI (recommended):
1. Install & login: `dart pub global activate flutterfire_cli` then `flutterfire configure`
2. Follow prompts to select your Firebase project and platforms. This will update firebase_options.dart.

Option B — manual:
1. Create a Firebase project and add Android and/or iOS apps.
2. Download `google-services.json` (Android) and/or `GoogleService-Info.plist` (iOS) and place them in the appropriate platform directories.
3. Update firebase/firebase_options.dart with your Firebase options (or regenerate it with the FlutterFire CLI).

Environment/config values
- The project contains `core/constants/firebase_constants.dart`. If your app requires extra environment variables, create an `.env` (or similar) and update your app's configuration accordingly.
- Example .env keys (adjust to your code):
  ```
  FIREBASE_API_KEY=your_api_key
  FIREBASE_AUTH_DOMAIN=your_project.firebaseapp.com
  FIREBASE_PROJECT_ID=your_project_id
  FIREBASE_STORAGE_BUCKET=your_bucket
  FIREBASE_MESSAGING_SENDER_ID=your_sender_id
  FIREBASE_APP_ID=your_app_id
  ```

## Run

- Launch on connected device or emulator:
  ```
  flutter run
  ```

- Build APK (Android):
  ```
  flutter build apk --release
  ```

- Build iOS (macOS + Xcode):
  ```
  flutter build ios --release
  ```

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

## Testing
- If you have unit or widget tests, run:
  ```
  flutter test
  ```

- Add widget tests under `test/` and run the same command.

## Contributing
- Open an issue for bugs or feature requests.
- Fork, create a feature branch, and open a pull request.
- Follow existing code style (Dart/Flutter conventions).

Suggested commit message for README changes:
```
docs: update README with setup and firebase instructions
```

## Troubleshooting
- "Firebase not initialized" — ensure firebase_options.dart is present and Firebase.initializeApp() is called in main.dart before runApp.
- Platform-specific Google services files missing — add `google-services.json` (Android) and `GoogleService-Info.plist` (iOS).
- Authentication errors — confirm Firebase Auth is enabled in your Firebase console.

## Contact
Create an issue or discussion in this repository for questions or feature requests.

## Repository info
- Repository: eneri-code/group2chat
- Repository ID: 1160742110
- Language composition: Flutter (Dart) — project is a Flutter app, primary language Dart
