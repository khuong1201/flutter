import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final String targetLanguage;
  final String targetLevel;
  final int xpPoints;
  final int currentStreak;
  final int longestStreak;
  final String? avatarUrl;

  const ProfileEntity({
    required this.id,
    required this.email,
    required this.fullName,
    required this.targetLanguage,
    required this.targetLevel,
    required this.xpPoints,
    required this.currentStreak,
    required this.longestStreak,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        fullName,
        targetLanguage,
        targetLevel,
        xpPoints,
        currentStreak,
        longestStreak,
        avatarUrl,
      ];
}
