import 'dart:convert';

import 'package:flutter/foundation.dart';

class Chat {
  final String chatId;
  final List<dynamic> chat;
  final List<dynamic> userIds;
  Chat({
    required this.chatId,
    required this.chat,
    required this.userIds,
  });

  Chat copyWith({
    String? chatId,
    List<Map<String, dynamic>>? chat,
    List<String>? userIds,
  }) {
    return Chat(
      chatId: chatId ?? this.chatId,
      chat: chat ?? this.chat,
      userIds: userIds ?? this.userIds,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'chat': chat,
      'userIds': userIds,
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      chatId: map['chatId'] ?? '',
      chat: List<Map<String, dynamic>>.from(map['chat']),
      userIds: List<String>.from(map['userIds']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Chat.fromJson(String source) => Chat.fromMap(json.decode(source));

  @override
  String toString() => 'Chat(chatId: $chatId, chat: $chat, userIds: $userIds)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Chat &&
        other.chatId == chatId &&
        listEquals(other.chat, chat) &&
        listEquals(other.userIds, userIds);
  }

  @override
  int get hashCode => chatId.hashCode ^ chat.hashCode ^ userIds.hashCode;
}
