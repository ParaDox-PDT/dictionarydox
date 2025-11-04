import 'package:dictionarydox/src/domain/entities/word.dart';
import 'package:dictionarydox/src/domain/usecases/add_word.dart';
import 'package:dictionarydox/src/domain/usecases/search_images.dart';
import 'package:dictionarydox/src/domain/usecases/validate_word.dart';
import 'package:dictionarydox/src/presentation/blocs/add_word/add_word_event.dart';
import 'package:dictionarydox/src/presentation/blocs/add_word/add_word_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class AddWordBloc extends Bloc<AddWordEvent, AddWordState> {
  final ValidateWord validateWord;
  final SearchImages searchImages;
  final AddWord addWord;

  AddWordBloc({
    required this.validateWord,
    required this.searchImages,
    required this.addWord,
  }) : super(AddWordInitial()) {
    on<ValidateEnglishWordEvent>(_onValidateWord);
    on<TogglePronunciationEvent>(_onTogglePronunciation);
    on<ToggleImageEvent>(_onToggleImage);
    on<ToggleExampleEvent>(_onToggleExample);
    on<SelectImageEvent>(_onSelectImage);
    on<SaveWordEvent>(_onSaveWord);
    on<ResetAddWordEvent>(_onReset);
  }

  Future<void> _onValidateWord(
    ValidateEnglishWordEvent event,
    Emitter<AddWordState> emit,
  ) async {
    emit(AddWordValidating());
    final result = await validateWord(event.word);
    result.fold(
      (failure) => emit(AddWordError(failure.message)),
      (validationResult) => emit(AddWordValidated(
        isValid: validationResult.isValid,
        phonetic: validationResult.phonetic,
        audioUrl: validationResult.audioUrl,
      )),
    );
  }

  void _onTogglePronunciation(
    TogglePronunciationEvent event,
    Emitter<AddWordState> emit,
  ) {
    if (state is AddWordValidated) {
      final currentState = state as AddWordValidated;
      emit(currentState.copyWith(includePronunciation: event.include));
    }
  }

  void _onToggleImage(
    ToggleImageEvent event,
    Emitter<AddWordState> emit,
  ) {
    if (state is AddWordValidated) {
      final currentState = state as AddWordValidated;
      emit(currentState.copyWith(includeImage: event.include));
    }
  }

  void _onToggleExample(
    ToggleExampleEvent event,
    Emitter<AddWordState> emit,
  ) {
    if (state is AddWordValidated) {
      final currentState = state as AddWordValidated;
      emit(currentState.copyWith(includeExample: event.include));
    }
  }

  void _onSelectImage(
    SelectImageEvent event,
    Emitter<AddWordState> emit,
  ) {
    if (state is AddWordValidated) {
      final currentState = state as AddWordValidated;
      emit(currentState.copyWith(
        selectedImageUrl: event.imageUrl,
        includeImage: true, // Automatically check when image is selected
      ));
    }
  }

  Future<void> _onSaveWord(
    SaveWordEvent event,
    Emitter<AddWordState> emit,
  ) async {
    if (state is! AddWordValidated) return;

    final currentState = state as AddWordValidated;
    emit(AddWordSaving());

    final word = Word(
      id: const Uuid().v4(),
      english: event.english,
      uzbek: event.uzbek,
      phonetic:
          currentState.includePronunciation ? currentState.phonetic : null,
      audioUrl:
          currentState.includePronunciation ? currentState.audioUrl : null,
      example: currentState.includeExample ? event.example : null,
      imageUrl:
          currentState.includeImage ? currentState.selectedImageUrl : null,
      description: event.description,
      unitId: event.unitId,
    );

    final result = await addWord(word);
    result.fold(
      (failure) => emit(AddWordError(failure.message)),
      (_) => emit(AddWordSuccess()),
    );
  }

  void _onReset(ResetAddWordEvent event, Emitter<AddWordState> emit) {
    emit(AddWordInitial());
  }
}
