import 'package:equatable/equatable.dart';

abstract class UnitEvent extends Equatable {
  const UnitEvent();

  @override
  List<Object> get props => [];
}

class LoadUnitsEvent extends UnitEvent {}

class CreateUnitEvent extends UnitEvent {
  final String name;
  final String? icon;

  const CreateUnitEvent({required this.name, this.icon});

  @override
  List<Object> get props => [name];
}

class LoadUnitWordsEvent extends UnitEvent {
  final String unitId;

  const LoadUnitWordsEvent(this.unitId);

  @override
  List<Object> get props => [unitId];
}

class DeleteWordEvent extends UnitEvent {
  final String wordId;
  final String unitId;

  const DeleteWordEvent({required this.wordId, required this.unitId});

  @override
  List<Object> get props => [wordId, unitId];
}

class DeleteUnitEvent extends UnitEvent {
  final String unitId;

  const DeleteUnitEvent(this.unitId);

  @override
  List<Object> get props => [unitId];
}
