import 'package:course/features/profile/domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    required super.email,
    required super.fullName,
    required super.targetLanguage,
    required super.targetLevel,
    required super.xpPoints,
    required super.currentStreak,
    required super.longestStreak,
    super.avatarUrl,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      targetLanguage: json['targetLanguage'] as String? ?? '',
      targetLevel: json['targetLevel'] as String? ?? '',
      xpPoints: json['xpPoints'] as int? ?? 0,
      currentStreak: json['currentStreak'] as int? ?? 0,
      longestStreak: json['longestStreak'] as int? ?? 0,
      avatarUrl: json['avatarUrl'] as String?,
    );
  }
}
