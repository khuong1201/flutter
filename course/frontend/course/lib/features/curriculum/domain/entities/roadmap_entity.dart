import 'package:equatable/equatable.dart';
import 'package:course/features/curriculum/domain/entities/lesson_entity.dart';

class RoadmapEntity extends Equatable {
  final int levelId;
  final String levelName;
  final List<LessonEntity> lessons;

  const RoadmapEntity({
    required this.levelId,
    required this.levelName,
    required this.lessons,
  });

  @override
  List<Object?> get props => [levelId, levelName, lessons];
}
