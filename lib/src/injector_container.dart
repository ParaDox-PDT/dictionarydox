import 'package:dictionarydox/src/core/network/dio_client.dart';
import 'package:dictionarydox/src/data/datasources/local/unit_local_datasource.dart';
import 'package:dictionarydox/src/data/datasources/local/word_local_datasource.dart';
import 'package:dictionarydox/src/data/datasources/remote/dictionary_remote_datasource.dart';
import 'package:dictionarydox/src/data/datasources/remote/pexels_remote_datasource.dart';
import 'package:dictionarydox/src/data/models/unit_model.dart';
import 'package:dictionarydox/src/data/models/word_model.dart';
import 'package:dictionarydox/src/data/repositories/dictionary_repository_impl.dart';
import 'package:dictionarydox/src/data/repositories/image_repository_impl.dart';
import 'package:dictionarydox/src/data/repositories/unit_repository_impl.dart';
import 'package:dictionarydox/src/data/repositories/word_repository_impl.dart';
import 'package:dictionarydox/src/domain/repositories/dictionary_repository.dart';
import 'package:dictionarydox/src/domain/repositories/image_repository.dart';
import 'package:dictionarydox/src/domain/repositories/unit_repository.dart';
import 'package:dictionarydox/src/domain/repositories/word_repository.dart';
import 'package:dictionarydox/src/domain/usecases/add_word.dart';
import 'package:dictionarydox/src/domain/usecases/create_unit.dart';
import 'package:dictionarydox/src/domain/usecases/delete_unit.dart';
import 'package:dictionarydox/src/domain/usecases/delete_word.dart';
import 'package:dictionarydox/src/domain/usecases/get_all_units.dart';
import 'package:dictionarydox/src/domain/usecases/get_unit_words.dart';
import 'package:dictionarydox/src/domain/usecases/search_images.dart';
import 'package:dictionarydox/src/domain/usecases/validate_word.dart';
import 'package:dictionarydox/src/presentation/blocs/add_word/add_word_bloc.dart';
import 'package:dictionarydox/src/presentation/blocs/image_search/image_search_bloc.dart';
import 'package:dictionarydox/src/presentation/blocs/quiz/quiz_bloc.dart';
import 'package:dictionarydox/src/presentation/blocs/unit/unit_bloc.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(WordModelAdapter());
  Hive.registerAdapter(UnitModelAdapter());

  // Open Hive boxes
  final wordBox = await Hive.openBox<WordModel>('words');
  final unitBox = await Hive.openBox<UnitModel>('units');

  // Register boxes
  sl.registerLazySingleton<Box<WordModel>>(() => wordBox);
  sl.registerLazySingleton<Box<UnitModel>>(() => unitBox);

  // Core
  sl.registerLazySingleton<DioClient>(() => DioClient());
  sl.registerLazySingleton<Dio>(() => sl<DioClient>().instance);

  // Data sources
  sl.registerLazySingleton<WordLocalDataSource>(
    () => WordLocalDataSourceImpl(sl<Box<WordModel>>()),
  );

  sl.registerLazySingleton<UnitLocalDataSource>(
    () => UnitLocalDataSourceImpl(sl<Box<UnitModel>>()),
  );

  sl.registerLazySingleton<DictionaryRemoteDataSource>(
    () => DictionaryRemoteDataSourceImpl(sl<Dio>()),
  );

  sl.registerLazySingleton<PexelsRemoteDataSource>(
    () => PexelsRemoteDataSourceImpl(sl<Dio>()),
  );

  // Repositories
  sl.registerLazySingleton<WordRepository>(
    () => WordRepositoryImpl(localDataSource: sl()),
  );

  sl.registerLazySingleton<UnitRepository>(
    () => UnitRepositoryImpl(
      localDataSource: sl(),
      wordLocalDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<DictionaryRepository>(
    () => DictionaryRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<ImageRepository>(
    () => ImageRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => AddWord(sl()));
  sl.registerLazySingleton(() => CreateUnit(sl()));
  sl.registerLazySingleton(() => DeleteUnit(sl()));
  sl.registerLazySingleton(() => DeleteWord(sl()));
  sl.registerLazySingleton(() => GetAllUnits(sl()));
  sl.registerLazySingleton(() => GetUnitWords(sl()));
  sl.registerLazySingleton(() => SearchImages(sl()));
  sl.registerLazySingleton(() => ValidateWord(sl()));

  // BLoCs (factories for new instances)
  sl.registerFactory(() => AddWordBloc(
        validateWord: sl(),
        searchImages: sl(),
        addWord: sl(),
      ));

  sl.registerFactory(() => ImageSearchBloc(searchImages: sl()));

  sl.registerFactory(() => UnitBloc(
        getAllUnits: sl(),
        createUnit: sl(),
        deleteUnit: sl(),
        getUnitWords: sl(),
        deleteWord: sl(),
      ));

  sl.registerFactory(() => QuizBloc(getUnitWords: sl()));
}
