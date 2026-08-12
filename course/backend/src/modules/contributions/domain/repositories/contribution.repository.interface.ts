import { Contribution } from '../entities/contribution.entity';

export interface IContributionRepository {
  findByUserIdAndDateRange(
    userId: string,
    startDate: Date,
    endDate: Date,
  ): Promise<Contribution[]>;
  findByUserIdAndDate(userId: string, date: Date): Promise<Contribution | null>;
  incrementCount(userId: string, date: Date): Promise<Contribution>;
}
