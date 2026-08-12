import 'package:course/features/auth/domain/entities/user_token_entity.dart';

class UserTokenModel extends UserTokenEntity {
  UserTokenModel({required super.token});

  factory UserTokenModel.fromJson(Map<String, dynamic> json) {
    return UserTokenModel(
      token: json['accessToken'] ?? '',
    );
  }
}