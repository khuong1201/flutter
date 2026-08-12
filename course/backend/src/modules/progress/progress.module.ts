import { Module } from '@nestjs/common';
import { PrismaModule } from '../../database/prisma.module';
import { UpdateProgressUseCase } from './application/use-cases/update-progress.use-case';
import { Sm2Service } from './domain/services/sm2.service';
import { GetDueReviewsUseCase } from './application/use-cases/get-due-reviews.use-case';
import { GetProgressStatsUseCase } from './application/use-cases/get-progress-stats.use-case';
import { ProgressController } from './presentation/controllers/progress.controller';
import { PrismaProgressRepository } from './infrastructure/persistence/prisma/prisma-progress.repository';
import { PROGRESS_REPOSITORY } from './domain/repositories/progress.repository.interface';

@Module({
  imports: [PrismaModule],
  controllers: [ProgressController],
  providers: [
    Sm2Service,
    UpdateProgressUseCase,
    GetDueReviewsUseCase,
    GetProgressStatsUseCase,
    {
      provide: PROGRESS_REPOSITORY,
      useClass: PrismaProgressRepository,
    },
  ],
  exports: [
    GetDueReviewsUseCase,
    GetProgressStatsUseCase,
    UpdateProgressUseCase,
  ],
})
export class ProgressModule {}
