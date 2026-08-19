import 'package:course/features/characters/domain/entities/character_entity.dart';
import 'package:equatable/equatable.dart';

class LessonCharacterEntity extends Equatable {
  final int id;
  final String charText;
  final String language;
  final String meaning;
  final String? audioKey;
  final String? pronunciation;
  final List<StrokeDataEntity>? strokeData;

  const LessonCharacterEntity({
    required this.id,
    required this.charText,
    required this.language,
    required this.meaning,
    this.audioKey,
    this.pronunciation,
    this.strokeData,
  });

  @override
  List<Object?> get props => [
        id,
        charText,
        language,
        meaning,
        audioKey,
        pronunciation,
        strokeData,
      ];
}
