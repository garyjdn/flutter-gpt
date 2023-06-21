import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:meta/meta.dart';

import '../../data/repositories/ai_repository.dart';

part 'ai_event.dart';
part 'ai_state.dart';

class AIBloc extends Bloc<AIEvent, AIState> {
  final AIRepository aiRepository;
  late StreamSubscription<OpenAIStreamChatCompletionChoiceModel>
      eventSubscription;

  AIBloc({
    required this.aiRepository,
  }) : super(AIIdle()) {
    on<SendMessage>(_handleSendMessage, transformer: restartable());
  }

  void _handleSendMessage(SendMessage event, Emitter<AIState> emit) async {
    emit(AIProcessing());
    final message = event.message;
    final responseStream = aiRepository.chat(message);
    await emit.forEach(responseStream, onData: (e) {
      if (e.finishReason == null) {
        return AIAnswering(e.delta.content!);
      } else {
        return AIIdle();
      }
    });
  }
}
