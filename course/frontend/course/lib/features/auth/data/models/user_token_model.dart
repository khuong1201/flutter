class UserTokenModel {
  final String token;

  UserTokenModel({required this.token});

  factory UserTokenModel.fromJson(Map<String, dynamic> json) {
    return UserTokenModel(
      token: json['token'] ?? '',
    );
  }
}