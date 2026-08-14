import { Injectable, Inject } from '@nestjs/common';
import type { IProgressRepository } from '../../domain/repositories/progress.repository.interface';
import { PROGRESS_REPOSITORY } from '../../domain/repositories/progress.repository.interface';

@Injectable()
export class GetProgressStatsUseCase {
  constructor(
    @Inject(PROGRESS_REPOSITORY)
    private readonly progressRepository: IProgressRepository,
  ) {}

  async execute(userId: string) {
    return this.progressRepository.getStats(userId);
  }
}
