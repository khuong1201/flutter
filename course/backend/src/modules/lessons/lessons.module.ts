import { Module } from '@nestjs/common';
import { PrismaModule } from '../../database/prisma.module';
import { LessonsController } from './presentation/controllers/lessons.controller';
import { GetLevelsUseCase } from './application/use-cases/get-levels.use-case';
import { GetRoadmapUseCase } from './application/use-cases/get-roadmap.use-case';
import { GetLessonCharactersUseCase } from './application/use-cases/get-lesson-characters.use-case';
import { PrismaLessonRepository } from './infrastructure/persistence/prisma/prisma-lesson.repository';
import { LESSON_REPOSITORY } from './domain/repositories/lesson.repository.interface';

@Module({
  imports: [PrismaModule],
  controllers: [LessonsController],
  providers: [
    GetLevelsUseCase,
    GetRoadmapUseCase,
    GetLessonCharactersUseCase,
    {
      provide: LESSON_REPOSITORY,
      useClass: PrismaLessonRepository,
    },
  ],
  exports: [LESSON_REPOSITORY],
})
export class LessonsModule {}
