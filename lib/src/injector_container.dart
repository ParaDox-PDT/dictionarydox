import 'package:dictionarydox/src/core/network/dio_client.dart';
import 'package:dictionarydox/src/core/services/auth_service.dart';
import 'package:dictionarydox/src/core/services/user_service.dart';
import 'package:dictionarydox/src/core/storage/hive_storage_service.dart';
import 'package:dictionarydox/src/core/storage/storage_service.dart';
import 'package:dictionarydox/src/core/storage/web_storage_service.dart';
import 'package:dictionarydox/src/core/utils/platform_utils.dart';
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
import 'package:dictionarydox/src/presentation/blocs/auth/auth_bloc.dart';
import 'package:dictionarydox/src/presentation/blocs/image_search/image_search_bloc.dart';
import 'package:dictionarydox/src/presentation/blocs/quiz/quiz_bloc.dart';
import 'package:dictionarydox/src/presentation/blocs/unit/unit_bloc.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

final sl = GetIt.instance;

bool _isInitialized = false;

Future<void> initDependencies() async {
  if (_isInitialized) return;

  // Initialize storage based on platform
  late StorageService wordStorage;
  late StorageService unitStorage;

  if (PlatformUtils.isWeb) {
    // Web storage using SharedPreferences
    wordStorage = WebStorageService(
      prefix: 'words',
      fromJson: (json) => WordModel.fromJson(json),
      toJson: (value) => (value as WordModel).toJson(),
    );

    unitStorage = WebStorageService(
      prefix: 'units',
      fromJson: (json) => UnitModel.fromJson(json),
      toJson: (value) => (value as UnitModel).toJson(),
    );
  } else {
    // Mobile/Desktop storage using Hive
    // Initialize Hive only once
    if (!Hive.isBoxOpen('words')) {
      await Hive.initFlutter();
      Hive.registerAdapter(WordModelAdapter());
      Hive.registerAdapter(UnitModelAdapter());
    }

    wordStorage = HiveStorageService<WordModel>('words');
    unitStorage = HiveStorageService<UnitModel>('units');
  }

  // Initialize storages
  await wordStorage.init();
  await unitStorage.init();

  // Register storages
  sl.registerLazySingleton<StorageService>(
    () => wordStorage,
    instanceName: 'wordStorage',
  );
  sl.registerLazySingleton<StorageService>(
    () => unitStorage,
    instanceName: 'unitStorage',
  );

  // Core Services
  sl.registerLazySingleton<AuthService>(() => AuthService());
  sl.registerLazySingleton<UserService>(() => UserService());
  sl.registerLazySingleton<DioClient>(() => DioClient());
  sl.registerLazySingleton<Dio>(() => sl<DioClient>().instance);

  // Data sources
  sl.registerLazySingleton<WordLocalDataSource>(
    () => WordLocalDataSourceImpl(
        sl<StorageService>(instanceName: 'wordStorage')),
  );

  sl.registerLazySingleton<UnitLocalDataSource>(
    () => UnitLocalDataSourceImpl(
      unitStorage: sl<StorageService>(instanceName: 'unitStorage'),
      wordStorage: sl<StorageService>(instanceName: 'wordStorage'),
    ),
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
  sl.registerFactory(() => AuthBloc(sl()));

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

  _isInitialized = true;
}
