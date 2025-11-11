import 'package:dictionarydox/src/core/error/exceptions.dart';
import 'package:dictionarydox/src/core/storage/storage_service.dart';
import 'package:dictionarydox/src/data/models/unit_model.dart';

abstract class UnitLocalDataSource {
  Future<UnitModel> createUnit(UnitModel unit);
  Future<UnitModel> updateUnit(UnitModel unit);
  Future<void> deleteUnit(String unitId);
  Future<UnitModel> getUnit(String unitId);
  Future<List<UnitModel>> getAllUnits();
}

class UnitLocalDataSourceImpl implements UnitLocalDataSource {
  final StorageService unitStorage;
  final StorageService wordStorage;

  UnitLocalDataSourceImpl({
    required this.unitStorage,
    required this.wordStorage,
  });

  @override
  Future<UnitModel> createUnit(UnitModel unit) async {
    try {
      await unitStorage.put(unit.id, unit);
      return unit;
    } catch (e) {
      throw CacheException('Failed to create unit: $e');
    }
  }

  @override
  Future<UnitModel> updateUnit(UnitModel unit) async {
    try {
      await unitStorage.put(unit.id, unit);
      return unit;
    } catch (e) {
      throw CacheException('Failed to update unit: $e');
    }
  }

  @override
  Future<void> deleteUnit(String unitId) async {
    try {
      // First, delete all words associated with this unit
      final allWords = wordStorage.getAll<dynamic>();
      final wordsToDelete = allWords
          .where((word) => (word as dynamic).unitId == unitId)
          .map((word) => (word as dynamic).id as String)
          .toList();

      for (final wordId in wordsToDelete) {
        await wordStorage.delete(wordId);
      }

      // Then delete the unit itself
      await unitStorage.delete(unitId);
    } catch (e) {
      throw CacheException('Failed to delete unit: $e');
    }
  }

  @override
  Future<UnitModel> getUnit(String unitId) async {
    try {
      final unit = unitStorage.get<UnitModel>(unitId);
      if (unit == null) {
        throw const CacheException('Unit not found');
      }
      return unit;
    } catch (e) {
      throw CacheException('Failed to get unit: $e');
    }
  }

  @override
  Future<List<UnitModel>> getAllUnits() async {
    try {
      return unitStorage.getAll<UnitModel>().toList();
    } catch (e) {
      throw CacheException('Failed to get all units: $e');
    }
  }
}
