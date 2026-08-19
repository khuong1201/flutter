import 'package:course/features/home/domain/entities/contribution_entity.dart';

class ContributionModel extends ContributionEntity {
  const ContributionModel({
    required super.date,
    required super.count,
  });

  factory ContributionModel.fromJson(Map<String, dynamic> json) {
    return ContributionModel(
      date: DateTime.parse(json['date'] as String),
      count: json['count'] as int? ?? 0,
    );
  }
}
