# Feedback

A Flutter package for collecting user feedback within your application. It provides a UI overlay that allows users to submit feedback, report bugs, and view existing issues.

## Features

- **Feedback Overlay**: Easily accessible feedback form from anywhere in the app.
- **Screenshot Capture**: Automatically captures the current screen state when submitting feedback.
- **Issue Tracking**: View, filter, and track the status of submitted feedback.
- **Comments**: Discuss issues directly within the app.
- **Device Info**: Automatically collects device and screen information.

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  feedback:
    git:
      url: https://github.com/herveGuigoz/feedback.git
      path: packages/feedback
```

## Usage

Wrap your application with `FeedbackApp`. It is recommended to use it within the `builder` of your `MaterialApp` or `MaterialApp.router` to ensure it sits above your app's content but below the navigator.

### With GoRouter

```dart
import 'package:feedback/feedback.dart';
import 'package:feedback_pocketbase/feedback_pocketbase.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Initialize your client (e.g., using feedback_pocketbase)
    final client = FeedbackPocketbase(
      baseUrl: 'https://your-pocketbase-url.com',
      projectId: 'your-project-id',
      storage: YourStorageImplementation(),
    );

    final router = GoRouter(
      routes: [/* your routes */],
    );

    return MaterialApp.router(
      routerConfig: router,
      builder: (context, child) {
        return FeedbackApp(
          client: client,
          routeInformationProvider: router.routeInformationProvider,
          child: child!,
        );
      },
    );
  }
}
```

### Key Components

- **FeedbackApp**: The main widget that injects the feedback system into the widget tree.
- **FeedbackClient**: The interface for the backend connection (provided by `feedback_client` or `feedback_pocketbase`).

## Dependencies

This package relies on `feedback_client` for the backend interface. You will typically use it alongside `feedback_pocketbase` or your own implementation of `FeedbackClient`.
