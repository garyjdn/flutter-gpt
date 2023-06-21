part of 'ai_bloc.dart';

@immutable
abstract class AIState {}

class AIIdle extends AIState {}

class AIProcessing extends AIState {}

class AIAnswering extends AIState {
  final String response;

  AIAnswering(this.response);
}
