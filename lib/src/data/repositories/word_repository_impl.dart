import 'package:dartz/dartz.dart';
import 'package:dictionarydox/src/core/error/exceptions.dart';
import 'package:dictionarydox/src/core/error/failures.dart';
import 'package:dictionarydox/src/core/services/auth_service.dart';
import 'package:dictionarydox/src/data/datasources/local/word_local_datasource.dart';
import 'package:dictionarydox/src/data/datasources/remote/word_remote_datasource.dart';
import 'package:dictionarydox/src/data/models/word_model.dart';
import 'package:dictionarydox/src/data/repositories/word_firestore_repository.dart';
import 'package:dictionarydox/src/domain/entities/word.dart';
import 'package:dictionarydox/src/domain/repositories/unit_repository.dart';
import 'package:dictionarydox/src/domain/repositories/word_repository.dart';
import 'package:flutter/foundation.dart';

class WordRepositoryImpl implements WordRepository {
  final WordLocalDataSource localDataSource;
  final WordRemoteDataSource remoteDataSource;
  final UnitRepository unitRepository;
  final WordFirestoreRepository firestoreRepository;
  final AuthService authService;

  WordRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.unitRepository,
    required this.firestoreRepository,
    required this.authService,
  });

  @override
  Future<Either<Failure, Word>> addWord(Word word) async {
    try {
      // Check if user is authenticated - if yes, save to Firestore
      if (authService.isSignedIn) {
        try {
          // Create word in Firestore
          final firestoreWord = await firestoreRepository.createWord(
            english: word.english,
            uzbek: word.uzbek,
            unitId: word.unitId,
            phonetic: word.phonetic,
            audioUrl: word.audioUrl,
            example: word.example,
            imageUrl: word.imageUrl,
            description: word.description,
            id: word.id,
          );
          
          // Convert Firestore model back to domain entity
          final createdWord = Word(
            id: firestoreWord.id,
            english: firestoreWord.english,
            uzbek: firestoreWord.uzbek,
            phonetic: firestoreWord.phonetic,
            audioUrl: firestoreWord.audioUrl,
            example: firestoreWord.example,
            imageUrl: firestoreWord.imageUrl,
            description: firestoreWord.description,
            unitId: firestoreWord.unitId,
          );
          
          if (kDebugMode) {
            print('Word created in Firestore: ${firestoreWord.id}');
          }
          
          // Also save to local storage for offline support
          try {
            final wordModel = WordModel.fromEntity(createdWord);
            await localDataSource.addWord(wordModel);
          } catch (e) {
            if (kDebugMode) {
              print('Error saving word to local storage: $e');
            }
            // Continue even if local storage fails
          }
          
          return Right(createdWord);
        } catch (e) {
          if (kDebugMode) {
            print('Error creating word in Firestore: $e');
          }
          // Fallback to local storage if Firestore fails
          final wordModel = WordModel.fromEntity(word);
          final result = await localDataSource.addWord(wordModel);
          return Right(result.toEntity());
        }
      } else {
        // User not authenticated, save to local storage only
        final wordModel = WordModel.fromEntity(word);
        final result = await localDataSource.addWord(wordModel);
        return Right(result.toEntity());
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to create word: $e'));
    }
  }

  @override
  Future<Either<Failure, Word>> updateWord(Word word) async {
    try {
      // Check if user is authenticated - if yes, update in Firestore
      if (authService.isSignedIn) {
        try {
          // Get existing word from Firestore to update
          final existingWord = await firestoreRepository.getWord(word.id);
          if (existingWord != null) {
            final updatedFirestoreWord = await firestoreRepository.updateWord(
              existingWord.copyWith(
                english: word.english,
                uzbek: word.uzbek,
                phonetic: word.phonetic,
                audioUrl: word.audioUrl,
                example: word.example,
                imageUrl: word.imageUrl,
                description: word.description,
              ),
            );
            
            final updatedWord = Word(
              id: updatedFirestoreWord.id,
              english: updatedFirestoreWord.english,
              uzbek: updatedFirestoreWord.uzbek,
              phonetic: updatedFirestoreWord.phonetic,
              audioUrl: updatedFirestoreWord.audioUrl,
              example: updatedFirestoreWord.example,
              imageUrl: updatedFirestoreWord.imageUrl,
              description: updatedFirestoreWord.description,
              unitId: updatedFirestoreWord.unitId,
            );
            
            // Also update in local storage
            try {
              final wordModel = WordModel.fromEntity(updatedWord);
              await localDataSource.updateWord(wordModel);
            } catch (e) {
              if (kDebugMode) {
                print('Error updating word in local storage: $e');
              }
            }
            
            return Right(updatedWord);
          }
        } catch (e) {
          if (kDebugMode) {
            print('Error updating word in Firestore: $e');
          }
          // Fallback to local storage
        }
      }
      
      // Update in local storage
      final wordModel = WordModel.fromEntity(word);
      final result = await localDataSource.updateWord(wordModel);
      return Right(result.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to update word: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteWord(String wordId) async {
    try {
      // Check if user is authenticated - if yes, delete from Firestore
      if (authService.isSignedIn) {
        try {
          await firestoreRepository.deleteWord(wordId);
          if (kDebugMode) {
            print('Word deleted from Firestore: $wordId');
          }
        } catch (e) {
          if (kDebugMode) {
            print('Error deleting word from Firestore: $e');
          }
          // Continue to local storage deletion
        }
      }
      
      // Also delete from local storage
      try {
        await localDataSource.deleteWord(wordId);
      } catch (e) {
        if (kDebugMode) {
          print('Error deleting word from local storage: $e');
        }
      }
      
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to delete word: $e'));
    }
  }

  @override
  Future<Either<Failure, Word>> getWord(String wordId) async {
    try {
      // Try Firestore first if user is authenticated
      if (authService.isSignedIn) {
        try {
          final firestoreWord = await firestoreRepository.getWord(wordId);
          if (firestoreWord != null) {
            final word = Word(
              id: firestoreWord.id,
              english: firestoreWord.english,
              uzbek: firestoreWord.uzbek,
              phonetic: firestoreWord.phonetic,
              audioUrl: firestoreWord.audioUrl,
              example: firestoreWord.example,
              imageUrl: firestoreWord.imageUrl,
              description: firestoreWord.description,
              unitId: firestoreWord.unitId,
            );
            return Right(word);
          }
        } catch (e) {
          if (kDebugMode) {
            print('Error getting word from Firestore: $e');
          }
          // Fallback to local storage
        }
      }
      
      // Get from local storage
      final result = await localDataSource.getWord(wordId);
      return Right(result.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to get word: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Word>>> getWordsByUnit(String unitId) async {
    try {
      final allWords = <Word>[];
      
      // Get words from Firestore if user is authenticated
      if (authService.isSignedIn) {
        try {
          final firestoreWords = await firestoreRepository.getWordsByUnit(unitId);
          
          // Convert Firestore models to domain entities
          for (final firestoreWord in firestoreWords) {
            final word = Word(
              id: firestoreWord.id,
              english: firestoreWord.english,
              uzbek: firestoreWord.uzbek,
              phonetic: firestoreWord.phonetic,
              audioUrl: firestoreWord.audioUrl,
              example: firestoreWord.example,
              imageUrl: firestoreWord.imageUrl,
              description: firestoreWord.description,
              unitId: firestoreWord.unitId,
            );
            allWords.add(word);
          }
          
          if (kDebugMode) {
            print('Fetched ${firestoreWords.length} words from Firestore for unit: $unitId');
          }
        } catch (e) {
          if (kDebugMode) {
            print('Error fetching words from Firestore: $e');
          }
          // Continue to local storage as fallback
        }
      }
      
      // Also get words from local storage (for offline support or non-authenticated users)
      try {
        final localWords = await localDataSource.getWordsByUnit(unitId);
        for (final wordModel in localWords) {
          // Check if word already exists from Firestore
          if (!allWords.any((w) => w.id == wordModel.id)) {
            allWords.add(wordModel.toEntity());
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error fetching words from local storage: $e');
        }
      }
      
      // If no words found and unit might be global, try remote datasource
      if (allWords.isEmpty) {
        try {
          final unitResult = await unitRepository.getUnit(unitId);
          return await unitResult.fold(
            (failure) async {
              // Unit not found, try global units
              try {
                final words = await remoteDataSource.getWordsByUnitId(unitId);
                return Right(words.map((model) => model.toEntity()).toList());
              } on ServerException catch (e) {
                return Left(ServerFailure(e.message));
              }
            },
            (unit) async {
              if (unit.isGlobal) {
                // Fetch from Firebase for global units
                try {
                  final words = await remoteDataSource.getWordsByUnitId(unitId);
                  return Right(words.map((model) => model.toEntity()).toList());
                } on ServerException catch (e) {
                  return Left(ServerFailure(e.message));
                }
              } else {
                return Right(allWords);
              }
            },
          );
        } catch (e) {
          // Continue with allWords
        }
      }
      
      return Right(allWords);
    } catch (e) {
      return Left(ServerFailure('Failed to get words: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Word>>> getAllWords() async {
    try {
      final result = await localDataSource.getAllWords();
      return Right(result.map((model) => model.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
