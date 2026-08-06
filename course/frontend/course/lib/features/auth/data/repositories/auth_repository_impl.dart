import 'package:dio/dio.dart';
import '../models/user_token_model.dart';

class AuthRepositoryImpl {
  final Dio dio;

  AuthRepositoryImpl(this.dio);

  Future<UserTokenModel> login(String email, String password) async {
    try {
      final response = await dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      return UserTokenModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Đăng nhập thất bại: ${e.toString()}');
    }
  }

  Future<void> register(String email, String password, String fullName, String targetLanguage) async {
    try {
      await dio.post('/auth/register', data: {
        'email': email,
        'password': password,
        'fullName': fullName,
        'targetLanguage': targetLanguage,
      });
    } catch (e) {
      throw Exception('Đăng ký thất bại: ${e.toString()}');
    }
  }
}