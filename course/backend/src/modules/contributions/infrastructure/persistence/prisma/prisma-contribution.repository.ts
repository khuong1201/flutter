import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../../../database/prisma.service';
import type { IContributionRepository } from '../../../domain/repositories/contribution.repository.interface';
import { Contribution } from '../../../domain/entities/contribution.entity';
import { ContributionMapper } from '../../mappers/contribution.mapper';

@Injectable()
export class PrismaContributionRepository implements IContributionRepository {
  constructor(private readonly prisma: PrismaService) {}

  async findByUserIdAndDateRange(
    userId: string,
    startDate: Date,
    endDate: Date,
  ): Promise<Contribution[]> {
    const records = await this.prisma.userContribution.findMany({
      where: {
        userId,
        date: {
          gte: startDate,
          lte: endDate,
        },
      },
      orderBy: { date: 'asc' },
    });
    return records.map(ContributionMapper.toDomain);
  }

  async findByUserIdAndDate(
    userId: string,
    date: Date,
  ): Promise<Contribution | null> {
    const record = await this.prisma.userContribution.findUnique({
      where: {
        userId_date: {
          userId,
          date,
        },
      },
    });
    if (!record) return null;
    return ContributionMapper.toDomain(record);
  }

  async incrementCount(userId: string, date: Date): Promise<Contribution> {
    // Upsert logic: if exists, increment count. if not, create with count 1
    const record = await this.prisma.userContribution.upsert({
      where: {
        userId_date: {
          userId,
          date,
        },
      },
      update: {
        count: {
          increment: 1,
        },
      },
      create: {
        userId,
        date,
        count: 1,
      },
    });
    return ContributionMapper.toDomain(record);
  }
}
