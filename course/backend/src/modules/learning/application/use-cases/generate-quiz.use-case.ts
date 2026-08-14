import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../../database/prisma.service';

import { ApiProperty } from '@nestjs/swagger';

export class QuizQuestionDto {
  @ApiProperty({ example: 1, description: 'Character ID' })
  characterId: number;

  @ApiProperty({ example: '好', description: 'The character text' })
  charText: string;

  @ApiProperty({ example: 'good', description: 'Correct meaning' })
  meaning: string;

  @ApiProperty({
    type: [String],
    example: ['good', 'bad', 'hello', 'world'],
    description: 'Options for multiple choice',
  })
  options: string[];
}

@Injectable()
export class GenerateQuizUseCase {
  constructor(private readonly prisma: PrismaService) {}

  async execute(
    lessonId?: number,
    limit: number = 10,
  ): Promise<QuizQuestionDto[]> {
    let characters: any[] = [];
    if (lessonId) {
      const records = await this.prisma.lessonVocabulary.findMany({
        where: { lessonId },
        include: {
          vocabulary: {
            include: { characters: { include: { character: true } } }
          }
        },
      });
      for (const r of records) {
        if (r.vocabulary && r.vocabulary.characters) {
          for (const vc of r.vocabulary.characters) {
            if (vc.character && !characters.find((c: any) => c.id === vc.character.id)) {
              characters.push(vc.character);
            }
          }
        }
      }
    } else {
      // Get random characters globally if no lesson specified
      // For random, we can fetch a pool and shuffle, or use raw query.
      // We'll fetch up to 100 and shuffle.
      characters = await this.prisma.character.findMany({ take: 100 });
      characters.sort(() => 0.5 - Math.random());
    }

    characters = characters.slice(0, limit);

    // Fetch some random meanings for options
    const allMeanings = await this.prisma.character.findMany({
      select: { meaning: true },
      take: 100,
    });

    return characters.map((char) => {
      // Select 3 random incorrect meanings
      const incorrectMeanings = allMeanings
        .filter((m) => m.meaning !== char.meaning)
        .sort(() => 0.5 - Math.random())
        .slice(0, 3)
        .map((m) => m.meaning);

      const options = [char.meaning, ...incorrectMeanings].sort(
        () => 0.5 - Math.random(),
      );

      return {
        characterId: char.id,
        charText: char.charText,
        meaning: char.meaning,
        options,
      };
    });
  }
}
