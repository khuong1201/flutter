import { UserProgress as PrismaUserProgress } from '@prisma/client';
import { UserProgress } from '../../domain/entities/user-progress.entity';

export class ProgressMapper {
  static toDomain(prismaProgress: PrismaUserProgress): UserProgress {
    return new UserProgress(
      prismaProgress.id,
      prismaProgress.userId,
      prismaProgress.characterId,
      prismaProgress.status,
      Number(prismaProgress.easeFactor),
      prismaProgress.intervalDays,
      prismaProgress.nextReviewAt,
      prismaProgress.totalReviews,
      prismaProgress.consecutiveCorrect,
    );
  }

  static toPersistence(progress: UserProgress): any {
    return {
      id: progress.id,
      userId: progress.userId,
      characterId: progress.characterId,
      status: progress.status,
      easeFactor: progress.easeFactor,
      intervalDays: progress.intervalDays,
      nextReviewAt: progress.nextReviewAt,
      totalReviews: progress.totalReviews,
      consecutiveCorrect: progress.consecutiveCorrect,
    };
  }
}
