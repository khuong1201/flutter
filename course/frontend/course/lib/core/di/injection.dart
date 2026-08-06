import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../local_storage/secure_storage_helper.dart';
import '../network/token_interceptor.dart';
import '../utils/locale_cubit.dart';

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
        baseUrl: 'https://api.zenithlingua.com',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: const {
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.add(TokenInterceptor(sl()));

    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    );

    return dio;
  });

  // Repository
  sl.registerLazySingleton<AuthRepositoryImpl>(
    () => AuthRepositoryImpl(sl()),
  );

  // Global Cubits
  sl.registerLazySingleton<AuthCubit>(
    () => AuthCubit(
      sl(),
      sl(),
    ),
  );

  sl.registerLazySingleton<LocaleCubit>(
    () => LocaleCubit(
      sl(),
    ),
  );
}