import 'package:dart_openai/dart_openai.dart';

import '../data_providers/open_ai_data.dart';

class AIRepository {
  final OpenAIData openAIData;

  AIRepository(this.openAIData);

  Stream<OpenAIStreamChatCompletionChoiceModel> chat(String message) {
    return openAIData.chatStream(message).map((e) {
      return e.choices.first;
    });
  }
}
