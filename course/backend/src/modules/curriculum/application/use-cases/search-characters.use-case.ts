import { Injectable, Inject } from '@nestjs/common';
import type { ICharacterRepository } from '../../domain/repositories/character.repository.interface';
import { CHARACTER_REPOSITORY } from '../../domain/repositories/character.repository.interface';
import { Character } from '../../domain/entities/character.entity';

@Injectable()
export class SearchCharactersUseCase {
  constructor(
    @Inject(CHARACTER_REPOSITORY)
    private readonly characterRepository: ICharacterRepository,
  ) {}

  async execute(query: string, limit: number = 10, lang?: string): Promise<Character[]> {
    if (!query || query.trim().length === 0) {
      return this.characterRepository.findAll(limit, 0, lang);
    }
    return this.characterRepository.search(query.trim(), limit, lang);
  }
}
