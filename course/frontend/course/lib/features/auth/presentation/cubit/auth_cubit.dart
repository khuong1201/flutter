import 'package:course/core/local_storage/secure_storage_helper.dart';
import 'package:course/features/auth/data/repositories/auth_repository_impl.dart';
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
  final String message;
  AuthError(this.message);
}

class AuthCubit extends Cubit<AuthState> {
  final AuthRepositoryImpl authRepository;
  final SecureStorageHelper secureStorage;
  
  AuthCubit(this.authRepository, this.secureStorage) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final userToken = await authRepository.login(email, password);
      await secureStorage.saveToken(userToken.token);
      emit(AuthAuthenticated(userToken.token));
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> register(String email, String password, String fullName, String targetLanguage) async {
    emit(AuthLoading());
    try {
      await authRepository.register(email, password, fullName, targetLanguage);
      emit(AuthRegisterSuccess());
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
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
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}