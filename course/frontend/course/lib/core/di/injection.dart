import 'package:course/core/local_storage/secure_storage_helper.dart';
import 'package:course/core/network/api_response_interceptor.dart';
import 'package:course/core/network/token_interceptor.dart';
import 'package:course/core/utils/locale_cubit.dart';
import 'package:course/core/utils/theme_cubit.dart';
import 'package:course/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:course/features/auth/domain/repositories/auth_repository.dart';
import 'package:course/features/auth/domain/usecases/login_usecase.dart';
import 'package:course/features/auth/domain/usecases/register_usecase.dart';
import 'package:course/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:course/features/characters/data/datasources/character_remote_datasource.dart';
import 'package:course/features/characters/data/repositories/character_repository_impl.dart';
import 'package:course/features/characters/domain/repositories/character_repository.dart';
import 'package:course/features/characters/domain/usecases/get_character_usecase.dart';
import 'package:course/features/characters/domain/usecases/search_characters_usecase.dart';
import 'package:course/features/characters/presentation/cubit/character_cubit.dart';
import 'package:course/features/curriculum/data/repositories/curriculum_repository_impl.dart';
import 'package:course/features/curriculum/domain/repositories/curriculum_repository.dart';
import 'package:course/features/curriculum/domain/usecases/complete_lesson_usecase.dart';
import 'package:course/features/curriculum/domain/usecases/get_lesson_characters_usecase.dart';
import 'package:course/features/curriculum/domain/usecases/get_lessons_by_level_usecase.dart';
import 'package:course/features/curriculum/domain/usecases/get_levels_usecase.dart';
import 'package:course/features/curriculum/domain/usecases/get_roadmap_usecase.dart';
import 'package:course/features/curriculum/presentation/cubit/curriculum_cubit.dart';
import 'package:course/features/curriculum/presentation/cubit/lesson_characters_cubit.dart';
import 'package:course/features/practice/data/datasources/practice_remote_datasource.dart';
import 'package:course/features/practice/data/repositories/practice_repository_impl.dart';
import 'package:course/features/practice/domain/repositories/practice_repository.dart';
import 'package:course/features/practice/domain/usecases/submit_review_usecase.dart';
import 'package:course/features/practice/domain/usecases/evaluate_handwriting_usecase.dart';
import 'package:course/features/practice/presentation/cubit/practice_cubit.dart';
import 'package:course/features/home/data/repositories/home_repository_impl.dart';
import 'package:course/features/home/domain/repositories/home_repository.dart';
import 'package:course/features/home/domain/usecases/get_contributions_usecase.dart';
import 'package:course/features/home/presentation/cubit/home_cubit.dart';
import 'package:course/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:course/features/profile/domain/repositories/profile_repository.dart';
import 'package:course/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:course/features/profile/domain/usecases/get_progress_stats_usecase.dart';
import 'package:course/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  // Storage
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  sl.registerLazySingleton<SecureStorageHelper>(
    () => SecureStorageHelper(sl()),
  );

  // Dio
  sl.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['API_URL'] ?? 'https://api.zenithlingua.com',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: const {
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.add(TokenInterceptor(
      sl(),
      baseUrl: dotenv.env['API_URL'] ?? 'https://api.zenithlingua.com',
      onUnauthorized: () {
        sl<AuthCubit>().logout();
      },
    ));

    dio.interceptors.add(ApiResponseInterceptor());

    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
      ),
    );

    return dio;
  });

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<CharacterRemoteDataSource>(
    () => CharacterRemoteDataSourceImpl(dio: sl()),
  );

  sl.registerLazySingleton<CharacterRepository>(
    () => CharacterRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<CurriculumRepository>(
    () => CurriculumRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<PracticeRemoteDataSource>(
    () => PracticeRemoteDataSourceImpl(dio: sl()),
  );

  sl.registerLazySingleton<PracticeRepository>(
    () => PracticeRepositoryImpl(remoteDataSource: sl()),
  );

  // UseCases
  sl.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(sl()),
  );
  
  sl.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(sl()),
  );

  sl.registerLazySingleton<GetContributionsUseCase>(
    () => GetContributionsUseCase(sl()),
  );

  sl.registerLazySingleton<GetProfileUseCase>(
    () => GetProfileUseCase(sl()),
  );

  sl.registerLazySingleton<GetProgressStatsUseCase>(
    () => GetProgressStatsUseCase(sl()),
  );

  sl.registerLazySingleton<GetCharacterUseCase>(
    () => GetCharacterUseCase(sl()),
  );

  sl.registerLazySingleton<SearchCharactersUseCase>(
    () => SearchCharactersUseCase(sl()),
  );

  sl.registerLazySingleton<GetLevelsUseCase>(
    () => GetLevelsUseCase(sl()),
  );

  sl.registerLazySingleton<GetLessonsByLevelUseCase>(
    () => GetLessonsByLevelUseCase(sl()),
  );

  sl.registerLazySingleton<GetRoadmapUseCase>(
    () => GetRoadmapUseCase(sl()),
  );

  sl.registerLazySingleton<GetLessonCharactersUseCase>(
    () => GetLessonCharactersUseCase(sl()),
  );

  sl.registerLazySingleton<CompleteLessonUseCase>(
    () => CompleteLessonUseCase(sl()),
  );

  sl.registerLazySingleton<SubmitReviewUseCase>(
    () => SubmitReviewUseCase(sl()),
  );

  sl.registerLazySingleton<EvaluateHandwritingUseCase>(
    () => EvaluateHandwritingUseCase(sl()),
  );

  // Global Cubits
  sl.registerLazySingleton<AuthCubit>(
    () => AuthCubit(
      loginUseCase: sl(),
      registerUseCase: sl(),
      secureStorage: sl(),
    ),
  );

  sl.registerFactory<HomeCubit>(
    () => HomeCubit(
      getContributionsUseCase: sl(),
    ),
  );

  sl.registerFactory<ProfileCubit>(
    () => ProfileCubit(
      getProfileUseCase: sl(),
      getProgressStatsUseCase: sl(),
    ),
  );

  sl.registerFactory<CurriculumCubit>(
    () => CurriculumCubit(
      getLevelsUseCase: sl(),
      getLessonsByLevelUseCase: sl(),
    ),
  );

  sl.registerFactory<LessonCharactersCubit>(
    () => LessonCharactersCubit(
      getLessonCharactersUseCase: sl(),
    ),
  );

  sl.registerFactory<CharacterCubit>(
    () => CharacterCubit(
      getCharacterUseCase: sl(),
    ),
  );

  sl.registerLazySingleton<LocaleCubit>(
    () => LocaleCubit(
      sl(),
    ),
  );

  sl.registerLazySingleton<ThemeCubit>(
    () => ThemeCubit(
      sl(),
    ),
  );

  sl.registerFactory<PracticeCubit>(
    () => PracticeCubit(
      submitReviewUseCase: sl(),
      evaluateHandwritingUseCase: sl(),
    ),
  );
}