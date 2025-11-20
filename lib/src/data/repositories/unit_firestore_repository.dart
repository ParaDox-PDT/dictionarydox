import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dictionarydox/src/core/services/auth_service.dart';
import 'package:dictionarydox/src/data/models/unit_firestore_model.dart';
import 'package:flutter/foundation.dart';

/// Repository for managing user-specific Units in Firestore
class UnitFirestoreRepository {
  static final UnitFirestoreRepository _instance =
      UnitFirestoreRepository._internal();
  factory UnitFirestoreRepository() => _instance;
  UnitFirestoreRepository._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();
  final String _collection = 'units';

  /// Get current user ID
  String? get _currentUserId => _authService.currentUser?.uid;

  /// Create a new unit
  /// Automatically sets usersId array with current user and isGlobal = false
  Future<UnitFirestoreModel> createUnit({
    required String title,
    String? icon,
    String? id,
  }) async {
    try {
      final userId = _currentUserId;
      if (userId == null) {
        throw Exception('User must be authenticated to create a unit');
      }

      final unitId = id ?? _firestore.collection(_collection).doc().id;
      final now = FieldValue.serverTimestamp();

      final unit = UnitFirestoreModel(
        id: unitId,
        title: title,
        icon: icon,
        createdAt: Timestamp.now(), // Will be replaced by serverTimestamp
        isGlobal: false,
        usersId: [userId], // Initialize with current user ID
      );

      // Convert to Firestore data and replace createdAt with serverTimestamp
      final data = unit.toFirestore();
      data['createdAt'] = now;

      await _firestore.collection(_collection).doc(unitId).set(data);

      if (kDebugMode) {
        print('Unit created: $unitId');
      }

      // Fetch the created document to get the actual serverTimestamp
      final doc = await _firestore.collection(_collection).doc(unitId).get();
      return UnitFirestoreModel.fromFirestore(doc);
    } catch (e) {
      if (kDebugMode) {
        print('Error creating unit: $e');
      }
      rethrow;
    }
  }

  /// Update an existing unit
  Future<UnitFirestoreModel> updateUnit(UnitFirestoreModel unit) async {
    try {
      final userId = _currentUserId;
      if (userId == null) {
        throw Exception('User must be authenticated to update a unit');
      }

      // Verify ownership - user must be in usersId array
      if (!unit.usersId.contains(userId)) {
        throw Exception('User does not have permission to update this unit');
      }

      final data = unit.toFirestore();
      await _firestore.collection(_collection).doc(unit.id).update(data);

      if (kDebugMode) {
        print('Unit updated: ${unit.id}');
      }

      // Fetch the updated document
      final doc = await _firestore.collection(_collection).doc(unit.id).get();
      return UnitFirestoreModel.fromFirestore(doc);
    } catch (e) {
      if (kDebugMode) {
        print('Error updating unit: $e');
      }
      rethrow;
    }
  }

  /// Delete a unit
  Future<void> deleteUnit(String unitId) async {
    try {
      final userId = _currentUserId;
      if (userId == null) {
        throw Exception('User must be authenticated to delete a unit');
      }

      // Verify ownership before deleting
      final doc = await _firestore.collection(_collection).doc(unitId).get();
      if (!doc.exists) {
        throw Exception('Unit not found');
      }

      final unit = UnitFirestoreModel.fromFirestore(doc);
      // Verify ownership - user must be in usersId array
      if (!unit.usersId.contains(userId)) {
        throw Exception('User does not have permission to delete this unit');
      }

      await _firestore.collection(_collection).doc(unitId).delete();

      if (kDebugMode) {
        print('Unit deleted: $unitId');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting unit: $e');
      }
      rethrow;
    }
  }

  /// Get a single unit by ID
  Future<UnitFirestoreModel?> getUnit(String unitId) async {
    try {
      final userId = _currentUserId;
      if (userId == null) {
        throw Exception('User must be authenticated to get a unit');
      }

      final doc = await _firestore.collection(_collection).doc(unitId).get();

      if (!doc.exists) {
        return null;
      }

      final unit = UnitFirestoreModel.fromFirestore(doc);

      // Verify ownership - user must be in usersId array or unit must be global
      if (!unit.usersId.contains(userId) && !unit.isGlobal) {
        throw Exception('User does not have permission to access this unit');
      }

      return unit;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting unit: $e');
      }
      rethrow;
    }
  }

  /// Get all units for the current user
  /// Only returns units where userId matches and isGlobal = false
  Future<List<UnitFirestoreModel>> getUserUnits() async {
    try {
      final userId = _currentUserId;
      if (userId == null) {
        throw Exception('User must be authenticated to get units');
      }

      final querySnapshot = await _firestore
          .collection(_collection)
          .where('usersId', arrayContains: userId)
          .where('isGlobal', isEqualTo: false)
          .orderBy('createdAt', descending: true)
          .get();

      final units = querySnapshot.docs
          .map((doc) => UnitFirestoreModel.fromFirestore(doc))
          .toList();

      if (kDebugMode) {
        print('Fetched ${units.length} user units');
      }

      return units;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user units: $e');
      }
      rethrow;
    }
  }

  /// Stream of user units (real-time updates)
  Stream<List<UnitFirestoreModel>> getUserUnitsStream() {
    final userId = _currentUserId;
    if (userId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection(_collection)
        .where('usersId', arrayContains: userId)
        .where('isGlobal', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UnitFirestoreModel.fromFirestore(doc))
            .toList());
  }
}

