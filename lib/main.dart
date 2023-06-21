import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gpt/env.dart';
import 'package:flutter_gpt/ui/chat_screen.dart';

import 'bloc/ai/ai_bloc.dart';
import 'data/data_providers/open_ai_data.dart';
import 'data/repositories/ai_repository.dart';

void main() {
  // Setup OpenAI Instance
  OpenAI.apiKey = OPEN_AI_API_KEY;

  // Data Provider Layer
  final openAIData = OpenAIData();

  // Repository Layer
  final aiRepository = AIRepository(openAIData);

  runApp(BlocProvider(
    create: (context) => AIBloc(aiRepository: aiRepository),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter-GPT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff00A67E)),
        brightness: Brightness.dark,
        primaryColor: const Color(0xff00A67E),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
      home: const ChatScreen(),
    );
  }
}
