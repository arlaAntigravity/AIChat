import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers.dart';
import '../theme.dart';

class AiSettingsScreen extends StatefulWidget {
  const AiSettingsScreen({super.key});

  @override
  State<AiSettingsScreen> createState() => _AiSettingsScreenState();
}

class _AiSettingsScreenState extends State<AiSettingsScreen> {
  late final TextEditingController _keyController;
  String? _selectedModel;

  @override
  void initState() {
    super.initState();
    final aiProvider = context.read<AIProvider>();
    _keyController = TextEditingController(text: aiProvider.apiKey);
    // Safety check: ensure model is in available list
    _selectedModel = AIProvider.availableModels.contains(aiProvider.modelName)
        ? aiProvider.modelName
        : AIProvider.availableModels.first;
  }

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  void _save() async {
    final key = _keyController.text.trim();
    final aiProvider = context.read<AIProvider>();
    
    // Save API key
    await aiProvider.setApiKey(key);
    
    // Save selected model
    if (_selectedModel != null) {
      await aiProvider.setModel(_selectedModel!);
    }
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            key.isEmpty ? 'API ключ удалён' : 'Настройки сохранены ✨',
          ),
          backgroundColor: LiquidGlass.accent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Настройки')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Status card
          Consumer<AIProvider>(
            builder: (context, ai, _) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ai.isConfigured
                      ? LiquidGlass.online.withValues(alpha: 0.1)
                      : LiquidGlass.badge.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: ai.isConfigured
                        ? LiquidGlass.online.withValues(alpha: 0.3)
                        : LiquidGlass.badge.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      ai.isConfigured
                          ? Icons.check_circle
                          : Icons.warning_amber_rounded,
                      color: ai.isConfigured
                          ? LiquidGlass.online
                          : LiquidGlass.badge,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        ai.isConfigured
                            ? 'OpenRouter API подключён'
                            : 'API ключ не настроен',
                        style: TextStyle(
                          color: ai.isConfigured
                              ? LiquidGlass.online
                              : LiquidGlass.badge,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Model selection
          const Text(
            'Модель AI',
            style: TextStyle(
              color: LiquidGlass.accentLight,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Consumer<AIProvider>(
            builder: (context, ai, _) {
              final currentModel = _selectedModel ?? ai.modelName;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: LiquidGlass.bgCard,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: LiquidGlass.glassBorder),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: currentModel,
                    isExpanded: true,
                    dropdownColor: LiquidGlass.bgCard,
                    style: const TextStyle(
                      color: LiquidGlass.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: LiquidGlass.textSecondary,
                    ),
                    items: AIProvider.availableModels.map((model) {
                      return DropdownMenuItem(
                        value: model,
                        child: Text(
                          model,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: LiquidGlass.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedModel = value;
                      });
                    },
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          const Text(
            'OpenRouter API Ключ',
            style: TextStyle(
              color: LiquidGlass.accentLight,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: LiquidGlass.bgCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: LiquidGlass.glassBorder),
            ),
            child: TextField(
              controller: _keyController,
              style: const TextStyle(
                color: LiquidGlass.textPrimary,
                fontSize: 14,
                fontFamily: 'monospace',
              ),
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Вставьте ваш API ключ...',
                hintStyle: TextStyle(color: LiquidGlass.textMuted),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                prefixIcon: Icon(Icons.key, color: LiquidGlass.textSecondary),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Save button
          GestureDetector(
            onTap: _save,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [LiquidGlass.bubbleMeStart, LiquidGlass.bubbleMeEnd],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(
                child: Text(
                  'Сохранить',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // How to get key
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: LiquidGlass.bgCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: LiquidGlass.glassBorder),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Как получить API ключ?',
                  style: TextStyle(
                    color: LiquidGlass.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '1. Зарегистрируйтесь на openrouter.ai\n'
                  '2. Перейдите в раздел Keys\n'
                  '3. Создайте новый ключ\n'
                  '4. Скопируйте и вставьте в поле выше',
                  style: TextStyle(
                    color: LiquidGlass.textSecondary,
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Model info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: LiquidGlass.bgCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: LiquidGlass.glassBorder),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'О моделях OpenRouter',
                  style: TextStyle(
                    color: LiquidGlass.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Все перечисленные модели бесплатные (free tier).\n'
                  'Рекомендуемые модели:\n'
                  '• tencent/hy3-preview:free - быстрая и качественная\n'
                  '• google/gemma-3-27b-it:free - от Google\n'
                  '• deepseek/deepseek-chat:free - от DeepSeek',
                  style: TextStyle(
                    color: LiquidGlass.textSecondary,
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
