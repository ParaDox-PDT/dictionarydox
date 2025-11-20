import 'package:cloud_firestore/cloud_firestore.dart';

/// User model for Firestore
class UserModel {
  final String id;
  final String email;
  final String displayName;
  final String? photoUrl;
  final String? fcmToken;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.fcmToken,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create UserModel from Firebase Auth User
  factory UserModel.fromFirebaseUser({
    required String uid,
    required String email,
    required String? displayName,
    String? photoUrl,
    String? fcmToken,
  }) {
    final now = DateTime.now();
    return UserModel(
      id: uid,
      email: email,
      displayName: displayName ?? email.split('@')[0],
      photoUrl: photoUrl,
      fcmToken: fcmToken,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Create UserModel from Firestore document
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      photoUrl: data['photoUrl'],
      fcmToken: data['fcmToken'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'fcmToken': fcmToken,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Copy with updated fields
  UserModel copyWith({
    String? email,
    String? displayName,
    String? photoUrl,
    String? fcmToken,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      fcmToken: fcmToken ?? this.fcmToken,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, displayName: $displayName)';
  }
}
