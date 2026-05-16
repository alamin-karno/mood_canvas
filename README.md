# mood_canvas

Track emotions visually with custom-drawn expressive faces.

## Architecture

- **Feature-first** layout under `lib/src/features/`
- **Clean architecture**: domain (entities, repositories, use cases) → data (datasources, models) → presentation (bloc, pages)
- **State**: `flutter_bloc`
- **DI**: `get_it` in [`lib/injection.dart`](lib/injection.dart)
- **Backend**: Firebase Auth + Cloud Firestore

## Getting started

```bash
flutter pub get
cp .env.example .env   # add your Firebase keys
flutterfire configure  # recommended: generates platform Firebase config
flutter run -d chrome
```

### Firebase setup

1. Create a Firebase project and enable **Authentication** (Email/Password) and **Firestore**.
2. Run `flutterfire configure` or copy keys into `.env` (see `.env.example`).
3. Deploy Firestore security rules (see below).

### Firestore security rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/moods/{moodId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## Project structure

```
lib/
├── injection.dart
├── firebase_options.dart
├── main.dart
└── src/
    ├── core/           # routing, firebase, error handling
    ├── features/
    │   ├── auth/
    │   ├── mood_tracker/
    │   ├── home/
    │   └── onboarding/
    ├── shared/         # design system widgets
    └── theme/
```

## Commands

```bash
flutter analyze
flutter test
flutter build web
```
