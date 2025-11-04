import 'package:equatable/equatable.dart';

enum QuizType { translation, image, listening }

abstract class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object> get props => [];
}

class StartQuizEvent extends QuizEvent {
  final String unitId;
  final QuizType quizType;

  const StartQuizEvent({required this.unitId, required this.quizType});

  @override
  List<Object> get props => [unitId, quizType];
}

class NextQuestionEvent extends QuizEvent {}

class SelectLetterEvent extends QuizEvent {
  final String letter;
  final int index;

  const SelectLetterEvent({required this.letter, required this.index});

  @override
  List<Object> get props => [letter, index];
}

class RemoveLetterEvent extends QuizEvent {
  final int index;

  const RemoveLetterEvent(this.index);

  @override
  List<Object> get props => [index];
}

class SelectImageOptionEvent extends QuizEvent {
  final int optionIndex;

  const SelectImageOptionEvent(this.optionIndex);

  @override
  List<Object> get props => [optionIndex];
}

class CheckAnswerEvent extends QuizEvent {}

class PlayPronunciationEvent extends QuizEvent {}
