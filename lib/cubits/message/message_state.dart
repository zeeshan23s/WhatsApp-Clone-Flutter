part of 'message_cubit.dart';

abstract class MessageState {}

class MessageInitial extends MessageState {}

class MessageLoading extends MessageState {}

class MessageLoaded extends MessageState {
  final Chat? chat;
  MessageLoaded(this.chat);
}

class MessageError extends MessageState {
  final String error;
  MessageError(this.error);
}
