import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models.dart';
import '../providers.dart';
import '../theme.dart';
import 'chat_room_screen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Чаты')),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, _) {
          final chats = chatProvider.chats;
          return ListView.separated(
            itemCount: chats.length,
            separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(left: 82),
              child: Divider(
                height: 1,
                thickness: 0.5,
                color: LiquidGlass.separator,
              ),
            ),
            itemBuilder: (context, index) => _ChatTile(chat: chats[index]),
          );
        },
      ),
    );
  }
}

class _ChatTile extends StatelessWidget {
  final Chat chat;

  const _ChatTile({required this.chat});

  @override
  Widget build(BuildContext context) {
    final time =
        '${chat.updatedAt.hour.toString().padLeft(2, '0')}:${chat.updatedAt.minute.toString().padLeft(2, '0')}';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: LiquidGlass.bgElevated,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ChatRoomScreen(chatId: chat.id)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [LiquidGlass.accent, LiquidGlass.accentLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    chat.name[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            chat.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: LiquidGlass.textPrimary,
                            ),
                          ),
                        ),
                        Text(
                          time,
                          style: const TextStyle(
                            fontSize: 13,
                            color: LiquidGlass.textMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            chat.lastMessage ?? 'Нет сообщений',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              color: LiquidGlass.textSecondary,
                            ),
                          ),
                        ),
                        if (chat.unreadCount > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7),
                            height: 22,
                            constraints: const BoxConstraints(minWidth: 22),
                            decoration: const BoxDecoration(
                              color: LiquidGlass.badge,
                              borderRadius: BorderRadius.all(
                                Radius.circular(11),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '${chat.unreadCount}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
