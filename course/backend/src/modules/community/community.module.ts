import { Module } from '@nestjs/common';
import { GetContributionsUseCase } from './application/use-cases/get-contributions.use-case';
import { RecordContributionUseCase } from './application/use-cases/record-contribution.use-case';
import { PrismaContributionRepository } from './infrastructure/persistence/prisma/prisma-contribution.repository';
import { ContributionsController } from './presentation/controllers/contributions.controller';

@Module({
  imports: [],
  controllers: [
    ContributionsController
  ],
  providers: [
    GetContributionsUseCase,
    RecordContributionUseCase,
    PrismaContributionRepository
  ],
  exports: [
    GetContributionsUseCase,
    RecordContributionUseCase,
    PrismaContributionRepository
  ]
})
export class CommunityModule {}
