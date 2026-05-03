import 'dart:convert';
import 'package:http/http.dart' as http;

class AiService {
  String? _apiKey;
  final String _baseUrl = 'https://openrouter.ai/api/v1';

  // Default model
  String _modelName = 'tencent/hy3-preview:free';

  List<Map<String, String>> _chatHistory = [];

  bool get isConfigured => _apiKey != null && _apiKey!.isNotEmpty;

  void configure({required String apiKey, String? modelName}) {
    _apiKey = apiKey;
    if (modelName != null) {
      _modelName = modelName;
    }
    _chatHistory = [];
  }

  void resetChat() {
    _chatHistory = [];
  }

  Map<String, String> _buildSystemMessage() {
    return {
      'role': 'system',
      'content':
          'Ты дружелюбный AI-ассистент в мессенджере. Отвечай осмысленно, используя контекст всей переписки. Пиши подробные, полезные ответы на русском языке. Текущая дата: 2 мая 2026 года, часовой пояс: UTC+3 (Москва).',
    };
  }

  /// Sends a message and returns the full response
  Future<String> sendMessage(String text) async {
    if (_apiKey == null || _apiKey!.isEmpty) {
      throw Exception('AI не настроен. Добавьте API ключ.');
    }

    // Add user message to history
    _chatHistory.add({'role': 'user', 'content': text});

    final messages = [_buildSystemMessage(), ..._chatHistory];

    print('Sending to AI model: $_modelName');
    print('Messages count: ${messages.length}');
    print('Last message: ${messages.last}');

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
          'HTTP-Referer': 'https://github.com/flutter/flutter',
          'X-Title': 'AI Chat Flutter App',
        },
        body: jsonEncode({
          'model': _modelName,
          'messages': messages,
          'stream': false,
          'temperature': 0.7,
          'max_tokens': 1024,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('API Error (${response.statusCode}): ${response.body}');
      }

      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final choices = data['choices'] as List?;
      
      if (choices == null || choices.isEmpty) {
        throw Exception('Пустой ответ от API');
      }

      final content = choices[0]['message']['content'] as String? ?? '';
      
      if (content.isEmpty) {
        throw Exception('Пустой ответ от AI');
      }

      // Add assistant's response to history
      _chatHistory.add({'role': 'assistant', 'content': content});

      return content;
    } catch (e) {
      // Remove the user's message from history if the request failed
      if (_chatHistory.isNotEmpty && _chatHistory.last['role'] == 'user') {
        _chatHistory.removeLast();
      }
      print('Error in sendMessage: $e');
      throw Exception('Ошибка сети: $e');
    }
  }

  /// Generates short suggestion replies based on chat context
  Future<List<String>> generateSuggestions(String lastMessage, {List<Map<String, String>>? chatHistory}) async {
    if (_apiKey == null || _apiKey!.isEmpty) {
      throw Exception('AI не настроен.');
    }

    // Build minimal context - just last 2 messages for speed
    final history = chatHistory ?? _chatHistory;
    final contextMessages = history.isEmpty
        ? 'Последнее сообщение: "$lastMessage"'
        : history
                .reversed
                .take(2)
                .map((m) => '${m['role'] == 'user' ? 'Человек' : 'AI'}: ${m['content']}')
                .join('\n');

    final prompt = 'На основе последнего сообщения: "$lastMessage"\n\n'
        'Напиши 3 варианта короткого ответа (максимум 5 слов каждый).\n'
        'Формат: просто 3 строки, без нумерации, без кавычек, без пояснений.\n'
        'Пример:\nПривет!\nКак дела?\nОтлично!';

    print('Generating suggestions (fast) for: $lastMessage');

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
          'HTTP-Referer': 'https://github.com/flutter/flutter',
          'X-Title': 'AI Chat Flutter App',
        },
        body: jsonEncode({
          'model': _modelName,
          'messages': [
            {'role': 'user', 'content': prompt},
          ],
          'temperature': 0.5,
          'max_tokens': 100,
        }),
      );

      print('Suggestions response status: ${response.statusCode}');

      if (response.statusCode != 200) {
        throw Exception('Failed to generate suggestions: ${response.body}');
      }

      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final String text = data['choices'][0]['message']['content'] ?? '';
      
      print('Raw suggestions text: "$text"');

      final suggestions = text
          .split('\n')
          .map((s) => s.trim())
          .map((s) => s.replaceAll(RegExp(r'^[-*\d\.\)\s]+'), '').trim())
          .where((s) => s.isNotEmpty)
          .take(3)
          .toList();
      
      print('Parsed suggestions: $suggestions');
      
      return suggestions;
    } catch (e) {
      print('Error generating suggestions: $e');
      rethrow;
    }
  }
}
