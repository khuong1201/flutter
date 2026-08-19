import 'package:course/features/characters/data/models/character_model.dart';
import 'package:course/features/curriculum/domain/entities/lesson_character_entity.dart';

class LessonCharacterModel extends LessonCharacterEntity {
  const LessonCharacterModel({
    required super.id,
    required super.charText,
    required super.language,
    required super.meaning,
    super.audioKey,
    super.pronunciation,
    super.strokeData,
  });

  factory LessonCharacterModel.fromJson(Map<String, dynamic> json) {
    return LessonCharacterModel(
      id: json['id'] as int? ?? 0,
      charText: json['charText'] as String? ?? '',
      language: json['language'] as String? ?? '',
      meaning: json['meaning'] as String? ?? '',
      audioKey: json['audioKey'] as String?,
      pronunciation: json['pronunciation'] as String?,
      strokeData: (json['strokeData'] as List<dynamic>?)
          ?.map((e) => StrokeDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
