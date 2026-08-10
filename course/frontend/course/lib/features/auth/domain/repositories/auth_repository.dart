import 'package:dartz/dartz.dart';
import 'package:course/core/error/failures.dart';
import 'package:course/features/auth/domain/entities/user_token_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserTokenEntity>> login(String email, String password);
  Future<Either<Failure, void>> register(String email, String password, String fullName, String targetLanguage);
}
