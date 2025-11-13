import 'package:equatable/equatable.dart';

/// Domain entity representing a unit (collection of words)
class Unit extends Equatable {
  final String id;
  final String name;
  final String? icon;
  final int wordCount;
  final bool isGlobal;

  const Unit({
    required this.id,
    required this.name,
    this.icon,
    this.wordCount = 0,
    this.isGlobal = false,
  });

  Unit copyWith({
    String? id,
    String? name,
    String? icon,
    int? wordCount,
    bool? isGlobal,
  }) {
    return Unit(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      wordCount: wordCount ?? this.wordCount,
      isGlobal: isGlobal ?? this.isGlobal,
    );
  }

  @override
  List<Object?> get props => [id, name, icon, wordCount, isGlobal];
}
