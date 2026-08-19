import 'package:course/features/curriculum/domain/entities/roadmap_entity.dart';
import 'package:course/features/curriculum/data/models/lesson_model.dart';

class RoadmapModel extends RoadmapEntity {
  const RoadmapModel({
    required super.levelId,
    required super.levelName,
    required super.lessons,
  });

  factory RoadmapModel.fromJson(Map<String, dynamic> json) {
    return RoadmapModel(
      levelId: json['levelId'] as int? ?? 0,
      levelName: json['levelName'] as String? ?? '',
      lessons: (json['lessons'] as List<dynamic>?)
              ?.map((e) => LessonModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
