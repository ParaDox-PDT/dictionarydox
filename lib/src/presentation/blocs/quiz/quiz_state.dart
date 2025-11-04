import 'package:dictionarydox/src/domain/entities/word.dart';
import 'package:dictionarydox/src/presentation/blocs/quiz/quiz_event.dart';
import 'package:equatable/equatable.dart';

abstract class QuizState extends Equatable {
  const QuizState();

  @override
  List<Object?> get props => [];
}

class QuizInitial extends QuizState {}

class QuizLoading extends QuizState {}

class QuizInProgress extends QuizState {
  final Word currentWord;
  final QuizType quizType;
  final List<String> availableLetters;
  final List<String> selectedLetters;
  final List<String>? imageOptions;
  final int? selectedImageIndex;
  final int? correctImageIndex;
  final int currentQuestionIndex;
  final int totalQuestions;
  final int score;
  final bool? isCorrect;

  const QuizInProgress({
    required this.currentWord,
    required this.quizType,
    this.availableLetters = const [],
    this.selectedLetters = const [],
    this.imageOptions,
    this.selectedImageIndex,
    this.correctImageIndex,
    required this.currentQuestionIndex,
    required this.totalQuestions,
    this.score = 0,
    this.isCorrect,
  });

  QuizInProgress copyWith({
    Word? currentWord,
    QuizType? quizType,
    List<String>? availableLetters,
    List<String>? selectedLetters,
    List<String>? imageOptions,
    int? selectedImageIndex,
    int? correctImageIndex,
    int? currentQuestionIndex,
    int? totalQuestions,
    int? score,
    bool? isCorrect,
  }) {
    return QuizInProgress(
      currentWord: currentWord ?? this.currentWord,
      quizType: quizType ?? this.quizType,
      availableLetters: availableLetters ?? this.availableLetters,
      selectedLetters: selectedLetters ?? this.selectedLetters,
      imageOptions: imageOptions ?? this.imageOptions,
      selectedImageIndex: selectedImageIndex ?? this.selectedImageIndex,
      correctImageIndex: correctImageIndex ?? this.correctImageIndex,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      score: score ?? this.score,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }

  @override
  List<Object?> get props => [
        currentWord,
        quizType,
        availableLetters,
        selectedLetters,
        imageOptions,
        selectedImageIndex,
        correctImageIndex,
        currentQuestionIndex,
        totalQuestions,
        score,
        isCorrect,
      ];
}

class QuizCompleted extends QuizState {
  final int finalScore;
  final int totalQuestions;

  const QuizCompleted({
    required this.finalScore,
    required this.totalQuestions,
  });

  @override
  List<Object> get props => [finalScore, totalQuestions];
}

class QuizError extends QuizState {
  final String message;

  const QuizError(this.message);

  @override
  List<Object> get props => [message];
}
