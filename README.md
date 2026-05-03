# AI Chat - Flutter Messenger with AI Assistant

A modern Flutter-based messenger application with integrated AI assistant powered by OpenRouter API. Features smart reply suggestions, animated typing indicators, and a beautiful liquid glass UI design.

## Features

- **AI-Powered Chat**: Communicate with AI assistants using OpenRouter API
- **Smart Suggestions**: AI-generated quick reply suggestions based on conversation context
- **Animated Typing Indicator**: Beautiful pulsing dots animation while AI is thinking
- **Multiple Chats**: Support for multiple chat conversations
- **Modern UI**: Liquid glass design with gradients and smooth animations
- **Settings Management**: Configure API keys and choose AI models

## Screenshots

_(Add screenshots here)_

## Getting Started

### Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK (2.17 or higher)
- Android Studio / VS Code with Flutter extensions
- OpenRouter API key ([get it here](https://openrouter.ai/))

### Installation

1. **Clone the repository**

    ```bash
    git clone https://github.com/yourusername/ai_chat.git
    cd ai_chat
    ```

2. **Install dependencies**

    ```bash
    flutter pub get
    ```

3. **Configure API Key**
    - Run the app
    - Go to Profile → AI Assistant Settings
    - Enter your OpenRouter API key
    - Select a model (default: `tencent/hy3-preview:free`)

4. **Run the app**
    ```bash
    flutter run
    ```

### Building for Release

**Android:**

```bash
flutter build apk --release
```

**iOS:**

```bash
flutter build ios --release
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models.dart               # Data models (Chat, Message, AISuggestion)
├── providers.dart            # State management (ChatProvider, AIProvider)
├── theme.dart               # App theme and colors
├── screens/                 # UI screens
│   ├── chat_list_screen.dart
│   ├── chat_room_screen.dart
│   ├── ai_settings_screen.dart
│   └── profile_screen.dart
├── widgets/                 # Reusable widgets
│   ├── message_bubble.dart
│   ├── chat_input.dart
│   ├── typing_indicator.dart
│   ├── ai_suggestion_strip.dart
│   └── ai_suggestion_sheet.dart
└── services/                # Business logic
    └── ai_service.dart
```

## Configuration

### AI Models

The app uses OpenRouter API. Available models (configured in `lib/providers.dart`):

- `tencent/hy3-preview:free` (default)

To add more models, edit the `availableModels` list in `lib/providers.dart`.

### API Key Storage

API keys are stored securely using `shared_preferences` and persist between app launches.

## Dependencies

- `flutter`: Flutter SDK
- `provider`: State management
- `http`: HTTP requests for AI API
- `shared_preferences`: Local storage for API keys
- `intl`: Date formatting

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [OpenRouter](https://openrouter.ai/) for providing AI model access
- Flutter team for the amazing framework

## Contact

Your Name - [@yourtwitter](https://twitter.com/yourtwitter) - email@example.com

Project Link: [https://github.com/yourusername/ai_chat](https://github.com/yourusername/ai_chat)
