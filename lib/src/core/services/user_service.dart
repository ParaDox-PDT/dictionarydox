import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dictionarydox/src/data/models/user_model.dart';
import 'package:flutter/foundation.dart';

/// Service for managing users in Firestore
class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _usersCollection = 'users';

  /// Create or update user in Firestore
  Future<void> createOrUpdateUser(UserModel user) async {
    try {
      await _firestore.collection(_usersCollection).doc(user.id).set(
            user.toFirestore(),
            SetOptions(merge: true),
          );

      if (kDebugMode) {
        print('User saved to Firestore: ${user.email}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving user to Firestore: $e');
      }
      rethrow;
    }
  }

  /// Get user from Firestore
  Future<UserModel?> getUser(String userId) async {
    try {
      final doc =
          await _firestore.collection(_usersCollection).doc(userId).get();

      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user from Firestore: $e');
      }
      rethrow;
    }
  }

  /// Update user display name
  Future<void> updateDisplayName(String userId, String displayName) async {
    try {
      await _firestore.collection(_usersCollection).doc(userId).update({
        'displayName': displayName,
        'updatedAt': Timestamp.now(),
      });

      if (kDebugMode) {
        print('User display name updated: $displayName');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating display name: $e');
      }
      rethrow;
    }
  }

  /// Update user photo URL
  Future<void> updatePhotoUrl(String userId, String? photoUrl) async {
    try {
      await _firestore.collection(_usersCollection).doc(userId).update({
        'photoUrl': photoUrl,
        'updatedAt': Timestamp.now(),
      });

      if (kDebugMode) {
        print('User photo URL updated');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating photo URL: $e');
      }
      rethrow;
    }
  }

  /// Update user FCM token
  Future<void> updateFcmToken(String userId, String fcmToken) async {
    try {
      await _firestore.collection(_usersCollection).doc(userId).update({
        'fcmToken': fcmToken,
        'updatedAt': Timestamp.now(),
      });

      if (kDebugMode) {
        print('User FCM token updated');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating FCM token: $e');
      }
      rethrow;
    }
  }

  /// Delete user from Firestore
  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection(_usersCollection).doc(userId).delete();

      if (kDebugMode) {
        print('User deleted from Firestore: $userId');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting user from Firestore: $e');
      }
      rethrow;
    }
  }

  /// Listen to user changes
  Stream<UserModel?> getUserStream(String userId) {
    return _firestore
        .collection(_usersCollection)
        .doc(userId)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    });
  }

  /// Check if user exists
  Future<bool> userExists(String userId) async {
    try {
      final doc =
          await _firestore.collection(_usersCollection).doc(userId).get();
      return doc.exists;
    } catch (e) {
      if (kDebugMode) {
        print('Error checking user existence: $e');
      }
      return false;
    }
  }
}
