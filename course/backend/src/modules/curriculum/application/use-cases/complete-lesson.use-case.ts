import { Injectable, Inject } from '@nestjs/common';
import type { ILessonRepository } from '../../domain/repositories/lesson.repository.interface';
import { LESSON_REPOSITORY } from '../../domain/repositories/lesson.repository.interface';
import { RecordContributionUseCase } from '../../../community/application/use-cases/record-contribution.use-case';
import { UpdateProgressUseCase } from '../../../learning/application/use-cases/update-progress.use-case';

@Injectable()
export class CompleteLessonUseCase {
  constructor(
    @Inject(LESSON_REPOSITORY)
    private readonly lessonRepository: ILessonRepository,
    private readonly recordContributionUseCase: RecordContributionUseCase,
    private readonly updateProgressUseCase: UpdateProgressUseCase,
  ) {}

  async execute(userId: string, lessonId: number): Promise<void> {
    // Mark the lesson as completed
    await this.lessonRepository.completeUserLesson(userId, lessonId);

    // Record the contribution for the user
    await this.recordContributionUseCase.execute(userId);

    // Initialize SRS for all characters in the lesson
    const characters = await this.lessonRepository.findCharactersByLesson(lessonId);
    for (const char of characters) {
      await this.updateProgressUseCase.execute(userId, char.id, 4);
    }
  }
}
