# Mini Chat App

A modern, Flutter-based chat application featuring a clean UI, real-time simulated conversations, and useful tools like word definitions.

## Features

- **User Management**: Create and view user contacts.
- **Chat Interface**: Interactive chat screen with gradient bubbles and typing indicators.
- **Simulated Responses**: Receive automated responses from "users" (powered by dummy data APIs).
- **Word Lookup**: Tap on any word in a message to view its definition and meaning.
- **Chat History**: Track your recent conversations and unread message counts.
- **Smart Time Formatting**: Relative timestamps (e.g., "2 min ago", "Yesterday").

## Tech Stack

- **Flutter** & **Dart**
- **State Management**: BLoC (Cubit)
- **Networking**: `http` package
- **UI**: Custom themes, gradients, and animations

## APIs Used

- **DummyJSON**: Used to simulate incoming chat messages/comments.
- **Dictionary API**: Provides word definitions for the lookup feature.

## Getting Started

1.  **Prerequisites**: Ensure you have Flutter installed.
2.  **Installation**:
    ```bash
    git clone <repository-url>
    cd minichatapp
    flutter pub get
    ```
3.  **Run the App**:
    ```bash
    flutter run
    ```

## Testing

To run the widget tests:

```bash
flutter test
```

## Submission

### Video Demo Link
[Placeholder - Add video demo link here]

### App Screenshots
[Placeholder - Add app screenshots here]

## License

MIT License
