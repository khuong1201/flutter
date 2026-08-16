import { Module } from '@nestjs/common';
import { GenerateQuizUseCase } from './application/use-cases/generate-quiz.use-case';
import { GetDueReviewsUseCase } from './application/use-cases/get-due-reviews.use-case';
import { GetProgressStatsUseCase } from './application/use-cases/get-progress-stats.use-case';
import { SubmitReviewResultUseCase } from './application/use-cases/submit-review-result.use-case';
import { UpdateProgressUseCase } from './application/use-cases/update-progress.use-case';
import { EvaluateHandwritingUseCase } from './application/use-cases/evaluate-handwriting.use-case';
import { HandwritingEvaluationService } from './application/services/handwriting-evaluation.service';
import { PrismaProgressRepository } from './infrastructure/persistence/prisma/prisma-progress.repository';
import { PrismaReviewLogRepository } from './infrastructure/persistence/prisma/prisma-review-log.repository';
import { PracticeController } from './presentation/controllers/practice.controller';
import { ProgressController } from './presentation/controllers/progress.controller';

import { PROGRESS_REPOSITORY } from './domain/repositories/progress.repository.interface';
import { REVIEW_LOG_REPOSITORY } from './domain/repositories/review-log.repository.interface';

@Module({
  imports: [],
  controllers: [
    PracticeController,
    ProgressController
  ],
  providers: [
    GenerateQuizUseCase,
    GetDueReviewsUseCase,
    GetProgressStatsUseCase,
    SubmitReviewResultUseCase,
    UpdateProgressUseCase,
    EvaluateHandwritingUseCase,
    HandwritingEvaluationService,
    { provide: PROGRESS_REPOSITORY, useClass: PrismaProgressRepository },
    { provide: REVIEW_LOG_REPOSITORY, useClass: PrismaReviewLogRepository }
  ],
  exports: [
    GenerateQuizUseCase,
    GetDueReviewsUseCase,
    GetProgressStatsUseCase,
    SubmitReviewResultUseCase,
    UpdateProgressUseCase,
    PROGRESS_REPOSITORY,
    REVIEW_LOG_REPOSITORY
  ]
})
export class LearningModule {}
