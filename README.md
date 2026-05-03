# AI Chat - Мессенджер с AI-ассистентом на Flutter

Современное мессенджер-приложение на Flutter с интегрированным AI-ассистентом, работающим через OpenRouter API. Особенности: умные подсказки для ответов, анимированные индикаторы набора текста и красивый дизайн в стиле «жидкое стекло».

## Возможности

- **Чат с AI**: Общение с AI-ассистентами через OpenRouter API
- **Умные подсказки**: Автоматически генерируемые варианты быстрых ответов на основе контекста беседы
- **Анимированный индикатор набора**: Красивая анимация пульсирующих точек во время «размышлений» AI
- **Несколько чатов**: Поддержка нескольких чатов одновременно
- **Современный интерфейс**: Дизайн в стиле «жидкое стекло» с градиентами и плавными анимациями
- **Управление настройками**: Настройка API-ключей и выбор моделей AI

## Скриншоты

Скриншоты хранятся в папке `screenshots/`. Примеры:

### Главный экран чатов

![Chat List](screenshots/chat_list.png)

### Экран переписки с AI

![Chat Room](screenshots/chat_room.png)

### Настройки AI

![AI Settings](screenshots/ai_settings.png)

_Добавьте свои скриншоты в папку `screenshots/` и обновите ссылки выше._

## Начало работы

### Требования

- Flutter SDK (3.0 или выше)
- Dart SDK (2.17 или выше)
- Android Studio / VS Code с плагинами Flutter
- API-ключ OpenRouter ([получить здесь](https://openrouter.ai/))

### Установка

1. **Клонирование репозитория**

    ```bash
    git clone https://github.com/yourusername/ai_chat.git
    cd ai_chat
    ```

2. **Установка зависимостей**

    ```bash
    flutter pub get
    ```

3. **Настройка API-ключа**
    - Запустите приложение
    - Перейдите в Профиль → Настройки AI-ассистента
    - Введите ваш API-ключ OpenRouter
    - Выберите модель (по умолчанию: `tencent/hy3-preview:free`)

4. **Запуск приложения**
    ```bash
    flutter run
    ```

### Сборка релизной версии

**Android:**

```bash
flutter build apk --release
```

**iOS:**

```bash
flutter build ios --release
```

## Структура проекта

```
lib/
├── main.dart                 # Точка входа в приложение
├── models.dart               # Модели данных (Chat, Message, AISuggestion)
├── providers.dart            # Управление состоянием (ChatProvider, AIProvider)
├── theme.dart               # Тема и цвета приложения
├── screens/                 # Экраны приложения
│   ├── chat_list_screen.dart
│   ├── chat_room_screen.dart
│   ├── ai_settings_screen.dart
│   └── profile_screen.dart
├── widgets/                 # Переиспользуемые виджеты
│   ├── message_bubble.dart
│   ├── chat_input.dart
│   ├── typing_indicator.dart
│   ├── ai_suggestion_strip.dart
│   └── ai_suggestion_sheet.dart
└── services/                # Бизнес-логика
    └── ai_service.dart
```

## Конфигурация

### Модели AI

Приложение использует OpenRouter API. Доступные модели (настраиваются в `lib/providers.dart`):

- `tencent/hy3-preview:free` (по умолчанию)

Чтобы добавить другие модели, отредактируйте список `availableModels` в файле `lib/providers.dart`.

### Хранение API-ключа

API-ключи безопасно сохраняются с использованием `shared_preferences` и сохраняются между запусками приложения.

## Зависимости

- `flutter`: Flutter SDK
- `provider`: Управление состоянием
- `http`: HTTP-запросы к AI API
- `shared_preferences`: Локальное хранилище для API-ключей
- `intl`: Форматирование дат

## Участие в разработке

1. Сделайте форк репозитория
2. Создайте ветку для вашей функции (`git checkout -b feature/amazing-feature`)
3. Зафиксируйте изменения (`git commit -m 'Add some amazing feature'`)
4. Отправьте в ветку (`git push origin feature/amazing-feature`)
5. Откройте Pull Request