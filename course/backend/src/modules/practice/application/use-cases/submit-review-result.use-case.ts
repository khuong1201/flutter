import { Injectable, Inject } from '@nestjs/common';
import type { IReviewLogRepository } from '../../domain/repositories/review-log.repository.interface';
import { REVIEW_LOG_REPOSITORY } from '../../domain/repositories/review-log.repository.interface';
import { ReviewLog } from '../../domain/entities/review-log.entity';
import { UpdateProgressUseCase } from '../../../progress/application/use-cases/update-progress.use-case';
import { randomUUID } from 'crypto';
import { ApiProperty } from '@nestjs/swagger';

export class SubmitReviewDto {
  @ApiProperty({ description: 'Character ID to review', example: 1 })
  characterId: number;

  @ApiProperty({ description: 'Score grade from 0-5', example: 4 })
  grade: number; // 0-5

  @ApiProperty({ description: 'Optional error details', required: false })
  errorDetails?: any;
}

@Injectable()
export class SubmitReviewResultUseCase {
  constructor(
    @Inject(REVIEW_LOG_REPOSITORY)
    private readonly reviewLogRepository: IReviewLogRepository,
    private readonly updateProgressUseCase: UpdateProgressUseCase,
  ) {}

  async execute(userId: string, dto: SubmitReviewDto): Promise<void> {
    // 1. Save review log
    const log = new ReviewLog(
      randomUUID(),
      userId,
      dto.characterId,
      'write',
      dto.grade,
      dto.errorDetails,
    );
    await this.reviewLogRepository.create(log);

    // 2. Update spaced repetition progress via Progress module
    await this.updateProgressUseCase.execute(
      userId,
      dto.characterId,
      dto.grade,
    );
  }
}
