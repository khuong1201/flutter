import { Injectable, Inject, NotFoundException } from '@nestjs/common';
import type { ICharacterRepository } from '../../domain/repositories/character.repository.interface';
import { CHARACTER_REPOSITORY } from '../../domain/repositories/character.repository.interface';
import { CharacterResponseDto } from '../dto/character-response.dto';

@Injectable()
export class GetCharacterDetailsUseCase {
  constructor(
    @Inject(CHARACTER_REPOSITORY)
    private readonly characterRepository: ICharacterRepository,
  ) {}

  async execute(id: number): Promise<CharacterResponseDto> {
    const character = await this.characterRepository.findById(id);
    
    if (!character) {
      throw new NotFoundException('Character not found');
    }

    return {
      id: character.id,
      charText: character.charText,
      language: character.language,
      meaning: character.meaning,
      strokeData: character.strokeData,
      pronunciation: character.pronunciation,
      audioKey: character.audioKey || undefined,
      radicals: character.radicals?.map(r => ({
        radicalText: r.radicalText,
        meaning: r.meaning,
      })),
      vocabularies: character.vocabularies?.map(v => ({
        word: v.word,
        meaning: v.meaning,
        pronunciation: v.pronunciation || '',
      })),
    };
  }
}
