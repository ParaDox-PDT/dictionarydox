import 'package:equatable/equatable.dart';

abstract class AddWordEvent extends Equatable {
  const AddWordEvent();

  @override
  List<Object?> get props => [];
}

class ValidateEnglishWordEvent extends AddWordEvent {
  final String word;

  const ValidateEnglishWordEvent(this.word);

  @override
  List<Object> get props => [word];
}

class TogglePronunciationEvent extends AddWordEvent {
  final bool include;

  const TogglePronunciationEvent(this.include);

  @override
  List<Object> get props => [include];
}

class ToggleImageEvent extends AddWordEvent {
  final bool include;

  const ToggleImageEvent(this.include);

  @override
  List<Object> get props => [include];
}

class ToggleExampleEvent extends AddWordEvent {
  final bool include;

  const ToggleExampleEvent(this.include);

  @override
  List<Object> get props => [include];
}

class SearchImagesEvent extends AddWordEvent {
  final String query;

  const SearchImagesEvent(this.query);

  @override
  List<Object> get props => [query];
}

class SelectImageEvent extends AddWordEvent {
  final String imageUrl;

  const SelectImageEvent(this.imageUrl);

  @override
  List<Object> get props => [imageUrl];
}

class SaveWordEvent extends AddWordEvent {
  final String english;
  final String uzbek;
  final String? example;
  final String? description;
  final String unitId;

  const SaveWordEvent({
    required this.english,
    required this.uzbek,
    this.example,
    this.description,
    required this.unitId,
  });

  @override
  List<Object?> get props => [english, uzbek, example, description, unitId];
}

class ResetAddWordEvent extends AddWordEvent {}
