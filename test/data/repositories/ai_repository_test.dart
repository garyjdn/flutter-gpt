import 'dart:convert';
import 'dart:io';

import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_gpt/data/repositories/ai_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/mock_helpers.dart';

void main() {
  late MockOpenAIData mockOpenAIData;
  late AIRepository aiRepository;
  List<OpenAIStreamChatCompletionModel> modelData = [];

  setUp(() async {
    final responseDataJson =
        await File('test/fixtures/chat_completion_response.json')
            .readAsString();
    final responseData = jsonDecode(responseDataJson);
    for (int i = 0; i < responseData.length; i++) {
      modelData.add(OpenAIStreamChatCompletionModel.fromMap(responseData[i]));
    }
    mockOpenAIData = MockOpenAIData();
    aiRepository = AIRepository(mockOpenAIData);
    when(mockOpenAIData.chatStream(''))
        .thenAnswer((_) => Stream.fromIterable(modelData));
  });

  group('AIRepository - test chat function', () {
    test(
      'Given any message, When listen to the stream and Receive a valid data, Then map and return the first choice data',
      () {
        final stream = aiRepository.chat('');
        expect(
          stream,
          emitsInOrder(modelData.map((d) => d.choices.first)),
        );
      },
    );
  });
}
