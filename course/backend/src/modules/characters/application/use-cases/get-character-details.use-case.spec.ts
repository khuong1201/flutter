import { Test, TestingModule } from '@nestjs/testing';
import { GetCharacterDetailsUseCase } from './get-character-details.use-case';
import { CHARACTER_REPOSITORY, ICharacterRepository } from '../../domain/repositories/character.repository.interface';
import { Character } from '../../domain/entities/character.entity';
import { NotFoundException } from '@nestjs/common';

describe('GetCharacterDetailsUseCase', () => {
  let useCase: GetCharacterDetailsUseCase;
  let characterRepository: ICharacterRepository;

  const mockCharacterRepository = {
    findById: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        GetCharacterDetailsUseCase,
        {
          provide: CHARACTER_REPOSITORY,
          useValue: mockCharacterRepository,
        },
      ],
    }).compile();

    useCase = module.get<GetCharacterDetailsUseCase>(GetCharacterDetailsUseCase);
    characterRepository = module.get<ICharacterRepository>(CHARACTER_REPOSITORY);
  });

  it('should return a character when found', async () => {
    const mockCharacter = new Character(1, '日', 'ja', 'Sun/Day', {}, null, {}, [], []);
    mockCharacterRepository.findById.mockResolvedValue(mockCharacter);

    const result = await useCase.execute(1);

    expect(result).toEqual(mockCharacter);
    expect(mockCharacterRepository.findById).toHaveBeenCalledWith(1);
  });

  it('should throw NotFoundException when character is not found', async () => {
    mockCharacterRepository.findById.mockResolvedValue(null);

    await expect(useCase.execute(999)).rejects.toThrow(NotFoundException);
    expect(mockCharacterRepository.findById).toHaveBeenCalledWith(999);
  });
});
