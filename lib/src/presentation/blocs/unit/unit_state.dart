import 'package:dictionarydox/src/domain/entities/unit.dart';
import 'package:dictionarydox/src/domain/entities/word.dart';
import 'package:equatable/equatable.dart';

abstract class UnitState extends Equatable {
  const UnitState();

  @override
  List<Object> get props => [];
}

class UnitInitial extends UnitState {}

class UnitLoading extends UnitState {}

class UnitsLoaded extends UnitState {
  final List<Unit> units;

  const UnitsLoaded(this.units);

  @override
  List<Object> get props => [units];
}

class UnitWordsLoaded extends UnitState {
  final List<Word> words;
  final String unitId;

  const UnitWordsLoaded({required this.words, required this.unitId});

  @override
  List<Object> get props => [words, unitId];
}

class UnitError extends UnitState {
  final String message;

  const UnitError(this.message);

  @override
  List<Object> get props => [message];
}
