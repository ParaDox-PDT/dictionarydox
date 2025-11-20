import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dictionarydox/src/core/error/exceptions.dart';
import 'package:dictionarydox/src/data/models/word_model.dart';
import 'package:flutter/foundation.dart';

abstract class WordRemoteDataSource {
  Future<List<WordModel>> getWordsByUnitId(String unitId);
}

class WordRemoteDataSourceImpl implements WordRemoteDataSource {
  final FirebaseFirestore _firestore;

  WordRemoteDataSourceImpl(this._firestore);

  @override
  Future<List<WordModel>> getWordsByUnitId(String unitId) async {
    try {
      final querySnapshot = await _firestore
          .collection('words')
          .where('unitId', isEqualTo: unitId)
          .get();

      final words = <WordModel>[];

      for (final doc in querySnapshot.docs) {
        try {
          final data = doc.data();
          
          // Merge document ID with data (in case id is missing in data)
          final wordData = {
            ...data,
            'id': data['id'] ?? doc.id,
          };

          final word = WordModel.fromJson(wordData);
          words.add(word);
        } catch (e) {
          if (kDebugMode) {
            print('Error parsing word document ${doc.id}: $e');
          }
          // Continue with other documents even if one fails
        }
      }

      if (kDebugMode) {
        print('Fetched ${words.length} words from Firebase for unit: $unitId');
      }

      return words;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching words from Firebase: $e');
      }
      throw ServerException('Failed to fetch words: $e');
    }
  }
}

