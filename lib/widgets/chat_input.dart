import 'package:flutter/material.dart';
import '../theme.dart';

class ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onOpenAI;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onOpenAI,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: LiquidGlass.bg,
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
      child: SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            color: LiquidGlass.glassBg,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: LiquidGlass.glassBorder, width: 1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // AI sparkle button
              Container(
                height: 38, // Math for standard single line height
                alignment: Alignment.center,
                child: IconButton(
                  onPressed: onOpenAI,
                  icon: const Icon(
                    Icons.auto_awesome,
                    color: LiquidGlass.accentLight,
                    size: 22,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 38,
                    minHeight: 38,
                  ),
                ),
              ),

              // Text field
              Expanded(
                child: TextField(
                  controller: controller,
                  maxLines: 4,
                  minLines: 1,
                  style: const TextStyle(
                    color: LiquidGlass.textPrimary,
                    fontSize: 16,
                    height:
                        1.25, // Explicit line height for perfect calculation
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Сообщение...',
                    hintStyle: TextStyle(color: LiquidGlass.textMuted),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 9, // Exactly 9+9+20 (font) = 38 height
                    ),
                    isDense: true,
                  ),
                ),
              ),

              // Send button
              Container(
                height: 38,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(right: 2),
                child: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: controller,
                  builder: (context, value, child) {
                    final hasText = value.text.trim().isNotEmpty;
                    return GestureDetector(
                      onTap: hasText ? onSend : null,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: hasText
                              ? LiquidGlass.accent
                              : LiquidGlass.bgInput,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_upward_rounded,
                          color: hasText ? Colors.white : LiquidGlass.textMuted,
                          size: 20,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 2),
            ],
          ),
        ),
      ),
    );
  }
}
