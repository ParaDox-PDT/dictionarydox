import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore model for Unit with user-specific fields
class UnitFirestoreModel {
  final String id;
  final String title;
  final String? icon;
  final Timestamp createdAt;
  final bool isGlobal;
  final List<String> usersId; // Array of user IDs who have access to this unit

  UnitFirestoreModel({
    required this.id,
    required this.title,
    this.icon,
    required this.createdAt,
    this.isGlobal = false,
    required this.usersId,
  });

  /// Create from Firestore document
  factory UnitFirestoreModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    // Handle both old format (userId as String) and new format (usersId as List)
    List<String> usersId;
    if (data['usersId'] != null) {
      usersId = List<String>.from(data['usersId'] as List);
    } else if (data['userId'] != null) {
      // Migration: convert old userId to usersId array
      usersId = [data['userId'] as String];
    } else {
      usersId = [];
    }
    
    return UnitFirestoreModel(
      id: doc.id,
      title: data['title'] as String,
      icon: data['icon'] as String?,
      createdAt: data['createdAt'] as Timestamp,
      isGlobal: data['isGlobal'] as bool? ?? false,
      usersId: usersId,
    );
  }

  /// Create from JSON (for testing or other use cases)
  factory UnitFirestoreModel.fromJson(Map<String, dynamic> json) {
    List<String> usersId;
    if (json['usersId'] != null) {
      usersId = List<String>.from(json['usersId'] as List);
    } else if (json['userId'] != null) {
      // Migration: convert old userId to usersId array
      usersId = [json['userId'] as String];
    } else {
      usersId = [];
    }
    
    return UnitFirestoreModel(
      id: json['id'] as String,
      title: json['title'] as String,
      icon: json['icon'] as String?,
      createdAt: json['createdAt'] is Timestamp
          ? json['createdAt'] as Timestamp
          : Timestamp.fromDate(DateTime.parse(json['createdAt'] as String)),
      isGlobal: json['isGlobal'] as bool? ?? false,
      usersId: usersId,
    );
  }

  /// Convert to Firestore document data
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'icon': icon,
      'createdAt': createdAt,
      'isGlobal': isGlobal,
      'usersId': usersId,
    };
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'icon': icon,
      'createdAt': createdAt.toDate().toIso8601String(),
      'isGlobal': isGlobal,
      'usersId': usersId,
    };
  }

  /// Copy with updated fields
  UnitFirestoreModel copyWith({
    String? id,
    String? title,
    String? icon,
    Timestamp? createdAt,
    bool? isGlobal,
    List<String>? usersId,
  }) {
    return UnitFirestoreModel(
      id: id ?? this.id,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      createdAt: createdAt ?? this.createdAt,
      isGlobal: isGlobal ?? this.isGlobal,
      usersId: usersId ?? this.usersId,
    );
  }
  
  /// Add a user to the usersId array
  UnitFirestoreModel addUser(String userId) {
    if (!usersId.contains(userId)) {
      return copyWith(usersId: [...usersId, userId]);
    }
    return this;
  }
  
  /// Remove a user from the usersId array
  UnitFirestoreModel removeUser(String userId) {
    return copyWith(usersId: usersId.where((id) => id != userId).toList());
  }
  
  /// Check if a user has access to this unit
  bool hasUser(String userId) {
    return usersId.contains(userId);
  }

  @override
  String toString() {
    return 'UnitFirestoreModel(id: $id, title: $title, icon: $icon, usersId: $usersId, isGlobal: $isGlobal)';
  }
}

