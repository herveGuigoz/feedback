# Feedback Client

A Dart package that defines the interface and models for the Feedback system.

## Features

- **Abstract Client Interface**: Defines the `FeedbackClient` contract for authentication, feedback management, and comments.
- **Data Models**: Provides strongly-typed models for `User`, `FeedbackEvent`, `Comment`, and request objects.
- **Error Handling**: Custom exception classes for handling API errors.

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  feedback_client:
    path: packages/feedback_client
```

## Usage

This package is primarily used to implement a backend client for the `feedback` UI package.

### Implementing a Client

Extend `FeedbackClient` and implement the required methods:

```dart
import 'package:feedback_client/feedback_client.dart';

class MyFeedbackClient extends FeedbackClient {
  @override
  String get baseUrl => 'https://api.example.com';

  @override
  Stream<User?> get user => ...;

  @override
  Future<User> authenticate({required String username, required String password}) async {
    // Implement authentication
  }

  // Implement other methods...
}
```

## Models

- `User`: Represents an authenticated user.
- `FeedbackEvent`: Represents a feedback issue.
- `Comment`: Represents a comment on a feedback issue.
- `CreateFeedbackRequest`: Data required to create a new feedback.
