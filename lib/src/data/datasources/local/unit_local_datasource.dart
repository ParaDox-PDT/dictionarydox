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
        throw CacheException('Unit not found');
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
