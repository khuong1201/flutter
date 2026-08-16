import { Module } from '@nestjs/common';
import { CompleteLessonUseCase } from './application/use-cases/complete-lesson.use-case';
import { GetAllLevelsUseCase } from './application/use-cases/get-all-levels.use-case';
import { GetCharacterAudioUseCase } from './application/use-cases/get-character-audio.use-case';
import { GetCharacterDetailsUseCase } from './application/use-cases/get-character-details.use-case';
import { GetLessonCharactersUseCase } from './application/use-cases/get-lesson-characters.use-case';
import { GetLevelLessonsUseCase } from './application/use-cases/get-level-lessons.use-case';
import { GetLevelsUseCase } from './application/use-cases/get-levels.use-case';
import { GetRoadmapUseCase } from './application/use-cases/get-roadmap.use-case';
import { SearchCharactersUseCase } from './application/use-cases/search-characters.use-case';
import { PrismaCharacterRepository } from './infrastructure/persistence/prisma/prisma-character.repository';
import { PrismaLessonRepository } from './infrastructure/persistence/prisma/prisma-lesson.repository';
import { PrismaLevelRepository } from './infrastructure/persistence/prisma/prisma-level.repository';
import { TtsAudioProvider } from './infrastructure/providers/tts-audio.provider';
import { LocalStorageService } from './infrastructure/storage/local-storage.service';
import { CharactersController } from './presentation/controllers/characters.controller';
import { LessonsController } from './presentation/controllers/lessons.controller';
import { LevelsController } from './presentation/controllers/levels.controller';

import { CHARACTER_REPOSITORY } from './domain/repositories/character.repository.interface';
import { LESSON_REPOSITORY } from './domain/repositories/lesson.repository.interface';
import { LEVEL_REPOSITORY } from './domain/repositories/level.repository.interface';

@Module({
  imports: [],
  controllers: [
    CharactersController,
    LessonsController,
    LevelsController
  ],
  providers: [
    CompleteLessonUseCase,
    GetAllLevelsUseCase,
    GetCharacterAudioUseCase,
    GetCharacterDetailsUseCase,
    GetLessonCharactersUseCase,
    GetLevelLessonsUseCase,
    GetLevelsUseCase,
    GetRoadmapUseCase,
    SearchCharactersUseCase,
    { provide: CHARACTER_REPOSITORY, useClass: PrismaCharacterRepository },
    { provide: LESSON_REPOSITORY, useClass: PrismaLessonRepository },
    { provide: LEVEL_REPOSITORY, useClass: PrismaLevelRepository },
    TtsAudioProvider,
    LocalStorageService
  ],
  exports: [
    CompleteLessonUseCase,
    GetAllLevelsUseCase,
    GetCharacterAudioUseCase,
    GetCharacterDetailsUseCase,
    GetLessonCharactersUseCase,
    GetLevelLessonsUseCase,
    GetLevelsUseCase,
    GetRoadmapUseCase,
    SearchCharactersUseCase,
    CHARACTER_REPOSITORY,
    LESSON_REPOSITORY,
    LEVEL_REPOSITORY,
    TtsAudioProvider,
    LocalStorageService
  ]
})
export class CurriculumModule {}
