# Feedback PocketBase

A PocketBase implementation of the `feedback_client` interface. This package allows the Feedback system to communicate with a PocketBase backend.

## Features

- **PocketBase Integration**: Uses the `pocketbase` Dart package to interact with your PocketBase instance.
- **Authentication**: Handles user authentication and session persistence.
- **Feedback Management**: Create, read, update, and delete feedback issues.
- **Comments**: Manage comments on feedback issues.

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  feedback_pocketbase:
    path: packages/feedback_pocketbase
```

## Usage

### Initialization

To use `FeedbackPocketbase`, you need to provide the PocketBase URL, a project ID, and a storage implementation for session persistence.

```dart
import 'package:feedback_pocketbase/feedback_pocketbase.dart';

// 1. Implement the storage interface
class MyStorage implements FeedbackStorageInterface {
  final Map<String, String> _memory = {};

  @override
  String? read(String key) => _memory[key];

  @override
  Future<void> write({required String key, required String value, Duration? expireIn}) async {
    _memory[key] = value;
  }

  @override
  Future<void> delete(String key) async {
    _memory.remove(key);
  }
}

// 2. Initialize the client
final client = FeedbackPocketbase(
  baseUrl: 'https://your-pocketbase-url.com',
  projectId: 'your-project-id',
  storage: MyStorage(),
);
```

### PocketBase Schema

Ensure your PocketBase instance has the following collections:
- `users`: Standard users collection.
- `issues`: Stores feedback items.
- `comments`: Stores comments on issues.

(Note: Refer to the migration files in `pocketbase/pb_migrations` for the exact schema definitions.)
