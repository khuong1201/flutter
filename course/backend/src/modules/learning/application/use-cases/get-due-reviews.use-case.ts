import { Injectable, Inject } from '@nestjs/common';
import type { IProgressRepository } from '../../domain/repositories/progress.repository.interface';
import { PROGRESS_REPOSITORY } from '../../domain/repositories/progress.repository.interface';
import { UserProgress } from '../../domain/entities/user-progress.entity';

@Injectable()
export class GetDueReviewsUseCase {
  constructor(
    @Inject(PROGRESS_REPOSITORY)
    private readonly progressRepository: IProgressRepository,
  ) {}

  async execute(userId: string): Promise<UserProgress[]> {
    const today = new Date();
    return this.progressRepository.findDueReviews(userId, today);
  }
}
