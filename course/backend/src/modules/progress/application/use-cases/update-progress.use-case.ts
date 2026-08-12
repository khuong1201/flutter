import { Injectable, Inject } from '@nestjs/common';
import type { IProgressRepository } from '../../domain/repositories/progress.repository.interface';
import { PROGRESS_REPOSITORY } from '../../domain/repositories/progress.repository.interface';
import { UserProgress } from '../../domain/entities/user-progress.entity';
import { Sm2Service } from '../../domain/services/sm2.service';
import { randomUUID } from 'crypto';

@Injectable()
export class UpdateProgressUseCase {
  constructor(
    @Inject(PROGRESS_REPOSITORY)
    private readonly progressRepository: IProgressRepository,
  ) {}

  async execute(
    userId: string,
    characterId: number,
    grade: number,
  ): Promise<UserProgress> {
    let progress = await this.progressRepository.findByUserAndCharacter(
      userId,
      characterId,
    );

    if (!progress) {
      // Create new progress record
      progress = new UserProgress(
        randomUUID(),
        userId,
        characterId,
        'learning',
        2.5, // default ease factor
        0, // interval days
        new Date(), // next review at
        0, // total reviews
        0, // consecutive correct
      );
    }

    // Apply SM-2 algorithm
    Sm2Service.calculateNextReview(progress, grade);

    // Save
    return this.progressRepository.save(progress);
  }
}
