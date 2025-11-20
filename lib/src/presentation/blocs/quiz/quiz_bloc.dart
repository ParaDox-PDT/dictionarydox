import 'dart:math';

import 'package:dictionarydox/src/domain/entities/word.dart';
import 'package:dictionarydox/src/domain/usecases/get_unit_words.dart';
import 'package:dictionarydox/src/presentation/blocs/quiz/quiz_event.dart';
import 'package:dictionarydox/src/presentation/blocs/quiz/quiz_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final GetUnitWords getUnitWords;
  List<Word> _allWords = [];
  int _currentIndex = 0;

  QuizBloc({required this.getUnitWords}) : super(QuizInitial()) {
    on<StartQuizEvent>(_onStartQuiz);
    on<NextQuestionEvent>(_onNextQuestion);
    on<SelectLetterEvent>(_onSelectLetter);
    on<RemoveLetterEvent>(_onRemoveLetter);
    on<SelectImageOptionEvent>(_onSelectImageOption);
    on<CheckAnswerEvent>(_onCheckAnswer);
  }

  Future<void> _onStartQuiz(
      StartQuizEvent event, Emitter<QuizState> emit) async {
    emit(QuizLoading());
    final result = await getUnitWords(event.unitId);

    result.fold(
      (failure) => emit(QuizError(failure.message)),
      (words) {
        // Filter words based on quiz type
        List<Word> filteredWords = words;
        if (event.quizType == QuizType.image) {
          filteredWords = words.where((w) => w.imageUrl != null).toList();
        } else if (event.quizType == QuizType.listening) {
          // Listening quiz'da barcha so'zlar chiqishi kerak, talaffuz bor yoki yo'qligi tekshirilmaydi
          filteredWords = words; // Filter olib tashlandi - barcha so'zlar
        }

        if (filteredWords.isEmpty) {
          emit(const QuizError('No words available for this quiz type'));
          return;
        }

        _allWords = filteredWords..shuffle();
        _currentIndex = 0;

        emit(_createQuizState(event.quizType, 0));
      },
    );
  }

  void _onNextQuestion(NextQuestionEvent event, Emitter<QuizState> emit) {
    if (state is QuizInProgress) {
      final currentState = state as QuizInProgress;
      _currentIndex++;

      if (_currentIndex >= _allWords.length) {
        emit(QuizCompleted(
          finalScore: currentState.score,
          totalQuestions: _allWords.length,
        ));
      } else {
        emit(_createQuizState(currentState.quizType, currentState.score));
      }
    }
  }

  void _onSelectLetter(SelectLetterEvent event, Emitter<QuizState> emit) {
    if (state is QuizInProgress) {
      final currentState = state as QuizInProgress;
      final newSelected = List<String>.from(currentState.selectedLetters)
        ..add(event.letter);
      final newAvailable = List<String>.from(currentState.availableLetters);
      newAvailable.removeAt(event.index);

      emit(currentState.copyWith(
        selectedLetters: newSelected,
        availableLetters: newAvailable,
        isCorrect: null,
      ));
    }
  }

  void _onRemoveLetter(RemoveLetterEvent event, Emitter<QuizState> emit) {
    if (state is QuizInProgress) {
      final currentState = state as QuizInProgress;
      if (event.index < currentState.selectedLetters.length) {
        final letter = currentState.selectedLetters[event.index];
        final newSelected = List<String>.from(currentState.selectedLetters)
          ..removeAt(event.index);
        final newAvailable = List<String>.from(currentState.availableLetters)
          ..add(letter);

        emit(currentState.copyWith(
          selectedLetters: newSelected,
          availableLetters: newAvailable,
          isCorrect: null,
        ));
      }
    }
  }

  void _onSelectImageOption(
      SelectImageOptionEvent event, Emitter<QuizState> emit) {
    if (state is QuizInProgress) {
      final currentState = state as QuizInProgress;
      emit(currentState.copyWith(
        selectedImageIndex: event.optionIndex,
        isCorrect: null,
      ));
    }
  }

  void _onCheckAnswer(CheckAnswerEvent event, Emitter<QuizState> emit) {
    if (state is QuizInProgress) {
      final currentState = state as QuizInProgress;
      bool isCorrect = false;

      if (currentState.quizType == QuizType.image) {
        // Check if selected image index matches the correct image index
        isCorrect =
            currentState.selectedImageIndex == currentState.correctImageIndex;
      } else {
        // Check if selected letters match the English word
        final answer = currentState.selectedLetters.join('').toLowerCase();
        final correct = currentState.currentWord.english
            .toLowerCase()
            .replaceAll(RegExp(r'[^a-z]'), '');
        isCorrect = answer == correct;
      }

      emit(currentState.copyWith(
        isCorrect: isCorrect,
        score: isCorrect ? currentState.score + 1 : currentState.score,
      ));
    }
  }

  QuizInProgress _createQuizState(QuizType quizType, int score) {
    final word = _allWords[_currentIndex];

    if (quizType == QuizType.image) {
      // Create image options (first is always correct)
      final imageOptions = <String>[word.imageUrl!];
      // Add other random images from other words
      final otherImages = _allWords
          .where((w) => w.id != word.id && w.imageUrl != null)
          .map((w) => w.imageUrl!)
          .toList()
        ..shuffle();
      imageOptions.addAll(otherImages.take(3));

      // Save correct answer index before shuffling
      final correctImageUrl = word.imageUrl!;
      imageOptions.shuffle();
      final correctIndex = imageOptions.indexOf(correctImageUrl);

      return QuizInProgress(
        currentWord: word,
        quizType: quizType,
        imageOptions: imageOptions,
        correctImageIndex: correctIndex,
        currentQuestionIndex: _currentIndex,
        totalQuestions: _allWords.length,
        score: score,
      );
    } else {
      // Generate letters for translation and listening quiz
      final targetWord = word.english.toLowerCase();
      final lettersOnly = targetWord.replaceAll(RegExp(r'[^a-z]'), '');
      final letters = lettersOnly.split('');

      // Add distractor letters
      final random = Random();
      final alphabet = 'abcdefghijklmnopqrstuvwxyz'.split('');
      while (letters.length < lettersOnly.length + 4) {
        final randomLetter = alphabet[random.nextInt(alphabet.length)];
        if (!letters.contains(randomLetter) || random.nextBool()) {
          letters.add(randomLetter);
        }
      }
      letters.shuffle();

      return QuizInProgress(
        currentWord: word,
        quizType: quizType,
        availableLetters: letters,
        selectedLetters: const [],
        currentQuestionIndex: _currentIndex,
        totalQuestions: _allWords.length,
        score: score,
      );
    }
  }
}
