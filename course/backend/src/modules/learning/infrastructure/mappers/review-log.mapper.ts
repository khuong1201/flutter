import { ReviewLog as PrismaReviewLog } from '@prisma/client';
import { ReviewLog } from '../../domain/entities/review-log.entity';

export class ReviewLogMapper {
  static toDomain(prismaLog: PrismaReviewLog): ReviewLog {
    return new ReviewLog(
      prismaLog.id,
      prismaLog.userId,
      prismaLog.characterId,
      prismaLog.actionType,
      prismaLog.grade,
      prismaLog.errorDetails,
      prismaLog.createdAt,
    );
  }

  static toPersistence(log: ReviewLog): any {
    return {
      id: log.id,
      userId: log.userId,
      characterId: log.characterId,
      actionType: log.actionType,
      grade: log.grade,
      errorDetails: log.errorDetails,
    };
  }
}
