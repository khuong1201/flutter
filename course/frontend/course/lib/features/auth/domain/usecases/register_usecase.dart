import 'package:dartz/dartz.dart';
import 'package:course/core/error/failures.dart';
import 'package:course/features/auth/domain/repositories/auth_repository.dart';
import 'package:course/features/auth/domain/entities/user_token_entity.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, UserTokenEntity>> call(String email, String password, String fullName) {
    return repository.register(email, password, fullName);
  }
}
