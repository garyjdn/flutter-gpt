import 'dart:convert';
import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_gpt/bloc/ai/ai_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../helpers/mock_helpers.dart';

void main() {
  late MockOpenAIRepository mockOpenAIRepository;
  List<OpenAIStreamChatCompletionChoiceModel?> modelData = [];

  setUp(() async {
    mockOpenAIRepository = MockOpenAIRepository();
    final responseDataJson =
        await File('test/fixtures/chat_completion_response.json')
            .readAsString();
    final responseData = jsonDecode(responseDataJson);
    for (int i = 0; i < responseData.length; i++) {
      final responseItem =
          OpenAIStreamChatCompletionModel.fromMap(responseData[i]);
      modelData.add(responseItem.choices.first);
    }
    when(() => mockOpenAIRepository.chat('test')).thenAnswer((_) {
      return () => Stream.fromIterable(modelData);
    });
  });

  group('handleSendMessage', () {
    blocTest<AIBloc, AIState>(
      'GIVEN initial state, WHEN listening to data, THEN emit the string data',
      build: () => AIBloc(aiRepository: mockOpenAIRepository),
      act: (bloc) => bloc.add(SendMessage('test')),
      expect: () => [
        AIProcessing(),
        AIAnswering("\n\n"),
        AIAnswering("2"),
        AIIdle(),
      ],
    );
  });
}
