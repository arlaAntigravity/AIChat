import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';
import 'services/ai_service.dart';

class ChatProvider extends ChangeNotifier {
  final List<Chat> _chats = [
    Chat(id: 'ai', name: 'AI Ассистент', updatedAt: DateTime.now()),
    Chat(id: '1', name: 'Алексей', updatedAt: DateTime.now()),
    Chat(id: '2', name: 'Работа', updatedAt: DateTime.now()),
    Chat(id: '3', name: 'Мамуля', updatedAt: DateTime.now()),
  ];

  final Map<String, List<Message>> _messages = {
    'ai': [
      Message(
        id: 'ai_welcome',
        text: 'Привет! Я AI-ассистент. Задайте мне любой вопрос ✨',
        createdAt: DateTime.now().subtract(const Duration(seconds: 1)),
        isMe: false,
      ),
    ],
    '1': [
      Message(
        id: 'm1_3',
        text: 'Привет, как дела?',
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
        isMe: false,
      ),
      Message(
        id: 'm1_2',
        text: 'Ещё не смотрел, сейчас гляну',
        createdAt: DateTime.now().subtract(const Duration(minutes: 8)),
        isMe: true,
      ),
      Message(
        id: 'm1_1',
        text: 'Как продвигается проект?',
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
        isMe: false,
      ),
    ],
    '2': [
      Message(
        id: 'm2_2',
        text: 'Проверь PR',
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        isMe: false,
      ),
      Message(
        id: 'm2_1',
        text: 'Готово, залил в main',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        isMe: true,
      ),
    ],
    '3': [
      Message(
        id: 'm3_2',
        text: 'Приезжай в воскресенье',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        isMe: false,
      ),
      Message(
        id: 'm3_1',
        text: 'Привет, мам! Как ты?',
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
        isMe: true,
      ),
    ],
  };

  /// Returns chats with lastMessage derived from actual messages.
  List<Chat> get chats {
    final enriched = _chats.map((chat) {
      final msgs = _messages[chat.id];
      final lastMsg = (msgs != null && msgs.isNotEmpty) ? msgs.first : null;
      return Chat(
        id: chat.id,
        name: chat.name,
        lastMessage: lastMsg?.text,
        updatedAt: lastMsg?.createdAt ?? chat.updatedAt,
        unreadCount: chat.unreadCount,
      );
    }).toList();
    enriched.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return enriched;
  }

  List<Message> getMessages(String chatId) => _messages[chatId] ?? [];

  Chat? getChat(String chatId) {
    final idx = _chats.indexWhere((c) => c.id == chatId);
    if (idx == -1) return null;
    return _chats[idx];
  }

  void addMessage(String chatId, Message message) {
    _messages.putIfAbsent(chatId, () => []);
    _messages[chatId]!.insert(0, message);

    final idx = _chats.indexWhere((c) => c.id == chatId);
    if (idx != -1) {
      final old = _chats[idx];
      _chats[idx] = Chat(
        id: old.id,
        name: old.name,
        updatedAt: old.updatedAt,
        unreadCount: message.isMe ? 0 : old.unreadCount + 1,
      );
    }
    notifyListeners();
  }

  /// Update an existing message's text (used for streaming AI responses)
  void updateMessage(String chatId, String messageId, String newText) {
    final msgs = _messages[chatId];
    if (msgs == null) return;
    final idx = msgs.indexWhere((m) => m.id == messageId);
    if (idx == -1) return;
    msgs[idx] = Message(
      id: messageId,
      text: newText,
      createdAt: msgs[idx].createdAt,
      isMe: msgs[idx].isMe,
    );
    notifyListeners();
  }
}

  class AIProvider extends ChangeNotifier {
    final AiService _aiService = AiService();
    List<AISuggestion> _suggestions = [];
    bool _isGenerating = false;
    bool _isResponding = false;
    String? _error;
    String _apiKey = '';
    String _modelName = 'tencent/hy3-preview:free';

    AIProvider() {
      // Load API key on initialization
      Future.microtask(() => loadApiKey());
    }

  // Popular free models on OpenRouter
  // Only keeping working models based on testing
  static const List<String> availableModels = [
    'tencent/hy3-preview:free',
  ];

  List<AISuggestion> get suggestions => _suggestions;
  bool get isGenerating => _isGenerating;
  bool get isResponding => _isResponding;
  bool get isConfigured => _aiService.isConfigured;
  String? get error => _error;
  String get apiKey => _apiKey;
  String get modelName => _modelName;

  /// Load the saved API key and model from SharedPreferences
  Future<void> loadApiKey() async {
    print('DEBUG: Loading API key from SharedPreferences...');
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString('gemini_api_key') ?? '';
    var model = prefs.getString('ai_model') ?? 'tencent/hy3-preview:free';
    
    // Reset to default if saved model is not in available list
    if (!availableModels.contains(model)) {
      print('DEBUG: Saved model "$model" not in available list, resetting to default');
      model = 'tencent/hy3-preview:free';
      await prefs.setString('ai_model', model);
    }
    
    print('DEBUG: Loaded API key: ${key.isNotEmpty ? "EXISTS (${key.substring(0, 5)}...)" : "EMPTY"}');
    print('DEBUG: Loaded model: $model');
    if (key.isNotEmpty) {
      _apiKey = key;
      _modelName = model;
      _aiService.configure(apiKey: key, modelName: model);
      notifyListeners();
      print('DEBUG: API key configured in AiService');
    } else {
      print('DEBUG: No API key found in SharedPreferences');
    }
  }

  /// Save the API key
  Future<void> setApiKey(String key) async {
    _apiKey = key;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('gemini_api_key', key);
    if (key.isNotEmpty) {
      _aiService.configure(apiKey: key, modelName: _modelName);
    }
    _error = null;
    notifyListeners();
  }

  /// Set the AI model
  Future<void> setModel(String modelName) async {
    _modelName = modelName;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ai_model', modelName);
    if (_apiKey.isNotEmpty) {
      _aiService.configure(apiKey: _apiKey, modelName: modelName);
    }
    notifyListeners();
  }

  /// Send a message to AI and get the response
  Future<void> sendToAI({
    required String text,
    required String chatId,
    required ChatProvider chatProvider,
  }) async {
    if (!_aiService.isConfigured) {
      _error = 'API ключ не настроен. Откройте Профиль → Настройки помощника.';
      notifyListeners();
      return;
    }

    _isResponding = true;
    _error = null;
    notifyListeners();

    // Create a placeholder message for the AI response
    final responseId = '${DateTime.now().millisecondsSinceEpoch}_ai';
    chatProvider.addMessage(
      chatId,
      Message(
        id: responseId,
        text: '...',
        createdAt: DateTime.now(),
        isMe: false,
      ),
    );

    try {
      final fullText = await _aiService.sendMessage(text);
      chatProvider.updateMessage(chatId, responseId, fullText);
    } catch (e) {
      chatProvider.updateMessage(
        chatId,
        responseId,
        '⚠️ Ошибка: ${e.toString().replaceAll('Exception: ', '')}',
      );
      _error = e.toString();
    }

    _isResponding = false;
    notifyListeners();
    
    // Generate suggestions after AI response is complete
    _generateSuggestionsAfterResponse(chatProvider, chatId);
  }

  /// Generate suggestions after AI response is received
  void _generateSuggestionsAfterResponse(ChatProvider chatProvider, String chatId) {
    final messages = chatProvider.getMessages(chatId);
    if (messages.isEmpty) return;
    
    final lastMsg = messages.first.text;
    final chatHistory = messages.take(6).map((m) => {
          'role': m.isMe ? 'user' : 'assistant',
          'content': m.text,
        }).toList();
    
    generateSuggestions(lastMsg, chatHistory: chatHistory);
  }

  /// Generate AI suggestion replies
  Future<void> generateSuggestions(String lastMessage, {List<Map<String, String>>? chatHistory}) async {
    if (!_aiService.isConfigured) {
      // Fallback to dummy suggestions
      _suggestions = [
        AISuggestion(
          short: 'Да, конечно!',
          full: 'Да, конечно! Звучит отлично.',
        ),
        AISuggestion(short: 'Не думаю', full: 'Не думаю, давай обсудим.'),
        AISuggestion(
          short: 'Подробнее',
          full: 'Расскажи подробнее, пожалуйста.',
        ),
      ];
      notifyListeners();
      return;
    }

    _isGenerating = true;
    notifyListeners();

    try {
      final results = await _aiService.generateSuggestions(lastMessage, chatHistory: chatHistory);
      print('DEBUG: Received suggestions from service: $results');
      
      if (results.isEmpty) {
        // Fallback to dummy suggestions if API returns empty
        print('DEBUG: API returned empty suggestions, using fallback');
        _suggestions = [
          AISuggestion(short: 'Понял!', full: 'Понял, спасибо!'),
          AISuggestion(short: 'Расскажи больше', full: 'Расскажи подробнее, пожалуйста.'),
          AISuggestion(short: 'Хорошо', full: 'Хорошо, договорились!'),
        ];
      } else {
        _suggestions = results
            .map(
              (s) => AISuggestion(
                short: s.length > 20 ? '${s.substring(0, 17)}...' : s,
                full: s,
              ),
            )
            .toList();
      }
      print('DEBUG: Set _suggestions to: $_suggestions');
    } catch (e) {
      print('DEBUG: Error generating suggestions: $e');
      _suggestions = [
        AISuggestion(short: 'Понял!', full: 'Понял, спасибо!'),
        AISuggestion(short: 'Расскажи больше', full: 'Расскажи подробнее, пожалуйста.'),
        AISuggestion(short: 'Хорошо', full: 'Хорошо, договорились!'),
      ];
    }

    _isGenerating = false;
    print('DEBUG: Notifying listeners with ${_suggestions.length} suggestions');
    notifyListeners();
  }

  /// Reset chat session (when switching chats)
  void resetChat() {
    _aiService.resetChat();
    _suggestions = [];
    notifyListeners();
  }
}
