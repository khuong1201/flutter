import { Injectable, Inject } from '@nestjs/common';
import type { IContributionRepository } from '../../domain/repositories/contribution.repository.interface';

@Injectable()
export class RecordContributionUseCase {
  constructor(
    @Inject('IContributionRepository')
    private readonly contributionRepository: IContributionRepository,
  ) {}

  async execute(userId: string): Promise<void> {
    // Get today's date in UTC, strip time
    const today = new Date();
    const dateOnly = new Date(
      Date.UTC(today.getUTCFullYear(), today.getUTCMonth(), today.getUTCDate()),
    );

    await this.contributionRepository.incrementCount(userId, dateOnly);
  }
}
