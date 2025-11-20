import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore model for Word with user-specific fields
class WordFirestoreModel {
  final String id;
  final String english;
  final String uzbek;
  final String? phonetic;
  final String? audioUrl;
  final String? example;
  final String? imageUrl;
  final String? description;
  final String unitId;
  final bool isGlobal;
  final String userId;
  final Timestamp createdAt;

  WordFirestoreModel({
    required this.id,
    required this.english,
    required this.uzbek,
    this.phonetic,
    this.audioUrl,
    this.example,
    this.imageUrl,
    this.description,
    required this.unitId,
    this.isGlobal = false,
    required this.userId,
    required this.createdAt,
  });

  /// Create from Firestore document
  factory WordFirestoreModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WordFirestoreModel(
      id: doc.id,
      english: data['english'] as String,
      uzbek: data['uzbek'] as String,
      phonetic: data['phonetic'] as String?,
      audioUrl: data['audioUrl'] as String?,
      example: data['example'] as String?,
      imageUrl: data['imageUrl'] as String?,
      description: data['description'] as String?,
      unitId: data['unitId'] as String,
      isGlobal: data['isGlobal'] as bool? ?? false,
      userId: data['userId'] as String,
      createdAt: data['createdAt'] as Timestamp,
    );
  }

  /// Create from JSON (for testing or other use cases)
  factory WordFirestoreModel.fromJson(Map<String, dynamic> json) {
    return WordFirestoreModel(
      id: json['id'] as String,
      english: json['english'] as String,
      uzbek: json['uzbek'] as String,
      phonetic: json['phonetic'] as String?,
      audioUrl: json['audioUrl'] as String?,
      example: json['example'] as String?,
      imageUrl: json['imageUrl'] as String?,
      description: json['description'] as String?,
      unitId: json['unitId'] as String,
      isGlobal: json['isGlobal'] as bool? ?? false,
      userId: json['userId'] as String,
      createdAt: json['createdAt'] is Timestamp
          ? json['createdAt'] as Timestamp
          : Timestamp.fromDate(DateTime.parse(json['createdAt'] as String)),
    );
  }

  /// Convert to Firestore document data
  Map<String, dynamic> toFirestore() {
    return {
      'english': english,
      'uzbek': uzbek,
      'phonetic': phonetic,
      'audioUrl': audioUrl,
      'example': example,
      'imageUrl': imageUrl,
      'description': description,
      'unitId': unitId,
      'isGlobal': isGlobal,
      'userId': userId,
      'createdAt': createdAt,
    };
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'english': english,
      'uzbek': uzbek,
      'phonetic': phonetic,
      'audioUrl': audioUrl,
      'example': example,
      'imageUrl': imageUrl,
      'description': description,
      'unitId': unitId,
      'isGlobal': isGlobal,
      'userId': userId,
      'createdAt': createdAt.toDate().toIso8601String(),
    };
  }

  /// Copy with updated fields
  WordFirestoreModel copyWith({
    String? id,
    String? english,
    String? uzbek,
    String? phonetic,
    String? audioUrl,
    String? example,
    String? imageUrl,
    String? description,
    String? unitId,
    bool? isGlobal,
    String? userId,
    Timestamp? createdAt,
  }) {
    return WordFirestoreModel(
      id: id ?? this.id,
      english: english ?? this.english,
      uzbek: uzbek ?? this.uzbek,
      phonetic: phonetic ?? this.phonetic,
      audioUrl: audioUrl ?? this.audioUrl,
      example: example ?? this.example,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      unitId: unitId ?? this.unitId,
      isGlobal: isGlobal ?? this.isGlobal,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'WordFirestoreModel(id: $id, english: $english, uzbek: $uzbek, unitId: $unitId, userId: $userId)';
  }
}

