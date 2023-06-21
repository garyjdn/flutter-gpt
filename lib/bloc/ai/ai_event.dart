part of 'ai_bloc.dart';

@immutable
abstract class AIEvent {}

class SendMessage extends AIEvent {
  final String message;

  SendMessage(this.message);
}
