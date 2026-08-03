import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../../../database/prisma.service';
import type { IReviewLogRepository } from '../../../domain/repositories/review-log.repository.interface';
import { ReviewLog } from '../../../domain/entities/review-log.entity';
import { ReviewLogMapper } from '../../mappers/review-log.mapper';

@Injectable()
export class PrismaReviewLogRepository implements IReviewLogRepository {
  constructor(private readonly prisma: PrismaService) {}

  async create(log: ReviewLog): Promise<ReviewLog> {
    const data = ReviewLogMapper.toPersistence(log);
    const createdLog = await this.prisma.reviewLog.create({
      data,
    });
    return ReviewLogMapper.toDomain(createdLog);
  }
}
