import { Module } from '@nestjs/common';
import { GetContributionsUseCase } from './application/use-cases/get-contributions.use-case';
import { RecordContributionUseCase } from './application/use-cases/record-contribution.use-case';
import { PrismaContributionRepository } from './infrastructure/persistence/prisma/prisma-contribution.repository';
import { ContributionsController } from './presentation/controllers/contributions.controller';

import { IamModule } from '../iam/iam.module';

@Module({
  imports: [IamModule],
  controllers: [
    ContributionsController
  ],
  providers: [
    GetContributionsUseCase,
    RecordContributionUseCase,
    {
      provide: 'IContributionRepository',
      useClass: PrismaContributionRepository
    }
  ],
  exports: [
    GetContributionsUseCase,
    RecordContributionUseCase,
    'IContributionRepository'
  ]
})
export class CommunityModule {}
