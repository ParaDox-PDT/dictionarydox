import 'package:dictionarydox/src/core/services/auth_service.dart';
import 'package:dictionarydox/src/data/repositories/unit_firestore_repository.dart';
import 'package:flutter/foundation.dart';

/// Example: How to share a unit with other users
class UnitShareExample {
  final UnitFirestoreRepository _unitRepository = UnitFirestoreRepository();
  final AuthService _authService = AuthService();

  /// Example: Share a unit with another user
  Future<void> shareUnitWithUser(String unitId, String otherUserId) async {
    try {
      if (!_authService.isSignedIn) {
        if (kDebugMode) {
          print('User must be signed in to share a unit');
        }
        return;
      }

      // Get the existing unit
      final unit = await _unitRepository.getUnit(unitId);
      if (unit == null) {
        if (kDebugMode) {
          print('Unit not found');
        }
        return;
      }

      // Add the other user to the usersId array
      final updatedUnit = unit.addUser(otherUserId);

      // Update the unit in Firestore
      await _unitRepository.updateUnit(updatedUnit);

      if (kDebugMode) {
        print('Unit shared with user: $otherUserId');
        print('Users with access: ${updatedUnit.usersId}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error sharing unit: $e');
      }
    }
  }

  /// Example: Remove a user from a shared unit
  Future<void> removeUserFromUnit(String unitId, String userIdToRemove) async {
    try {
      if (!_authService.isSignedIn) {
        if (kDebugMode) {
          print('User must be signed in to remove a user from a unit');
        }
        return;
      }

      final currentUserId = _authService.currentUser?.uid;
      if (currentUserId == null) {
        return;
      }

      // Get the existing unit
      final unit = await _unitRepository.getUnit(unitId);
      if (unit == null) {
        if (kDebugMode) {
          print('Unit not found');
        }
        return;
      }

      // Only the creator (first user in array) can remove others
      // Or user can remove themselves
      if (unit.usersId.isNotEmpty && 
          unit.usersId[0] == currentUserId || 
          userIdToRemove == currentUserId) {
        // Remove the user from the usersId array
        final updatedUnit = unit.removeUser(userIdToRemove);

        // Update the unit in Firestore
        await _unitRepository.updateUnit(updatedUnit);

        if (kDebugMode) {
          print('User removed from unit: $userIdToRemove');
          print('Remaining users: ${updatedUnit.usersId}');
        }
      } else {
        if (kDebugMode) {
          print('You do not have permission to remove this user');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error removing user from unit: $e');
      }
    }
  }

  /// Example: Share a unit with multiple users
  Future<void> shareUnitWithMultipleUsers(
    String unitId,
    List<String> userIds,
  ) async {
    try {
      if (!_authService.isSignedIn) {
        if (kDebugMode) {
          print('User must be signed in to share a unit');
        }
        return;
      }

      // Get the existing unit
      final unit = await _unitRepository.getUnit(unitId);
      if (unit == null) {
        if (kDebugMode) {
          print('Unit not found');
        }
        return;
      }

      // Add all users to the usersId array
      var updatedUnit = unit;
      for (final userId in userIds) {
        updatedUnit = updatedUnit.addUser(userId);
      }

      // Update the unit in Firestore
      await _unitRepository.updateUnit(updatedUnit);

      if (kDebugMode) {
        print('Unit shared with ${userIds.length} users');
        print('All users with access: ${updatedUnit.usersId}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error sharing unit with multiple users: $e');
      }
    }
  }

  /// Example: Check if a user has access to a unit
  Future<bool> checkUserAccess(String unitId, String userId) async {
    try {
      final unit = await _unitRepository.getUnit(unitId);
      if (unit == null) {
        return false;
      }

      // Check if user is in usersId array or unit is global
      return unit.isGlobal || unit.hasUser(userId);
    } catch (e) {
      if (kDebugMode) {
        print('Error checking user access: $e');
      }
      return false;
    }
  }
}

