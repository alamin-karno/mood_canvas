# mood_canvas

A single-screen Flutter web mood tracker. Tap a custom-drawn face to log how you feel, browse your last seven entries in a horizontal timeline, and tap any past entry for a brief animation.

**Live demo:** https://mood-canvas.web.app (update after deploy)

**Repository:** https://github.com/alamin-karno/mood_canvas

## Features

- Three moods (happy, neutral, sad) drawn with `CustomPainter` (`drawCircle`, `drawArc`, `drawPath`)
- Tap a face to log immediately
- Horizontal timeline of the 7 most recent entries (date, face, mood color accent)
- Tap a timeline entry to pulse it briefly
- Local persistence via `shared_preferences` (no backend required)

## Getting started

```bash
flutter pub get
flutter run -d chrome
```

## Tests

```bash
flutter test
flutter analyze
```

## Build for web

```bash
flutter build web --release
```

## Deploy to Firebase Hosting

1. Install the [Firebase CLI](https://firebase.google.com/docs/cli) and log in: `firebase login`
2. Copy `.firebaserc.example` to `.firebaserc` and set your Firebase project id
3. Build and deploy:

```bash
flutter build web --release
firebase deploy --only hosting
```

## Project structure

```
lib/
├── main.dart
├── injection.dart
└── src/
    ├── app.dart
    ├── config/
    ├── core/error/
    ├── features/mood_tracker/
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    ├── services/
    └── theme/
```

## Architecture

Feature-first clean architecture: domain → data → presentation, with BLoC and `get_it` for dependency injection.
