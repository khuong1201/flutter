import {
  Character as PrismaCharacter,
  Radical as PrismaRadical,
  Vocabulary as PrismaVocabulary,
} from '@prisma/client';
import { Character, StrokeData } from '../../domain/entities/character.entity';
import { Radical } from '../../domain/entities/radical.entity';
import { Vocabulary } from '../../domain/entities/vocabulary.entity';

export class CharacterMapper {
  static toDomain(
    prismaCharacter: PrismaCharacter & {
      radicals?: { radical: PrismaRadical }[];
      vocabularies?: PrismaVocabulary[];
    },
  ): Character {
    const radicals = prismaCharacter.radicals
      ? prismaCharacter.radicals.map(
          (r) =>
            new Radical(
              r.radical.id,
              r.radical.radicalText,
              r.radical.meaning,
              r.radical.variants,
            ),
        )
      : undefined;

    const vocabularies = prismaCharacter.vocabularies
      ? prismaCharacter.vocabularies.map(
          (v) =>
            new Vocabulary(
              v.id,
              v.characterId,
              v.word,
              v.meaning,
              v.pronunciation,
            ),
        )
      : undefined;

    return new Character(
      prismaCharacter.id,
      prismaCharacter.charText,
      prismaCharacter.language,
      prismaCharacter.meaning,
      prismaCharacter.strokeData as unknown as StrokeData[],
      prismaCharacter.pronunciation,
      prismaCharacter.audioKey,
      radicals,
      vocabularies,
    );
  }
}
