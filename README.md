# Feedbacks

A modular, feedback collection system for Flutter applications. This monorepo contains everything you need to integrate a user feedback loop into your app, including the UI widgets, client interfaces, and a PocketBase backend implementation.

## 📦 Packages

This repository is organized as a monorepo

| Package | Description | Path |
|---------|-------------|------|
| **[feedback](packages/feedback)** | The main Flutter UI package. Provides the feedback overlay. | `packages/feedback` |
| **[feedback_client](packages/feedback_client)** | Abstract interface and shared models for the feedback system. | `packages/feedback_client` |
| **[feedback_pocketbase](packages/feedback_pocketbase)** | A concrete implementation of the client using [PocketBase](https://pocketbase.io/). | `packages/feedback_pocketbase` |
| **[example](exemple)** | A demo application showcasing the integration. | `exemple` |

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Docker](https://www.docker.com/) (optional, for running PocketBase via Compose) or a local PocketBase installation.

## 🛠 Backend Setup (PocketBase)

The system relies on a backend to store issues and comments. A PocketBase configuration is provided.

You can run it using the provided Docker Compose file or manually if you have the binary.

**Using Docker:**
```bash
docker compose up -d
```

**Manual:**
```bash
./pocketbase serve
```


## 📱 Running the Example

1. Ensure the backend is running (default: `http://127.0.0.1:8090`).
2. Run the example app:
   ```bash
   cd exemple
   flutter run
   ```

   *Note: If you are running on a physical device or emulator, ensure the `baseUrl` in `exemple/lib/app/app.dart` points to your host machine's IP address instead of `localhost`.*

## 🏗 Architecture

The system is designed to be backend-agnostic:

1. **UI Layer (`feedback`)**: Depends only on `feedback_client`. It doesn't know about the specific backend implementation.
2. **Client Layer (`feedback_client`)**: Defines the contract (`FeedbackClient`) and data models (`FeedbackEvent`, `Comment`, `User`).
3. **Infrastructure Layer (`feedback_pocketbase`)**: Implements `FeedbackClient` to talk to PocketBase. You can swap this out for a Firebase, REST, or GraphQL implementation by creating a new package that implements the client interface.
