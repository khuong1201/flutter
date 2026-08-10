import 'package:course/core/error/failures.dart';
import 'package:course/core/local_storage/secure_storage_helper.dart';
import 'package:course/features/auth/domain/usecases/login_usecase.dart';
import 'package:course/features/auth/domain/usecases/register_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Các trạng thái của Auth
abstract class AuthState {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthUnauthenticated extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String token;
  AuthAuthenticated(this.token);
}
class AuthRegisterSuccess extends AuthState {}
class AuthError extends AuthState {
  final Failure failure;
  AuthError(this.failure);
}

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final SecureStorageHelper secureStorage;
  
  AuthCubit({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.secureStorage,
  }) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    final result = await loginUseCase(email, password);
    
    result.fold(
      (failure) => emit(AuthError(failure)),
      (userToken) async {
        await secureStorage.saveToken(userToken.token);
        emit(AuthAuthenticated(userToken.token));
      }
    );
  }

  Future<void> register(String email, String password, String fullName, String targetLanguage) async {
    emit(AuthLoading());
    final result = await registerUseCase(email, password, fullName, targetLanguage);
    
    result.fold(
      (failure) => emit(AuthError(failure)),
      (_) => emit(AuthRegisterSuccess()),
    );
  }

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());

    try {
      final token = await secureStorage.getToken();
      if (token != null && token.isNotEmpty) {
        emit(AuthAuthenticated(token));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());

    try {
      await secureStorage.deleteToken(); 
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(UnknownFailure()));
    }
  }
}