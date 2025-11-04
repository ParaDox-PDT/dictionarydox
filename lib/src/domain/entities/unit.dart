import 'package:equatable/equatable.dart';

/// Domain entity representing a unit (collection of words)
class Unit extends Equatable {
  final String id;
  final String name;
  final String? icon;
  final int wordCount;

  const Unit({
    required this.id,
    required this.name,
    this.icon,
    this.wordCount = 0,
  });

  Unit copyWith({
    String? id,
    String? name,
    String? icon,
    int? wordCount,
  }) {
    return Unit(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      wordCount: wordCount ?? this.wordCount,
    );
  }

  @override
  List<Object?> get props => [id, name, icon, wordCount];
}
