import { Injectable, Inject } from '@nestjs/common';
import type { ILessonRepository } from '../../domain/repositories/lesson.repository.interface';
import { LESSON_REPOSITORY } from '../../domain/repositories/lesson.repository.interface';
import { Level } from '../../domain/entities/level.entity';

@Injectable()
export class GetLevelsUseCase {
  constructor(
    @Inject(LESSON_REPOSITORY)
    private readonly lessonRepository: ILessonRepository,
  ) {}

  async execute(): Promise<Level[]> {
    return this.lessonRepository.findLevels();
  }
}
