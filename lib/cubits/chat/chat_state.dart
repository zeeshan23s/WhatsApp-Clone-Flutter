part of 'chat_cubit.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<Chat> chats;
  final List<AppUser> users;
  ChatLoaded(this.chats, this.users);
}

class ChatError extends ChatState {
  final String error;
  ChatError(this.error);
}
