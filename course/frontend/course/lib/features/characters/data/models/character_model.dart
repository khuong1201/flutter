import 'package:course/features/characters/domain/entities/character_entity.dart';

class StrokeDataModel extends StrokeDataEntity {
  const StrokeDataModel({
    required super.order,
    required super.medianPath,
    required super.outlinePath,
  });

  factory StrokeDataModel.fromJson(Map<String, dynamic> json) {
    return StrokeDataModel(
      order: json['order'] as int,
      medianPath: json['median_path'] as String?,
      outlinePath: json['outline_path'] as String,
    );
  }
}

class PronunciationModel extends PronunciationEntity {
  const PronunciationModel({
    required super.on,
    required super.kun,
  });

  factory PronunciationModel.fromJson(Map<String, dynamic> json) {
    return PronunciationModel(
      on: (json['on'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      kun: (json['kun'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    );
  }
}

class RadicalModel extends RadicalEntity {
  const RadicalModel({
    required super.radicalText,
    required super.meaning,
  });

  factory RadicalModel.fromJson(Map<String, dynamic> json) {
    return RadicalModel(
      radicalText: json['radicalText'] as String,
      meaning: json['meaning'] as String,
    );
  }
}

class VocabularyModel extends VocabularyEntity {
  const VocabularyModel({
    required super.word,
    required super.meaning,
    required super.pronunciation,
  });

  factory VocabularyModel.fromJson(Map<String, dynamic> json) {
    return VocabularyModel(
      word: json['word'] as String,
      meaning: json['meaning'] as String,
      pronunciation: json['pronunciation'] as String,
    );
  }
}

class CharacterModel extends CharacterEntity {
  const CharacterModel({
    required super.id,
    required super.charText,
    required super.language,
    required super.meaning,
    super.pronunciation,
    super.audioKey,
    required super.strokeData,
    required super.radicals,
    required super.vocabularies,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'] as int,
      charText: json['charText'] as String,
      language: json['language'] as String,
      meaning: json['meaning'] as String? ?? '',
      pronunciation: json['pronunciation'] != null
          ? PronunciationModel.fromJson(json['pronunciation'] as Map<String, dynamic>)
          : null,
      audioKey: json['audioKey'] as String?,
      strokeData: (json['strokeData'] as List<dynamic>?)
              ?.map((e) => StrokeDataModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      radicals: (json['radicals'] as List<dynamic>?)
              ?.map((e) => RadicalModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      vocabularies: (json['vocabularies'] as List<dynamic>?)
              ?.map((e) => VocabularyModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
