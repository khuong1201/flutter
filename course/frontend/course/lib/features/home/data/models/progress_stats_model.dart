import 'package:course/features/home/domain/entities/progress_stats_entity.dart';

class ProgressStatsModel extends ProgressStatsEntity {
  const ProgressStatsModel({
    required super.totalLearned,
    required super.totalMastered,
    required super.accuracyRate,
    required super.currentStreak,
    required super.xpPoints,
  });

  factory ProgressStatsModel.fromJson(Map<String, dynamic> json) {
    return ProgressStatsModel(
      totalLearned: json['totalLearned'] as int? ?? 0,
      totalMastered: json['totalMastered'] as int? ?? 0,
      accuracyRate: (json['accuracyRate'] as num?)?.toDouble() ?? 0.0,
      currentStreak: json['currentStreak'] as int? ?? 0,
      xpPoints: json['xpPoints'] as int? ?? 0,
    );
  }
}
