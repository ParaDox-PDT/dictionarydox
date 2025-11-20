import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dictionarydox/src/core/error/exceptions.dart';
import 'package:dictionarydox/src/data/models/unit_model.dart';
import 'package:flutter/foundation.dart';

abstract class UnitRemoteDataSource {
  Future<List<UnitModel>> getGlobalUnits();
}

class UnitRemoteDataSourceImpl implements UnitRemoteDataSource {
  final FirebaseFirestore _firestore;

  UnitRemoteDataSourceImpl(this._firestore);

  @override
  Future<List<UnitModel>> getGlobalUnits() async {
    try {
      final querySnapshot = await _firestore
          .collection('units')
          .where('isGlobal', isEqualTo: true)
          .get();

      final units = <UnitModel>[];

      for (final doc in querySnapshot.docs) {
        try {
          final data = doc.data();
          final unitId = doc.id;
          
          // Merge document ID with data
          final unitData = {
            ...data,
            'id': unitId,
          };

          // Use wordCount from unit model (from Firebase document)
          // If wordCount is not in data, default to 0
          final unit = UnitModel.fromJson(unitData);
          units.add(unit);
        } catch (e) {
          if (kDebugMode) {
            print('Error parsing unit document ${doc.id}: $e');
          }
          // Continue with other documents even if one fails
        }
      }

      if (kDebugMode) {
        print('Fetched ${units.length} global units from Firebase');
      }

      return units;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching global units from Firebase: $e');
      }
      throw ServerException('Failed to fetch global units: $e');
    }
  }
}

