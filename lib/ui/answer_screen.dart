import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/ai/ai_bloc.dart';

class AnswerScreen extends StatefulWidget {
  const AnswerScreen({super.key});

  @override
  State<AnswerScreen> createState() => _AnswerScreenState();
}

class _AnswerScreenState extends State<AnswerScreen> {
  final ScrollController _scrollController = ScrollController();
  String responseMessage = '';

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(20),
        child: BlocConsumer<AIBloc, AIState>(
          listener: (context, state) {
            if (state is AIIdle) {
              Future.delayed(
                const Duration(milliseconds: 200),
                _scrollToBottom,
              );
            }
          },
          builder: (context, state) {
            if (state is AIAnswering) {
              responseMessage += state.response;
              _scrollToBottom();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(responseMessage),
                const SizedBox(height: 30),
                if (state is AIIdle) ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Ask another question'),
                    ),
                  ),
                ]
              ],
            );
          },
        ),
      ),
    );
  }
}
