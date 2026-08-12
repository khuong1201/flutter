import { Module } from '@nestjs/common';
import { LevelsController } from './presentation/controllers/levels.controller';
import { PrismaModule } from '../../database/prisma.module';
import { GetAllLevelsUseCase } from './application/use-cases/get-all-levels.use-case';
import { GetLevelLessonsUseCase } from './application/use-cases/get-level-lessons.use-case';
import { PrismaLevelRepository } from './infrastructure/persistence/prisma/prisma-level.repository';
import { LEVEL_REPOSITORY } from './domain/repositories/level.repository.interface';

@Module({
  imports: [PrismaModule],
  controllers: [LevelsController],
  providers: [
    GetAllLevelsUseCase,
    GetLevelLessonsUseCase,
    {
      provide: LEVEL_REPOSITORY,
      useClass: PrismaLevelRepository,
    },
  ],
})
export class LevelsModule {}
