import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dictionarydox/src/core/services/auth_service.dart';
import 'package:dictionarydox/src/data/models/word_firestore_model.dart';
import 'package:flutter/foundation.dart';

/// Repository for managing user-specific Words in Firestore
class WordFirestoreRepository {
  static final WordFirestoreRepository _instance =
      WordFirestoreRepository._internal();
  factory WordFirestoreRepository() => _instance;
  WordFirestoreRepository._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();
  final String _collection = 'words';

  /// Get current user ID
  String? get _currentUserId => _authService.currentUser?.uid;

  /// Create a new word
  /// Automatically sets userId and isGlobal = false
  Future<WordFirestoreModel> createWord({
    required String english,
    required String uzbek,
    required String unitId,
    String? phonetic,
    String? audioUrl,
    String? example,
    String? imageUrl,
    String? description,
    String? id,
  }) async {
    try {
      final userId = _currentUserId;
      if (userId == null) {
        throw Exception('User must be authenticated to create a word');
      }

      final wordId = id ?? _firestore.collection(_collection).doc().id;
      final now = FieldValue.serverTimestamp();

      final word = WordFirestoreModel(
        id: wordId,
        english: english,
        uzbek: uzbek,
        phonetic: phonetic,
        audioUrl: audioUrl,
        example: example,
        imageUrl: imageUrl,
        description: description,
        unitId: unitId,
        isGlobal: false,
        userId: userId,
        createdAt: Timestamp.now(), // Will be replaced by serverTimestamp
      );

      // Convert to Firestore data and replace createdAt with serverTimestamp
      final data = word.toFirestore();
      data['createdAt'] = now;

      await _firestore.collection(_collection).doc(wordId).set(data);

      if (kDebugMode) {
        print('Word created: $wordId');
      }

      // Fetch the created document to get the actual serverTimestamp
      final doc = await _firestore.collection(_collection).doc(wordId).get();
      return WordFirestoreModel.fromFirestore(doc);
    } catch (e) {
      if (kDebugMode) {
        print('Error creating word: $e');
      }
      rethrow;
    }
  }

  /// Update an existing word
  Future<WordFirestoreModel> updateWord(WordFirestoreModel word) async {
    try {
      final userId = _currentUserId;
      if (userId == null) {
        throw Exception('User must be authenticated to update a word');
      }

      // Verify ownership
      if (word.userId != userId) {
        throw Exception('User does not have permission to update this word');
      }

      final data = word.toFirestore();
      await _firestore.collection(_collection).doc(word.id).update(data);

      if (kDebugMode) {
        print('Word updated: ${word.id}');
      }

      // Fetch the updated document
      final doc = await _firestore.collection(_collection).doc(word.id).get();
      return WordFirestoreModel.fromFirestore(doc);
    } catch (e) {
      if (kDebugMode) {
        print('Error updating word: $e');
      }
      rethrow;
    }
  }

  /// Delete a word
  Future<void> deleteWord(String wordId) async {
    try {
      final userId = _currentUserId;
      if (userId == null) {
        throw Exception('User must be authenticated to delete a word');
      }

      // Verify ownership before deleting
      final doc = await _firestore.collection(_collection).doc(wordId).get();
      if (!doc.exists) {
        throw Exception('Word not found');
      }

      final word = WordFirestoreModel.fromFirestore(doc);
      if (word.userId != userId) {
        throw Exception('User does not have permission to delete this word');
      }

      await _firestore.collection(_collection).doc(wordId).delete();

      if (kDebugMode) {
        print('Word deleted: $wordId');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting word: $e');
      }
      rethrow;
    }
  }

  /// Get a single word by ID
  Future<WordFirestoreModel?> getWord(String wordId) async {
    try {
      final userId = _currentUserId;
      if (userId == null) {
        throw Exception('User must be authenticated to get a word');
      }

      final doc = await _firestore.collection(_collection).doc(wordId).get();

      if (!doc.exists) {
        return null;
      }

      final word = WordFirestoreModel.fromFirestore(doc);

      // Verify ownership
      if (word.userId != userId && !word.isGlobal) {
        throw Exception('User does not have permission to access this word');
      }

      return word;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting word: $e');
      }
      rethrow;
    }
  }

  /// Get all words for a specific unit
  /// Only returns words where userId matches and isGlobal = false
  Future<List<WordFirestoreModel>> getWordsByUnit(String unitId) async {
    try {
      final userId = _currentUserId;
      if (userId == null) {
        throw Exception('User must be authenticated to get words');
      }

      final querySnapshot = await _firestore
          .collection(_collection)
          .where('unitId', isEqualTo: unitId)
          .where('userId', isEqualTo: userId)
          .where('isGlobal', isEqualTo: false)
          .orderBy('createdAt', descending: true)
          .get();

      final words = querySnapshot.docs
          .map((doc) => WordFirestoreModel.fromFirestore(doc))
          .toList();

      if (kDebugMode) {
        print('Fetched ${words.length} words for unit: $unitId');
      }

      return words;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting words by unit: $e');
      }
      rethrow;
    }
  }

  /// Get all words for the current user
  /// Only returns words where userId matches and isGlobal = false
  Future<List<WordFirestoreModel>> getUserWords() async {
    try {
      final userId = _currentUserId;
      if (userId == null) {
        throw Exception('User must be authenticated to get words');
      }

      final querySnapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .where('isGlobal', isEqualTo: false)
          .orderBy('createdAt', descending: true)
          .get();

      final words = querySnapshot.docs
          .map((doc) => WordFirestoreModel.fromFirestore(doc))
          .toList();

      if (kDebugMode) {
        print('Fetched ${words.length} user words');
      }

      return words;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user words: $e');
      }
      rethrow;
    }
  }

  /// Stream of words for a specific unit (real-time updates)
  Stream<List<WordFirestoreModel>> getWordsByUnitStream(String unitId) {
    final userId = _currentUserId;
    if (userId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection(_collection)
        .where('unitId', isEqualTo: unitId)
        .where('userId', isEqualTo: userId)
        .where('isGlobal', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => WordFirestoreModel.fromFirestore(doc))
            .toList());
  }

  /// Stream of all user words (real-time updates)
  Stream<List<WordFirestoreModel>> getUserWordsStream() {
    final userId = _currentUserId;
    if (userId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .where('isGlobal', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => WordFirestoreModel.fromFirestore(doc))
            .toList());
  }
}

