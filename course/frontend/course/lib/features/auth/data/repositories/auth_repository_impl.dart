import 'package:course/core/error/failures.dart';
import 'package:course/features/auth/data/models/user_token_model.dart';
import 'package:course/features/auth/domain/entities/user_token_entity.dart';
import 'package:course/features/auth/domain/repositories/auth_repository.dart';
import 'package:course/core/network/dio_exception_extension.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio dio;

  AuthRepositoryImpl(this.dio);

  @override
  Future<Either<Failure, UserTokenEntity>> login(String email, String password) async {
    try {
      final response = await dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      return Right(UserTokenModel.fromJson(response.data));
    } catch (e) {
      if (e is DioException) {
        final code = e.apiCode;
        if (code == 'INVALID_CREDENTIALS') return Left(InvalidCredentialsFailure());
        if (code == 'BAD_REQUEST' || code == 'VALIDATION_ERROR') return Left(BadRequestFailure());
        
        return Left(ServerFailure());
      }
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> register(String email, String password, String fullName, String targetLanguage) async {
    try {
      await dio.post('/auth/register', data: {
        'email': email,
        'password': password,
        'fullName': fullName,
        'targetLanguage': targetLanguage,
      });
      return const Right(null);
    } catch (e) {
      if (e is DioException) {
        final code = e.apiCode;
        if (code == 'USER_EXISTS') return Left(UserExistsFailure());
        if (code == 'BAD_REQUEST' || code == 'VALIDATION_ERROR') return Left(BadRequestFailure());
        
        return Left(ServerFailure());
      }
      return Left(UnknownFailure());
    }
  }
}