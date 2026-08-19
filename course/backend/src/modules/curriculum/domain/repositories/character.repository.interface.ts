import { Character } from '../entities/character.entity';

export const CHARACTER_REPOSITORY = 'CHARACTER_REPOSITORY';

export interface ICharacterRepository {
  findById(id: number): Promise<Character | null>;
  findByText(text: string): Promise<Character | null>;
  findAll(limit?: number, offset?: number, lang?: string): Promise<Character[]>;
  search(query: string, limit?: number, lang?: string): Promise<Character[]>;
  update(character: Character): Promise<Character>;
}
