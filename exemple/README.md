# Feedback Example App

This is an example application demonstrating how to integrate the `feedback` system into a Flutter app.

## Overview

This app showcases:
- Integration of `FeedbackApp` with `GoRouter`.
- Usage of `FeedbackPocketbase` for the backend.
- A simple counter and blog page to demonstrate feedback submission from different contexts.

## Setup

1. **PocketBase**: Ensure you have a running PocketBase instance with the required schema (see `pocketbase/` directory in the root of the repository).
2. **Configuration**: Update `lib/app/app.dart` with your PocketBase URL and Project ID.

```dart
late final client = FeedbackPocketbase(
  baseUrl: 'http://localhost:8080', // Update this
  projectId: 'your-project-id',     // Update this
  storage: FeedbackStorage(sharedPreferences: widget.sharedPreferences),
);
```

## Running the App

```bash
flutter run
```
