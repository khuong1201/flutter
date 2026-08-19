import 'package:course/core/error/failures.dart';
import 'package:course/features/curriculum/data/models/level_model.dart';
import 'package:course/features/curriculum/data/models/lesson_model.dart';
import 'package:course/features/curriculum/data/models/roadmap_model.dart';
import 'package:course/features/curriculum/data/models/lesson_character_model.dart';
import 'package:course/features/curriculum/domain/entities/level_entity.dart';
import 'package:course/features/curriculum/domain/entities/lesson_entity.dart';
import 'package:course/features/curriculum/domain/entities/roadmap_entity.dart';
import 'package:course/features/curriculum/domain/entities/lesson_character_entity.dart';
import 'package:course/features/curriculum/domain/repositories/curriculum_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

List<LevelModel> _parseLevelList(dynamic data) {
  return (data as List).map((e) => LevelModel.fromJson(e as Map<String, dynamic>)).toList();
}

List<LessonModel> _parseLessonList(dynamic data) {
  return (data as List).map((e) => LessonModel.fromJson(e as Map<String, dynamic>)).toList();
}

List<RoadmapModel> _parseRoadmapList(dynamic data) {
  return (data as List).map((e) => RoadmapModel.fromJson(e as Map<String, dynamic>)).toList();
}

List<LessonCharacterModel> _parseLessonCharacterList(dynamic data) {
  return (data as List).map((e) => LessonCharacterModel.fromJson(e as Map<String, dynamic>)).toList();
}

class CurriculumRepositoryImpl implements CurriculumRepository {
  final Dio dio;

  // --- Cache Variables ---
  List<LevelEntity>? _cachedLevels;
  final Map<int, List<LessonEntity>> _cachedLessons = {};
  List<RoadmapEntity>? _cachedRoadmap;
  String? _cachedRoadmapLang;
  final Map<int, List<LessonCharacterEntity>> _cachedLessonCharacters = {};
  // -----------------------

  CurriculumRepositoryImpl(this.dio);

  @override
  Future<Either<Failure, List<LevelEntity>>> getLevels() async {
    if (_cachedLevels != null) return Right(_cachedLevels!);
    try {
      final response = await dio.get('/levels');
      final levels = await compute(_parseLevelList, response.data);
      _cachedLevels = levels;
      return Right(levels);
    } catch (e) {
      if (e is DioException) return Left(ServerFailure());
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<LessonEntity>>> getLessonsByLevel(int levelId) async {
    if (_cachedLessons.containsKey(levelId)) return Right(_cachedLessons[levelId]!);
    try {
      final response = await dio.get('/levels/$levelId/lessons');
      final lessons = await compute(_parseLessonList, response.data);
      _cachedLessons[levelId] = lessons;
      return Right(lessons);
    } catch (e) {
      if (e is DioException) return Left(ServerFailure());
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<RoadmapEntity>>> getRoadmap([String? lang]) async {
    if (_cachedRoadmap != null && _cachedRoadmapLang == lang) return Right(_cachedRoadmap!);
    try {
      final response = await dio.get('/lessons/roadmap', queryParameters: lang != null ? {'lang': lang} : null);
      final roadmap = await compute(_parseRoadmapList, response.data);
      _cachedRoadmap = roadmap;
      _cachedRoadmapLang = lang;
      return Right(roadmap);
    } catch (e) {
      if (e is DioException) return Left(ServerFailure());
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<LessonCharacterEntity>>> getLessonCharacters(int lessonId) async {
    if (_cachedLessonCharacters.containsKey(lessonId)) return Right(_cachedLessonCharacters[lessonId]!);
    try {
      final response = await dio.get('/lessons/$lessonId/characters');
      final characters = await compute(_parseLessonCharacterList, response.data);
      _cachedLessonCharacters[lessonId] = characters;
      return Right(characters);
    } catch (e) {
      if (e is DioException) return Left(ServerFailure());
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> completeLesson(int lessonId) async {
    try {
      await dio.post('/lessons/$lessonId/complete');
      
      // Xoá cache để ép tải lại tiến độ mới
      _cachedLevels = null;
      _cachedLessons.clear();
      _cachedRoadmap = null;
      
      return const Right(null);
    } catch (e) {
      if (e is DioException) return Left(ServerFailure());
      return Left(UnknownFailure());
    }
  }
}
