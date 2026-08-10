import 'package:course/core/local_storage/secure_storage_helper.dart';
import 'package:course/core/network/token_interceptor.dart';
import 'package:course/core/utils/locale_cubit.dart';
import 'package:course/core/utils/theme_cubit.dart';
import 'package:course/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:course/features/auth/domain/repositories/auth_repository.dart';
import 'package:course/features/auth/domain/usecases/login_usecase.dart';
import 'package:course/features/auth/domain/usecases/register_usecase.dart';
import 'package:course/features/auth/presentation/cubit/auth_cubit.dart';
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

    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    );

    return dio;
  });

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );

  // UseCases
  sl.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(sl()),
  );
  
  sl.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(sl()),
  );

  // Global Cubits
  sl.registerLazySingleton<AuthCubit>(
    () => AuthCubit(
      loginUseCase: sl(),
      registerUseCase: sl(),
      secureStorage: sl(),
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