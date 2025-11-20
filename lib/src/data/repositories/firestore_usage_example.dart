import 'package:dictionarydox/src/core/services/auth_service.dart';
import 'package:dictionarydox/src/data/models/unit_firestore_model.dart';
import 'package:dictionarydox/src/data/models/word_firestore_model.dart';
import 'package:dictionarydox/src/data/repositories/unit_firestore_repository.dart';
import 'package:dictionarydox/src/data/repositories/word_firestore_repository.dart';
import 'package:flutter/foundation.dart';

/// Example usage of Firestore repositories for creating and managing
/// user-specific Units and Words
///
/// This file demonstrates:
/// - Creating a Unit
/// - Creating a Word
/// - Getting user's Units and Words
/// - Updating and deleting Units and Words
/// - Using streams for real-time updates
class FirestoreUsageExample {
  final UnitFirestoreRepository _unitRepository = UnitFirestoreRepository();
  final WordFirestoreRepository _wordRepository = WordFirestoreRepository();
  final AuthService _authService = AuthService();

  /// Example: Create a new Unit
  Future<void> exampleCreateUnit() async {
    try {
      // Ensure user is authenticated
      if (!_authService.isSignedIn) {
        if (kDebugMode) {
          print('User must be signed in to create a unit');
        }
        return;
      }

      // Create a new unit
      // usersId array (with current user) and isGlobal=false are automatically set
      // createdAt is set to serverTimestamp
      final unit = await _unitRepository.createUnit(
        title: 'My First Unit',
        icon: '📚', // Optional icon
      );

      if (kDebugMode) {
        print('Unit created successfully:');
        print('  ID: ${unit.id}');
        print('  Title: ${unit.title}');
        print('  Users ID: ${unit.usersId}'); // Array of user IDs
        print('  Is Global: ${unit.isGlobal}');
        print('  Created At: ${unit.createdAt.toDate()}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error creating unit: $e');
      }
    }
  }

  /// Example: Create a new Word
  Future<void> exampleCreateWord(String unitId) async {
    try {
      // Ensure user is authenticated
      if (!_authService.isSignedIn) {
        if (kDebugMode) {
          print('User must be signed in to create a word');
        }
        return;
      }

      // Create a new word
      // userId and isGlobal=false are automatically set
      // createdAt is set to serverTimestamp
      final word = await _wordRepository.createWord(
        english: 'Hello',
        uzbek: 'Salom',
        unitId: unitId,
        phonetic: '/həˈloʊ/',
        example: 'Hello, how are you?',
        description: 'A greeting',
        // Optional fields
        // audioUrl: 'https://example.com/audio/hello.mp3',
        // imageUrl: 'https://example.com/images/hello.jpg',
      );

      if (kDebugMode) {
        print('Word created successfully:');
        print('  ID: ${word.id}');
        print('  English: ${word.english}');
        print('  Uzbek: ${word.uzbek}');
        print('  Unit ID: ${word.unitId}');
        print('  User ID: ${word.userId}');
        print('  Is Global: ${word.isGlobal}');
        print('  Created At: ${word.createdAt.toDate()}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error creating word: $e');
      }
    }
  }

  /// Example: Get all Units for the current user
  Future<void> exampleGetUserUnits() async {
    try {
      // Get all units for the current user
      // Only returns units where userId matches and isGlobal = false
      final units = await _unitRepository.getUserUnits();

      if (kDebugMode) {
        print('Found ${units.length} units:');
        for (final unit in units) {
          print('  - ${unit.title} (ID: ${unit.id})');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user units: $e');
      }
    }
  }

  /// Example: Get all Words for a specific Unit
  Future<void> exampleGetWordsByUnit(String unitId) async {
    try {
      // Get all words for a specific unit
      // Only returns words where userId matches and isGlobal = false
      final words = await _wordRepository.getWordsByUnit(unitId);

      if (kDebugMode) {
        print('Found ${words.length} words in unit $unitId:');
        for (final word in words) {
          print('  - ${word.english} -> ${word.uzbek}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting words by unit: $e');
      }
    }
  }

  /// Example: Get all Words for the current user
  Future<void> exampleGetUserWords() async {
    try {
      // Get all words for the current user
      // Only returns words where userId matches and isGlobal = false
      final words = await _wordRepository.getUserWords();

      if (kDebugMode) {
        print('Found ${words.length} words:');
        for (final word in words) {
          print('  - ${word.english} -> ${word.uzbek} (Unit: ${word.unitId})');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user words: $e');
      }
    }
  }

  /// Example: Update a Unit
  Future<void> exampleUpdateUnit(String unitId) async {
    try {
      // Get the existing unit
      final unit = await _unitRepository.getUnit(unitId);
      if (unit == null) {
        if (kDebugMode) {
          print('Unit not found');
        }
        return;
      }

      // Update the unit
      final updatedUnit = await _unitRepository.updateUnit(
        unit.copyWith(title: 'Updated Unit Title'),
      );

      if (kDebugMode) {
        print('Unit updated: ${updatedUnit.title}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating unit: $e');
      }
    }
  }

  /// Example: Update a Word
  Future<void> exampleUpdateWord(String wordId) async {
    try {
      // Get the existing word
      final word = await _wordRepository.getWord(wordId);
      if (word == null) {
        if (kDebugMode) {
          print('Word not found');
        }
        return;
      }

      // Update the word
      final updatedWord = await _wordRepository.updateWord(
        word.copyWith(
          english: 'Updated English',
          uzbek: 'Yangilangan Uzbek',
        ),
      );

      if (kDebugMode) {
        print('Word updated: ${updatedWord.english} -> ${updatedWord.uzbek}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating word: $e');
      }
    }
  }

  /// Example: Delete a Unit
  Future<void> exampleDeleteUnit(String unitId) async {
    try {
      await _unitRepository.deleteUnit(unitId);

      if (kDebugMode) {
        print('Unit deleted: $unitId');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting unit: $e');
      }
    }
  }

  /// Example: Delete a Word
  Future<void> exampleDeleteWord(String wordId) async {
    try {
      await _wordRepository.deleteWord(wordId);

      if (kDebugMode) {
        print('Word deleted: $wordId');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting word: $e');
      }
    }
  }

  /// Example: Use streams for real-time updates
  void exampleStreamUnits() {
    // Listen to real-time updates of user units
    _unitRepository.getUserUnitsStream().listen(
      (units) {
        if (kDebugMode) {
          print('Units updated: ${units.length} units');
          for (final unit in units) {
            print('  - ${unit.title}');
          }
        }
      },
      onError: (error) {
        if (kDebugMode) {
          print('Error in units stream: $error');
        }
      },
    );
  }

  /// Example: Use streams for real-time word updates
  void exampleStreamWords(String unitId) {
    // Listen to real-time updates of words in a unit
    _wordRepository.getWordsByUnitStream(unitId).listen(
      (words) {
        if (kDebugMode) {
          print('Words updated in unit $unitId: ${words.length} words');
          for (final word in words) {
            print('  - ${word.english} -> ${word.uzbek}');
          }
        }
      },
      onError: (error) {
        if (kDebugMode) {
          print('Error in words stream: $error');
        }
      },
    );
  }

  /// Example: Complete workflow - Create Unit and add Words
  Future<void> exampleCompleteWorkflow() async {
    try {
      // Step 1: Create a unit
      final unit = await _unitRepository.createUnit(
        title: 'Greetings',
      );

      if (kDebugMode) {
        print('Created unit: ${unit.title}');
      }

      // Step 2: Add words to the unit
      final words = [
        {'english': 'Hello', 'uzbek': 'Salom'},
        {'english': 'Goodbye', 'uzbek': 'Xayr'},
        {'english': 'Thank you', 'uzbek': 'Rahmat'},
      ];

      for (final wordData in words) {
        final word = await _wordRepository.createWord(
          english: wordData['english']!,
          uzbek: wordData['uzbek']!,
          unitId: unit.id,
        );

        if (kDebugMode) {
          print('Added word: ${word.english} -> ${word.uzbek}');
        }
      }

      // Step 3: Get all words in the unit
      final unitWords = await _wordRepository.getWordsByUnit(unit.id);

      if (kDebugMode) {
        print('\nUnit "${unit.title}" contains ${unitWords.length} words:');
        for (final word in unitWords) {
          print('  - ${word.english} -> ${word.uzbek}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in complete workflow: $e');
      }
    }
  }
}

