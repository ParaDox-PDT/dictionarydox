import 'package:dictionarydox/src/domain/entities/word.dart';
import 'package:hive/hive.dart';

part 'word_model.g.dart';

@HiveType(typeId: 0)
class WordModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String english;

  @HiveField(2)
  final String uzbek;

  @HiveField(3)
  final String? phonetic;

  @HiveField(4)
  final String? audioUrl;

  @HiveField(5)
  final String? example;

  @HiveField(6)
  final String? imageUrl;

  @HiveField(7)
  final String unitId;

  @HiveField(8)
  final String? description;

  WordModel({
    required this.id,
    required this.english,
    required this.uzbek,
    this.phonetic,
    this.audioUrl,
    this.example,
    this.imageUrl,
    required this.unitId,
    this.description,
  });

  /// Convert to domain entity
  Word toEntity() {
    return Word(
      id: id,
      english: english,
      uzbek: uzbek,
      phonetic: phonetic,
      audioUrl: audioUrl,
      example: example,
      imageUrl: imageUrl,
      description: description,
      unitId: unitId,
    );
  }

  /// Create from domain entity
  factory WordModel.fromEntity(Word word) {
    return WordModel(
      id: word.id,
      english: word.english,
      uzbek: word.uzbek,
      phonetic: word.phonetic,
      audioUrl: word.audioUrl,
      example: word.example,
      imageUrl: word.imageUrl,
      unitId: word.unitId,
      description: word.description,
    );
  }
}
