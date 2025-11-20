import 'package:dartz/dartz.dart' hide Unit;
import 'package:dictionarydox/src/core/error/exceptions.dart';
import 'package:dictionarydox/src/core/error/failures.dart';
import 'package:dictionarydox/src/core/services/auth_service.dart';
import 'package:dictionarydox/src/data/datasources/local/unit_local_datasource.dart';
import 'package:dictionarydox/src/data/datasources/local/word_local_datasource.dart';
import 'package:dictionarydox/src/data/datasources/remote/unit_remote_datasource.dart';
import 'package:dictionarydox/src/data/models/unit_model.dart';
import 'package:dictionarydox/src/data/repositories/unit_firestore_repository.dart';
import 'package:dictionarydox/src/domain/entities/unit.dart';
import 'package:dictionarydox/src/domain/repositories/unit_repository.dart';
import 'package:flutter/foundation.dart';

class UnitRepositoryImpl implements UnitRepository {
  final UnitLocalDataSource localDataSource;
  final WordLocalDataSource wordLocalDataSource;
  final UnitRemoteDataSource remoteDataSource;
  final UnitFirestoreRepository firestoreRepository;
  final AuthService authService;

  UnitRepositoryImpl({
    required this.localDataSource,
    required this.wordLocalDataSource,
    required this.remoteDataSource,
    required this.firestoreRepository,
    required this.authService,
  });

  @override
  Future<Either<Failure, Unit>> createUnit(Unit unit) async {
    try {
      // Check if user is authenticated - if yes, save to Firestore
      if (authService.isSignedIn) {
        try {
          // Convert domain entity (name) to Firestore model (title)
          final firestoreUnit = await firestoreRepository.createUnit(
            title: unit.name, // Convert name to title
            icon: unit.icon, // Pass icon to Firestore
            id: unit.id,
          );
          
          // Convert Firestore model back to domain entity
          final createdUnit = Unit(
            id: firestoreUnit.id,
            name: firestoreUnit.title, // Convert title back to name
            icon: firestoreUnit.icon, // Get icon from Firestore
            isGlobal: firestoreUnit.isGlobal,
          );
          
          if (kDebugMode) {
            print('Unit created in Firestore: ${firestoreUnit.id}');
          }
          
          return Right(createdUnit);
        } catch (e) {
          if (kDebugMode) {
            print('Error creating unit in Firestore: $e');
          }
          // Fallback to local storage if Firestore fails
          final unitModel = UnitModel.fromEntity(unit);
          final result = await localDataSource.createUnit(unitModel);
          return Right(result.toEntity());
        }
      } else {
        // User not authenticated, save to local storage only
        final unitModel = UnitModel.fromEntity(unit);
        final result = await localDataSource.createUnit(unitModel);
        return Right(result.toEntity());
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to create unit: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateUnit(Unit unit) async {
    try {
      // Check if user is authenticated - if yes, update in Firestore
      if (authService.isSignedIn) {
        try {
          // Get existing unit from Firestore to update
          final existingUnit = await firestoreRepository.getUnit(unit.id);
          if (existingUnit != null) {
            final updatedFirestoreUnit = await firestoreRepository.updateUnit(
              existingUnit.copyWith(
                title: unit.name, // Convert name to title
                icon: unit.icon, // Update icon
              ),
            );
            
            final updatedUnit = Unit(
              id: updatedFirestoreUnit.id,
              name: updatedFirestoreUnit.title, // Convert title back to name
              icon: updatedFirestoreUnit.icon, // Get icon from Firestore
              isGlobal: updatedFirestoreUnit.isGlobal,
            );
            
            return Right(updatedUnit);
          }
        } catch (e) {
          if (kDebugMode) {
            print('Error updating unit in Firestore: $e');
          }
          // Fallback to local storage
        }
      }
      
      // Update in local storage
      final unitModel = UnitModel.fromEntity(unit);
      final result = await localDataSource.updateUnit(unitModel);
      return Right(result.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to update unit: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUnit(String unitId) async {
    try {
      // Check if user is authenticated - if yes, delete from Firestore
      if (authService.isSignedIn) {
        try {
          await firestoreRepository.deleteUnit(unitId);
          if (kDebugMode) {
            print('Unit deleted from Firestore: $unitId');
          }
        } catch (e) {
          if (kDebugMode) {
            print('Error deleting unit from Firestore: $e');
          }
          // Continue to local storage deletion
        }
      }
      
      // Also delete from local storage
      try {
        await localDataSource.deleteUnit(unitId);
      } catch (e) {
        if (kDebugMode) {
          print('Error deleting unit from local storage: $e');
        }
      }
      
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to delete unit: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> getUnit(String unitId) async {
    try {
      // Try Firestore first if user is authenticated
      if (authService.isSignedIn) {
        try {
          final firestoreUnit = await firestoreRepository.getUnit(unitId);
          if (firestoreUnit != null) {
            final unit = Unit(
              id: firestoreUnit.id,
              name: firestoreUnit.title, // Convert title to name
              icon: firestoreUnit.icon, // Get icon from Firestore
              isGlobal: firestoreUnit.isGlobal,
            );
            return Right(unit);
          }
        } catch (e) {
          if (kDebugMode) {
            print('Error getting unit from Firestore: $e');
          }
          // Fallback to local storage
        }
      }
      
      // Get from local storage
      final result = await localDataSource.getUnit(unitId);
      return Right(result.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to get unit: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Unit>>> getAllUnits() async {
    try {
      final allUnits = <Unit>[];
      
      // Get units from Firestore if user is authenticated
      if (authService.isSignedIn) {
        try {
          final firestoreUnits = await firestoreRepository.getUserUnits();
          
          // Convert Firestore models to domain entities
          for (final firestoreUnit in firestoreUnits) {
            // Try to get word count from local storage first (faster)
            // If not found, we'll set to 0 (can be calculated from Firestore if needed)
            int wordCount = 0;
            try {
              final words = await wordLocalDataSource.getWordsByUnit(firestoreUnit.id);
              wordCount = words.length;
            } catch (e) {
              // Word count will be 0 if not found in local storage
              // In future, we can query Firestore for word count if needed
            }
            
            final unit = Unit(
              id: firestoreUnit.id,
              name: firestoreUnit.title, // Convert title to name
              icon: firestoreUnit.icon, // Get icon from Firestore
              isGlobal: firestoreUnit.isGlobal,
              wordCount: wordCount,
            );
            allUnits.add(unit);
          }
          
          if (kDebugMode) {
            print('Fetched ${firestoreUnits.length} units from Firestore');
          }
        } catch (e) {
          if (kDebugMode) {
            print('Error fetching units from Firestore: $e');
          }
          // Continue to local storage as fallback
        }
      }
      
      // Also get units from local storage (for offline support or non-authenticated users)
      try {
        final localUnits = await localDataSource.getAllUnits();
        for (final unitModel in localUnits) {
          // Check if unit already exists from Firestore
          if (!allUnits.any((u) => u.id == unitModel.id)) {
            final words = await wordLocalDataSource.getWordsByUnit(unitModel.id);
            final unit = unitModel.toEntity().copyWith(wordCount: words.length);
            allUnits.add(unit);
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error fetching units from local storage: $e');
        }
      }

      return Right(allUnits);
    } catch (e) {
      return Left(CacheFailure('Failed to get units: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Unit>>> getGlobalUnits() async {
    try {
      final units = await remoteDataSource.getGlobalUnits();
      
      // Convert to domain entities
      final unitEntities = units.map((model) => model.toEntity()).toList();
      
      return Right(unitEntities);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to fetch global units: $e'));
    }
  }
}
