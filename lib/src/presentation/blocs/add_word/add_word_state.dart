import 'package:equatable/equatable.dart';

abstract class AddWordState extends Equatable {
  const AddWordState();

  @override
  List<Object?> get props => [];
}

class AddWordInitial extends AddWordState {}

class AddWordValidating extends AddWordState {}

class AddWordValidated extends AddWordState {
  final bool isValid;
  final String? phonetic;
  final String? audioUrl;
  final bool includePronunciation;
  final bool includeImage;
  final bool includeExample;
  final String? selectedImageUrl;

  const AddWordValidated({
    required this.isValid,
    this.phonetic,
    this.audioUrl,
    this.includePronunciation = false,
    this.includeImage = false,
    this.includeExample = false,
    this.selectedImageUrl,
  });

  AddWordValidated copyWith({
    bool? isValid,
    String? phonetic,
    String? audioUrl,
    bool? includePronunciation,
    bool? includeImage,
    bool? includeExample,
    String? selectedImageUrl,
  }) {
    return AddWordValidated(
      isValid: isValid ?? this.isValid,
      phonetic: phonetic ?? this.phonetic,
      audioUrl: audioUrl ?? this.audioUrl,
      includePronunciation: includePronunciation ?? this.includePronunciation,
      includeImage: includeImage ?? this.includeImage,
      includeExample: includeExample ?? this.includeExample,
      selectedImageUrl: selectedImageUrl ?? this.selectedImageUrl,
    );
  }

  @override
  List<Object?> get props => [
        isValid,
        phonetic,
        audioUrl,
        includePronunciation,
        includeImage,
        includeExample,
        selectedImageUrl,
      ];
}

class AddWordSaving extends AddWordState {}

class AddWordSuccess extends AddWordState {}

class AddWordError extends AddWordState {
  final String message;

  const AddWordError(this.message);

  @override
  List<Object> get props => [message];
}
