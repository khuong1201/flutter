import { Injectable, Inject } from '@nestjs/common';
import type { ILessonRepository } from '../../domain/repositories/lesson.repository.interface';
import { LESSON_REPOSITORY } from '../../domain/repositories/lesson.repository.interface';
import { CharacterResponseDto } from '../dto/character-response.dto';

@Injectable()
export class GetLessonCharactersUseCase {
  constructor(
    @Inject(LESSON_REPOSITORY)
    private readonly lessonRepository: ILessonRepository,
  ) {}

  async execute(lessonId: number): Promise<CharacterResponseDto[]> {
    const chars = await this.lessonRepository.findCharactersByLesson(lessonId);
    return chars.map((c) => ({
      id: c.id,
      charText: c.charText,
      language: c.language,
      meaning: c.meaning,
      strokeData: c.strokes || [],
      pronunciation: c.readings?.[0]?.reading || null,
      audioKey: c.audioKey,
    }));
  }
}
