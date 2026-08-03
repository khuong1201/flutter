import { Module } from '@nestjs/common';
import { PrismaModule } from '../../database/prisma.module';
import { ProgressModule } from '../progress/progress.module';
import { PracticeController } from './presentation/controllers/practice.controller';
import { SubmitReviewResultUseCase } from './application/use-cases/submit-review-result.use-case';
import { GenerateQuizUseCase } from './application/use-cases/generate-quiz.use-case';
import { PrismaReviewLogRepository } from './infrastructure/persistence/prisma/prisma-review-log.repository';
import { REVIEW_LOG_REPOSITORY } from './domain/repositories/review-log.repository.interface';

@Module({
  imports: [PrismaModule, ProgressModule],
  controllers: [PracticeController],
  providers: [
    SubmitReviewResultUseCase,
    GenerateQuizUseCase,
    {
      provide: REVIEW_LOG_REPOSITORY,
      useClass: PrismaReviewLogRepository,
    },
  ],
})
export class PracticeModule {}
