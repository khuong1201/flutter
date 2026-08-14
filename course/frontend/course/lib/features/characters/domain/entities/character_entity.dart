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

class ReadingEntity extends Equatable {
  final String reading;
  final String readingType; // e.g. onyomi, kunyomi, pinyin

  const ReadingEntity({
    required this.reading,
    required this.readingType,
  });

  @override
  List<Object?> get props => [reading, readingType];
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
  final List<ReadingEntity> readings;
  final String? audioKey;
  final List<StrokeDataEntity> strokes;
  final List<RadicalEntity> radicals;
  final List<VocabularyEntity> vocabularies;

  const CharacterEntity({
    required this.id,
    required this.charText,
    required this.language,
    required this.meaning,
    required this.readings,
    this.audioKey,
    required this.strokes,
    required this.radicals,
    required this.vocabularies,
  });

  @override
  List<Object?> get props => [
        id,
        charText,
        language,
        meaning,
        readings,
        audioKey,
        strokes,
        radicals,
        vocabularies,
      ];
}
