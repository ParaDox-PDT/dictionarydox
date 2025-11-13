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

  @HiveField(4)
  final bool isGlobal;

  UnitModel({
    required this.id,
    required this.name,
    this.icon,
    this.wordCount = 0,
    this.isGlobal = false,
  });

  /// Convert to domain entity
  Unit toEntity() {
    return Unit(
      id: id,
      name: name,
      icon: icon,
      wordCount: wordCount,
      isGlobal: isGlobal,
    );
  }

  /// Create from domain entity
  factory UnitModel.fromEntity(Unit unit) {
    return UnitModel(
      id: unit.id,
      name: unit.name,
      icon: unit.icon,
      wordCount: unit.wordCount,
      isGlobal: unit.isGlobal,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'wordCount': wordCount,
      'isGlobal': isGlobal,
    };
  }

  /// Create from JSON
  factory UnitModel.fromJson(Map<String, dynamic> json) {
    return UnitModel(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String?,
      wordCount: json['wordCount'] as int? ?? 0,
      isGlobal: json['isGlobal'] as bool? ?? false,
    );
  }
}
