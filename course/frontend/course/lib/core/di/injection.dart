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
import 'package:course/features/characters/presentation/cubit/character_cubit.dart';
import 'package:course/features/home/data/repositories/home_repository_impl.dart';
import 'package:course/features/home/domain/repositories/home_repository.dart';
import 'package:course/features/home/domain/usecases/get_contributions_usecase.dart';
import 'package:course/features/home/presentation/cubit/home_cubit.dart';
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

  sl.registerLazySingleton<CharacterRemoteDataSource>(
    () => CharacterRemoteDataSourceImpl(dio: sl()),
  );

  sl.registerLazySingleton<CharacterRepository>(
    () => CharacterRepositoryImpl(remoteDataSource: sl()),
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

  sl.registerLazySingleton<GetCharacterUseCase>(
    () => GetCharacterUseCase(sl()),
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
}