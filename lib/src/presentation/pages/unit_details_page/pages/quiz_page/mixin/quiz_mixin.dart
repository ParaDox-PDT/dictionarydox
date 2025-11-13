import 'package:audioplayers/audioplayers.dart';
import 'package:dictionarydox/src/presentation/blocs/quiz/quiz_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

mixin QuizMixin<T extends StatefulWidget> on State<T> {
  final audioPlayer = AudioPlayer();
  final flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    flutterTts.setLanguage('en-US');
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    flutterTts.stop();
    super.dispose();
  }

  String getQuizTitle(QuizType quizType) {
    switch (quizType) {
      case QuizType.translation:
        return 'Translation Quiz';
      case QuizType.image:
        return 'Image Quiz';
      case QuizType.listening:
        return 'Listening Quiz';
    }
  }

  bool canCheckAnswer(dynamic state, QuizType quizType) {
    if (quizType == QuizType.image) {
      return state.selectedImageIndex != null;
    } else {
      return state.selectedLetters.isNotEmpty;
    }
  }

  Future<void> playWordPronunciation(dynamic word) async {
    if (word.audioUrl != null) {
      try {
        await audioPlayer.play(UrlSource(word.audioUrl));
      } catch (e) {
        await flutterTts.speak(word.english);
      }
    } else {
      await flutterTts.speak(word.english);
    }
  }
}
