import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../../database/prisma.service';

export interface QuizQuestionDto {
  characterId: number;
  charText: string;
  meaning: string;
  options: string[]; // options for multiple choice
}

@Injectable()
export class GenerateQuizUseCase {
  constructor(private readonly prisma: PrismaService) {}

  async execute(lessonId?: number, limit: number = 10): Promise<QuizQuestionDto[]> {
    let characters = [];
    if (lessonId) {
      const lessonChars = await this.prisma.lessonCharacter.findMany({
        where: { lessonId },
        include: { character: true },
      });
      characters = lessonChars.map(lc => lc.character);
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
      take: 100
    });

    return characters.map(char => {
      // Select 3 random incorrect meanings
      const incorrectMeanings = allMeanings
        .filter(m => m.meaning !== char.meaning)
        .sort(() => 0.5 - Math.random())
        .slice(0, 3)
        .map(m => m.meaning);

      const options = [char.meaning, ...incorrectMeanings].sort(() => 0.5 - Math.random());

      return {
        characterId: char.id,
        charText: char.charText,
        meaning: char.meaning,
        options,
      };
    });
  }
}
