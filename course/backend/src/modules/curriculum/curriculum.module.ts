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
    PrismaCharacterRepository,
    PrismaLessonRepository,
    PrismaLevelRepository,
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
    PrismaCharacterRepository,
    PrismaLessonRepository,
    PrismaLevelRepository,
    TtsAudioProvider,
    LocalStorageService
  ]
})
export class CurriculumModule {}
