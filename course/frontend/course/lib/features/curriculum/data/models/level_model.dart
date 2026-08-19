import 'package:course/features/curriculum/domain/entities/level_entity.dart';

class LevelModel extends LevelEntity {
  const LevelModel({
    required super.id,
    required super.system,
    required super.code,
    required super.name,
    required super.language,
  });

  factory LevelModel.fromJson(Map<String, dynamic> json) {
    return LevelModel(
      id: json['id'] as int? ?? 0,
      system: json['system'] as String? ?? '',
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      language: json['language'] as String? ?? '',
    );
  }
}
