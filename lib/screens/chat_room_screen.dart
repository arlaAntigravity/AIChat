import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models.dart';
import '../providers.dart';
import '../widgets/message_bubble.dart';
import '../widgets/chat_input.dart';
import '../widgets/ai_suggestion_strip.dart';
import '../widgets/ai_suggestion_sheet.dart';

class ChatRoomScreen extends StatefulWidget {
  final String chatId;

  const ChatRoomScreen({super.key, required this.chatId});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();

    // Generate initial suggestions when chat opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ai = context.read<AIProvider>();
      final chatProvider = context.read<ChatProvider>();
      final messages = chatProvider.getMessages(widget.chatId);
      
      if (ai.suggestions.isEmpty && !ai.isGenerating && messages.isNotEmpty) {
        final lastMsg = messages.first.text;
        // Build chat history for context
        final chatHistory = messages.take(6).map((m) => {
              'role': m.isMe ? 'user' : 'assistant',
              'content': m.text,
            }).toList();
        
        ai.generateSuggestions(lastMsg, chatHistory: chatHistory);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final chatProvider = context.read<ChatProvider>();
    final aiProvider = context.read<AIProvider>();

    chatProvider.addMessage(
      widget.chatId,
      Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text,
        createdAt: DateTime.now(),
        isMe: true,
      ),
    );
    _controller.clear();

    // Generate suggestions based on user's message
    _generateSuggestionsForUserMessage(chatProvider, aiProvider, text);

    // Use AI for all chats if configured, otherwise use simulated reply
    if (aiProvider.isConfigured) {
      aiProvider.sendToAI(
        text: text,
        chatId: widget.chatId,
        chatProvider: chatProvider,
      );
      // Suggestions will be generated automatically after AI response
    } else {
      // Simulated auto-reply only if AI is not configured
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        chatProvider.addMessage(
          widget.chatId,
          Message(
            id: '${DateTime.now().millisecondsSinceEpoch}_reply',
            text: 'Понял, спасибо!',
            createdAt: DateTime.now(),
            isMe: false,
          ),
        );
        // Regenerate suggestions after simulated reply
        _generateSuggestionsAfterAIResponse(chatProvider, aiProvider);
      });
    }
  }

  void _generateSuggestionsForUserMessage(
    ChatProvider chatProvider,
    AIProvider aiProvider,
    String userMessage,
  ) {
    if (aiProvider.isGenerating) return;
    
    // Build chat history for context-aware suggestions
    final messages = chatProvider.getMessages(widget.chatId);
    final chatHistory = messages.take(6).map((m) => {
          'role': m.isMe ? 'user' : 'assistant',
          'content': m.text,
        }).toList();
    
    aiProvider.generateSuggestions(userMessage, chatHistory: chatHistory);
  }

  void _generateSuggestionsAfterAIResponse(
    ChatProvider chatProvider,
    AIProvider aiProvider,
  ) {
    if (!mounted) return;
    
    final messages = chatProvider.getMessages(widget.chatId);
    if (messages.isEmpty) return;
    
    final lastMsg = messages.first.text;
    final chatHistory = messages.take(6).map((m) => {
          'role': m.isMe ? 'user' : 'assistant',
          'content': m.text,
        }).toList();
    
    aiProvider.generateSuggestions(lastMsg, chatHistory: chatHistory);
  }

  void _handleSelectSuggestion(AISuggestion s) {
    _controller.text = s.full;
    _controller.selection = TextSelection.collapsed(offset: s.full.length);
  }

  void _showAISheet() {
    final ai = context.read<AIProvider>();
    showAISuggestionSheet(
      context: context,
      suggestions: ai.suggestions,
      isGenerating: ai.isGenerating,
      onSelect: _handleSelectSuggestion,
      onRegenerate: () => ai.generateSuggestions(widget.chatId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    final aiProvider = context.watch<AIProvider>();
    final chat = chatProvider.getChat(widget.chatId);
    final messages = chatProvider.getMessages(widget.chatId);

    return Scaffold(
      appBar: AppBar(title: Text(chat?.name ?? 'Чат')),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
              itemCount: messages.length,
              itemBuilder: (context, index) =>
                  MessageBubble(message: messages[index]),
            ),
          ),

          // AI Strip
          AISuggestionStrip(
            suggestions: aiProvider.suggestions,
            isGenerating: aiProvider.isGenerating,
            onSelect: _handleSelectSuggestion,
            onOpenModal: _showAISheet,
          ),

          // Input
          ChatInputBar(
            controller: _controller,
            onSend: _handleSend,
            onOpenAI: _showAISheet,
          ),
        ],
      ),
    );
  }
}
