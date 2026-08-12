import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../../../database/prisma.service';
import type { IProgressRepository } from '../../../domain/repositories/progress.repository.interface';
import { UserProgress } from '../../../domain/entities/user-progress.entity';
import { ProgressMapper } from '../../mappers/progress.mapper';

@Injectable()
export class PrismaProgressRepository implements IProgressRepository {
  constructor(private readonly prisma: PrismaService) {}

  async findByUserAndCharacter(
    userId: string,
    characterId: number,
  ): Promise<UserProgress | null> {
    const progress = await this.prisma.userProgress.findFirst({
      where: { userId, characterId },
    });

    if (!progress) return null;

    return ProgressMapper.toDomain(progress);
  }

  async findDueReviews(userId: string, date: Date): Promise<UserProgress[]> {
    const records = await this.prisma.userProgress.findMany({
      where: {
        userId,
        nextReviewAt: { lte: date },
      },
    });
    return records.map(ProgressMapper.toDomain);
  }

  async getStats(userId: string): Promise<{
    totalLearned: number;
    dueReviews: number;
    totalXp: number;
    currentStreak: number;
    longestStreak: number;
  }> {
    const totalLearned = await this.prisma.userProgress.count({
      where: { userId, status: 'learned' },
    });
    const dueReviews = await this.prisma.userProgress.count({
      where: { userId, nextReviewAt: { lte: new Date() } },
    });
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
      select: { xpPoints: true, currentStreak: true, longestStreak: true },
    });

    return {
      totalLearned,
      dueReviews,
      totalXp: user?.xpPoints || 0,
      currentStreak: user?.currentStreak || 0,
      longestStreak: user?.longestStreak || 0,
    };
  }

  async save(progress: UserProgress): Promise<UserProgress> {
    const data = ProgressMapper.toPersistence(progress);

    // Check if exists
    const existing = await this.prisma.userProgress.findUnique({
      where: { id: progress.id },
    });

    let savedProgress;
    if (existing) {
      savedProgress = await this.prisma.userProgress.update({
        where: { id: progress.id },
        data,
      });
    } else {
      savedProgress = await this.prisma.userProgress.create({
        data,
      });
    }

    return ProgressMapper.toDomain(savedProgress);
  }
}
