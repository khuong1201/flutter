import 'package:course/features/auth/domain/entities/user_token_entity.dart';

class UserTokenModel extends UserTokenEntity {
  UserTokenModel({
    required super.token,
    required super.refreshToken,
  });

  factory UserTokenModel.fromJson(Map<String, dynamic> json) {
    return UserTokenModel(
      token: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
    );
  }
}