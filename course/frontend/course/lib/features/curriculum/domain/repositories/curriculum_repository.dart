import 'package:dartz/dartz.dart';
import 'package:course/core/error/failures.dart';
import 'package:course/features/curriculum/domain/entities/level_entity.dart';
import 'package:course/features/curriculum/domain/entities/lesson_entity.dart';
import 'package:course/features/curriculum/domain/entities/roadmap_entity.dart';
import 'package:course/features/curriculum/domain/entities/lesson_character_entity.dart';

abstract class CurriculumRepository {
  Future<Either<Failure, List<LevelEntity>>> getLevels();
  Future<Either<Failure, List<LessonEntity>>> getLessonsByLevel(int levelId);
  Future<Either<Failure, List<RoadmapEntity>>> getRoadmap([String? lang]);
  Future<Either<Failure, List<LessonCharacterEntity>>> getLessonCharacters(int lessonId);
  Future<Either<Failure, void>> completeLesson(int lessonId);
}
