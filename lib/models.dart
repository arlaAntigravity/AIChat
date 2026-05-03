class Message {
  final String id;
  final String text;
  final DateTime createdAt;
  final bool isMe;

  Message({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.isMe,
  });
}

class Chat {
  final String id;
  final String name;
  final String? lastMessage;
  final DateTime updatedAt;
  final int unreadCount;

  Chat({
    required this.id,
    required this.name,
    this.lastMessage,
    required this.updatedAt,
    this.unreadCount = 0,
  });
}

class AISuggestion {
  final String short;
  final String full;

  AISuggestion({required this.short, required this.full});
}
