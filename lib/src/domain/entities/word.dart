import 'package:equatable/equatable.dart';

/// Domain entity representing a vocabulary word
class Word extends Equatable {
  final String id;
  final String english;
  final String uzbek;
  final String? phonetic;
  final String? audioUrl;
  final String? example;
  final String? imageUrl;
  final String? description;
  final String unitId;

  const Word({
    required this.id,
    required this.english,
    required this.uzbek,
    this.phonetic,
    this.audioUrl,
    this.example,
    this.imageUrl,
    this.description,
    required this.unitId,
  });

  Word copyWith({
    String? id,
    String? english,
    String? uzbek,
    String? phonetic,
    String? audioUrl,
    String? example,
    String? imageUrl,
    String? description,
    String? unitId,
  }) {
    return Word(
      id: id ?? this.id,
      english: english ?? this.english,
      uzbek: uzbek ?? this.uzbek,
      phonetic: phonetic ?? this.phonetic,
      audioUrl: audioUrl ?? this.audioUrl,
      example: example ?? this.example,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      unitId: unitId ?? this.unitId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        english,
        uzbek,
        phonetic,
        audioUrl,
        example,
        imageUrl,
        description,
        unitId,
      ];
}
