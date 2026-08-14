import { Injectable, Inject } from '@nestjs/common';
import type { IContributionRepository } from '../../domain/repositories/contribution.repository.interface';
import { Contribution } from '../../domain/entities/contribution.entity';

@Injectable()
export class GetContributionsUseCase {
  constructor(
    @Inject('IContributionRepository')
    private readonly contributionRepository: IContributionRepository,
  ) {}

  async execute(userId: string, year?: number): Promise<any[]> {
    const targetYear = year || new Date().getFullYear();
    const startDate = new Date(Date.UTC(targetYear, 0, 1)); // Jan 1
    const endDate = new Date(Date.UTC(targetYear, 11, 31, 23, 59, 59, 999)); // Dec 31

    const contributions =
      await this.contributionRepository.findByUserIdAndDateRange(
        userId,
        startDate,
        endDate,
      );

    // Format to simple array for frontend
    return contributions.map((c) => ({
      date: c.date.toISOString().split('T')[0],
      count: c.count,
    }));
  }
}
