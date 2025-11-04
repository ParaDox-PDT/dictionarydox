import 'package:dictionarydox/src/domain/entities/unit.dart';
import 'package:dictionarydox/src/domain/usecases/create_unit.dart';
import 'package:dictionarydox/src/domain/usecases/delete_unit.dart';
import 'package:dictionarydox/src/domain/usecases/delete_word.dart';
import 'package:dictionarydox/src/domain/usecases/get_all_units.dart';
import 'package:dictionarydox/src/domain/usecases/get_unit_words.dart';
import 'package:dictionarydox/src/presentation/blocs/unit/unit_event.dart';
import 'package:dictionarydox/src/presentation/blocs/unit/unit_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class UnitBloc extends Bloc<UnitEvent, UnitState> {
  final GetAllUnits getAllUnits;
  final CreateUnit createUnit;
  final DeleteUnit deleteUnit;
  final GetUnitWords getUnitWords;
  final DeleteWord deleteWord;

  UnitBloc({
    required this.getAllUnits,
    required this.createUnit,
    required this.deleteUnit,
    required this.getUnitWords,
    required this.deleteWord,
  }) : super(UnitInitial()) {
    on<LoadUnitsEvent>(_onLoadUnits);
    on<CreateUnitEvent>(_onCreateUnit);
    on<DeleteUnitEvent>(_onDeleteUnit);
    on<LoadUnitWordsEvent>(_onLoadUnitWords);
    on<DeleteWordEvent>(_onDeleteWord);
  }

  Future<void> _onLoadUnits(
      LoadUnitsEvent event, Emitter<UnitState> emit) async {
    emit(UnitLoading());
    final result = await getAllUnits();
    result.fold(
      (failure) => emit(UnitError(failure.message)),
      (units) => emit(UnitsLoaded(units)),
    );
  }

  Future<void> _onCreateUnit(
      CreateUnitEvent event, Emitter<UnitState> emit) async {
    emit(UnitLoading());
    final unit = Unit(
      id: const Uuid().v4(),
      name: event.name,
      icon: event.icon,
    );
    final result = await createUnit(unit);

    // Handle the result
    await result.fold(
      (failure) async {
        emit(UnitError(failure.message));
      },
      (_) async {
        // Reload units after creation
        final unitsResult = await getAllUnits();
        unitsResult.fold(
          (failure) => emit(UnitError(failure.message)),
          (units) => emit(UnitsLoaded(units)),
        );
      },
    );
  }

  Future<void> _onLoadUnitWords(
      LoadUnitWordsEvent event, Emitter<UnitState> emit) async {
    emit(UnitLoading());
    final result = await getUnitWords(event.unitId);
    result.fold(
      (failure) => emit(UnitError(failure.message)),
      (words) => emit(UnitWordsLoaded(words: words, unitId: event.unitId)),
    );
  }

  Future<void> _onDeleteUnit(
      DeleteUnitEvent event, Emitter<UnitState> emit) async {
    emit(UnitLoading());
    final result = await deleteUnit(event.unitId);

    await result.fold(
      (failure) async {
        emit(UnitError(failure.message));
      },
      (_) async {
        // Reload units after deletion
        final unitsResult = await getAllUnits();
        unitsResult.fold(
          (failure) => emit(UnitError(failure.message)),
          (units) => emit(UnitsLoaded(units)),
        );
      },
    );
  }

  Future<void> _onDeleteWord(
      DeleteWordEvent event, Emitter<UnitState> emit) async {
    final result = await deleteWord(event.wordId);
    result.fold(
      (failure) => emit(UnitError(failure.message)),
      (_) {
        // Reload words after deletion
        add(LoadUnitWordsEvent(event.unitId));
      },
    );
  }
}
