import 'package:dictionarydox/src/core/error/exceptions.dart';
import 'package:dictionarydox/src/data/models/unit_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class UnitLocalDataSource {
  Future<UnitModel> createUnit(UnitModel unit);
  Future<UnitModel> updateUnit(UnitModel unit);
  Future<void> deleteUnit(String unitId);
  Future<UnitModel> getUnit(String unitId);
  Future<List<UnitModel>> getAllUnits();
}

class UnitLocalDataSourceImpl implements UnitLocalDataSource {
  static const String boxName = 'units';
  static const String wordsBoxName = 'words';
  final Box<UnitModel> box;

  UnitLocalDataSourceImpl(this.box);

  @override
  Future<UnitModel> createUnit(UnitModel unit) async {
    try {
      await box.put(unit.id, unit);
      return unit;
    } catch (e) {
      throw CacheException('Failed to create unit: $e');
    }
  }

  @override
  Future<UnitModel> updateUnit(UnitModel unit) async {
    try {
      await box.put(unit.id, unit);
      return unit;
    } catch (e) {
      throw CacheException('Failed to update unit: $e');
    }
  }

  @override
  Future<void> deleteUnit(String unitId) async {
    try {
      // First, delete all words associated with this unit
      final wordsBox = await Hive.openBox(wordsBoxName);

      // Get all keys of words that belong to this unit
      final keysToDelete = <dynamic>[];
      for (final key in wordsBox.keys) {
        final word = wordsBox.get(key);
        if (word != null && word.unitId == unitId) {
          keysToDelete.add(key);
        }
      }

      // Delete all words belonging to this unit
      for (final key in keysToDelete) {
        await wordsBox.delete(key);
      }

      // Then delete the unit itself
      await box.delete(unitId);
    } catch (e) {
      throw CacheException('Failed to delete unit: $e');
    }
  }

  @override
  Future<UnitModel> getUnit(String unitId) async {
    try {
      final unit = box.get(unitId);
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
      return box.values.toList();
    } catch (e) {
      throw CacheException('Failed to get all units: $e');
    }
  }
}
