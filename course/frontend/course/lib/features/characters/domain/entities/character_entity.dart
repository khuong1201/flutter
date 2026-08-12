import 'package:equatable/equatable.dart';

class StrokeDataEntity extends Equatable {
  final int order;
  final String? medianPath;
  final String outlinePath;

  const StrokeDataEntity({
    required this.order,
    required this.medianPath,
    required this.outlinePath,
  });

  @override
  List<Object?> get props => [order, medianPath, outlinePath];
}

class PronunciationEntity extends Equatable {
  final List<String> on;
  final List<String> kun;

  const PronunciationEntity({
    required this.on,
    required this.kun,
  });

  @override
  List<Object?> get props => [on, kun];
}

class RadicalEntity extends Equatable {
  final String radicalText;
  final String meaning;

  const RadicalEntity({
    required this.radicalText,
    required this.meaning,
  });

  @override
  List<Object?> get props => [radicalText, meaning];
}

class VocabularyEntity extends Equatable {
  final String word;
  final String meaning;
  final String pronunciation;

  const VocabularyEntity({
    required this.word,
    required this.meaning,
    required this.pronunciation,
  });

  @override
  List<Object?> get props => [word, meaning, pronunciation];
}

class CharacterEntity extends Equatable {
  final int id;
  final String charText;
  final String language;
  final String meaning;
  final PronunciationEntity? pronunciation;
  final String? audioKey;
  final List<StrokeDataEntity> strokeData;
  final List<RadicalEntity> radicals;
  final List<VocabularyEntity> vocabularies;

  const CharacterEntity({
    required this.id,
    required this.charText,
    required this.language,
    required this.meaning,
    this.pronunciation,
    this.audioKey,
    required this.strokeData,
    required this.radicals,
    required this.vocabularies,
  });

  @override
  List<Object?> get props => [
        id,
        charText,
        language,
        meaning,
        pronunciation,
        audioKey,
        strokeData,
        radicals,
        vocabularies,
      ];
}
