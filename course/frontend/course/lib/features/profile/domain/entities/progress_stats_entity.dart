import 'package:equatable/equatable.dart';

class ProgressStatsEntity extends Equatable {
  final int totalLearned;
  final int totalMastered;
  final double accuracyRate;
  final int currentStreak;
  final int xpPoints;

  const ProgressStatsEntity({
    required this.totalLearned,
    required this.totalMastered,
    required this.accuracyRate,
    required this.currentStreak,
    required this.xpPoints,
  });

  @override
  List<Object?> get props => [
        totalLearned,
        totalMastered,
        accuracyRate,
        currentStreak,
        xpPoints,
      ];
}
