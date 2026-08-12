import { Module } from '@nestjs/common';
import { PrismaModule } from '../../database/prisma.module';
import { ContributionsController } from './presentation/controllers/contributions.controller';
import { GetContributionsUseCase } from './application/use-cases/get-contributions.use-case';
import { RecordContributionUseCase } from './application/use-cases/record-contribution.use-case';
import { PrismaContributionRepository } from './infrastructure/persistence/prisma/prisma-contribution.repository';

@Module({
  imports: [PrismaModule],
  controllers: [ContributionsController],
  providers: [
    GetContributionsUseCase,
    RecordContributionUseCase,
    {
      provide: 'IContributionRepository',
      useClass: PrismaContributionRepository,
    },
  ],
  exports: [RecordContributionUseCase],
})
export class ContributionsModule {}
