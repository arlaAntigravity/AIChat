import 'package:flutter/material.dart';
import '../models.dart';
import '../theme.dart';
import 'typing_indicator.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    final time =
        '${message.createdAt.hour.toString().padLeft(2, '0')}:${message.createdAt.minute.toString().padLeft(2, '0')}';

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          gradient: isMe
              ? const LinearGradient(
                  colors: [LiquidGlass.bubbleMeStart, LiquidGlass.bubbleMeEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isMe ? null : LiquidGlass.bubbleOther,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isMe ? 18 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 18),
          ),
          border: isMe
              ? null
              : Border.all(color: LiquidGlass.glassBorder, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            message.text == '...' && !isMe
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TypingIndicator(
                      color: LiquidGlass.textMuted,
                      dotSize: 8,
                      spacing: 4,
                    ),
                  )
                : Text(
                    message.text,
                    style: TextStyle(
                      color: isMe ? Colors.white : LiquidGlass.textPrimary,
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
            const SizedBox(height: 3),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 11,
                    color: isMe
                        ? Colors.white.withValues(alpha: 0.6)
                        : LiquidGlass.textMuted,
                  ),
                ),
                if (isMe) ...[
                  const SizedBox(width: 3),
                  Icon(
                    Icons.done_all,
                    size: 14,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
