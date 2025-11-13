import 'package:dictionarydox/src/presentation/blocs/add_word/add_word_bloc.dart';
import 'package:dictionarydox/src/presentation/blocs/add_word/add_word_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';

mixin AddWordMixin<T extends StatefulWidget> on State<T> {
  final formKey = GlobalKey<FormState>();
  final englishController = TextEditingController();
  final uzbekController = TextEditingController();

  final exampleController = TextEditingController();
  final descriptionController = TextEditingController();
  final flutterTts = FlutterTts();

  bool hasValidated = false;

  @override
  void initState() {
    super.initState();
    flutterTts.setLanguage('en-US');
  }

  @override
  void dispose() {
    englishController.dispose();
    uzbekController.dispose();
    exampleController.dispose();
    descriptionController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  void validateWord(BuildContext context) {
    if (englishController.text.trim().isNotEmpty) {
      context.read<AddWordBloc>().add(
            ValidateEnglishWordEvent(englishController.text.trim()),
          );
      setState(() => hasValidated = true);
    }
  }

  Future<void> speakWord(String word) async {
    await flutterTts.speak(word);
  }
}
