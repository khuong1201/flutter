import 'package:dartz/dartz.dart';
import 'package:course/core/error/failures.dart';
import 'package:course/features/auth/domain/entities/user_token_entity.dart';
import 'package:course/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, UserTokenEntity>> call(String email, String password) {
    return repository.login(email, password);
  }
}
