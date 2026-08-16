import { Test, TestingModule } from '@nestjs/testing';
import { GetAllLevelsUseCase } from './get-all-levels.use-case';
import { LEVEL_REPOSITORY } from '../../domain/repositories/level.repository.interface';

describe('GetAllLevelsUseCase', () => {
  let useCase: GetAllLevelsUseCase;
  let levelRepository: any;

  beforeEach(async () => {
    levelRepository = { findAll: jest.fn() };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        GetAllLevelsUseCase,
        { provide: LEVEL_REPOSITORY, useValue: levelRepository },
      ],
    }).compile();

    useCase = module.get<GetAllLevelsUseCase>(GetAllLevelsUseCase);
  });

  it('should return all levels', async () => {
    levelRepository.findAll.mockResolvedValue([{ id: 1 }]);
    const result = await useCase.execute();
    expect(result.length).toBe(1);
    expect(levelRepository.findAll).toHaveBeenCalled();
  });
});
