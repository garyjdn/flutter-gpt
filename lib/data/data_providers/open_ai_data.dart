import 'package:dart_openai/dart_openai.dart';

class OpenAIData {
  Stream<OpenAIStreamChatCompletionModel> chatStream(String question) {
    final chatStream = OpenAI.instance.chat.createStream(
      model: "gpt-3.5-turbo",
      messages: [
        OpenAIChatCompletionChoiceMessageModel(
          content: question,
          role: OpenAIChatMessageRole.user,
        )
      ],
    );

    return chatStream;
  }
}
