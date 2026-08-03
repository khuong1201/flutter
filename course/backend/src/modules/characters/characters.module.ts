import { Module } from '@nestjs/common';
import { PrismaModule } from '../../database/prisma.module';
import { CharactersController } from './presentation/controllers/characters.controller';
import { GetCharacterDetailsUseCase } from './application/use-cases/get-character-details.use-case';
import { SearchCharactersUseCase } from './application/use-cases/search-characters.use-case';
import { GetCharacterAudioUseCase } from './application/use-cases/get-character-audio.use-case';
import { AudioModule } from '../audio/audio.module';
import { PrismaCharacterRepository } from './infrastructure/persistence/prisma/prisma-character.repository';
import { CHARACTER_REPOSITORY } from './domain/repositories/character.repository.interface';

@Module({
  imports: [PrismaModule, AudioModule],
  controllers: [CharactersController],
  providers: [
    GetCharacterDetailsUseCase,
    SearchCharactersUseCase,
    GetCharacterAudioUseCase,
    {
      provide: CHARACTER_REPOSITORY,
      useClass: PrismaCharacterRepository,
    },
  ],
  exports: [CHARACTER_REPOSITORY],
})
export class CharactersModule {}
