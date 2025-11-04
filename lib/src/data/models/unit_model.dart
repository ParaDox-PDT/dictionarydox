import 'package:dictionarydox/src/domain/entities/unit.dart';
import 'package:hive/hive.dart';

part 'unit_model.g.dart';

@HiveType(typeId: 1)
class UnitModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? icon;

  @HiveField(3)
  final int wordCount;

  UnitModel({
    required this.id,
    required this.name,
    this.icon,
    this.wordCount = 0,
  });

  /// Convert to domain entity
  Unit toEntity() {
    return Unit(
      id: id,
      name: name,
      icon: icon,
      wordCount: wordCount,
    );
  }

  /// Create from domain entity
  factory UnitModel.fromEntity(Unit unit) {
    return UnitModel(
      id: unit.id,
      name: unit.name,
      icon: unit.icon,
      wordCount: unit.wordCount,
    );
  }
}
