import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gpt/ui/answer_screen.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../bloc/ai/ai_bloc.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _promptCtrl = TextEditingController();

  void sendMessage() async {
    final message = _promptCtrl.text;
    context.read<AIBloc>().add(SendMessage(message));
    final reset = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => const AnswerScreen(),
      ),
    );

    if (reset ?? false) {
      _promptCtrl.clear();
    }
  }

  @override
  void dispose() {
    _promptCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Flutter-GPT"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextFormField(
                  controller: _promptCtrl,
                  minLines: 3,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    label: Text('Message'),
                    hintText:
                        "Ask anything, eg. Give me an essay about programming in 300 words",
                    hintMaxLines: 3,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: sendMessage,
                    child: const Text('Send'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
