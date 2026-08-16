import { Test, TestingModule } from '@nestjs/testing';
import { SearchCharactersUseCase } from './search-characters.use-case';
import { CHARACTER_REPOSITORY } from '../../domain/repositories/character.repository.interface';

describe('SearchCharactersUseCase', () => {
  let useCase: SearchCharactersUseCase;
  let characterRepository: any;

  beforeEach(async () => {
    characterRepository = { search: jest.fn() };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        SearchCharactersUseCase,
        { provide: CHARACTER_REPOSITORY, useValue: characterRepository },
      ],
    }).compile();

    useCase = module.get<SearchCharactersUseCase>(SearchCharactersUseCase);
  });

  it('should search characters', async () => {
    characterRepository.search.mockResolvedValue([{ id: 1, charText: 'A' }]);
    const result = await useCase.execute('query');
    expect(result.length).toBe(1);
    expect(result[0].charText).toBe('A');
    expect(characterRepository.search).toHaveBeenCalledWith('query', 10);
  });
});
