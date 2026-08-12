import { Module } from '@nestjs/common';
import { PrismaModule } from '../../database/prisma.module';
import { LessonsController } from './presentation/controllers/lessons.controller';
import { GetLevelsUseCase } from './application/use-cases/get-levels.use-case';
import { GetRoadmapUseCase } from './application/use-cases/get-roadmap.use-case';
import { GetLessonCharactersUseCase } from './application/use-cases/get-lesson-characters.use-case';
import { CompleteLessonUseCase } from './application/use-cases/complete-lesson.use-case';
import { PrismaLessonRepository } from './infrastructure/persistence/prisma/prisma-lesson.repository';
import { LESSON_REPOSITORY } from './domain/repositories/lesson.repository.interface';
import { ContributionsModule } from '../contributions/contributions.module';

@Module({
  imports: [PrismaModule, ContributionsModule],
  controllers: [LessonsController],
  providers: [
    GetLevelsUseCase,
    GetRoadmapUseCase,
    GetLessonCharactersUseCase,
    CompleteLessonUseCase,
    {
      provide: LESSON_REPOSITORY,
      useClass: PrismaLessonRepository,
    },
  ],
  exports: [LESSON_REPOSITORY],
})
export class LessonsModule {}
