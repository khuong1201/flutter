import { Test, TestingModule } from '@nestjs/testing';
import { GetLevelsUseCase } from './get-levels.use-case';
import { LESSON_REPOSITORY } from '../../domain/repositories/lesson.repository.interface';

describe('GetLevelsUseCase', () => {
  let useCase: GetLevelsUseCase;
  let lessonRepository: any;

  beforeEach(async () => {
    lessonRepository = { findLevels: jest.fn() };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        GetLevelsUseCase,
        { provide: LESSON_REPOSITORY, useValue: lessonRepository },
      ],
    }).compile();

    useCase = module.get<GetLevelsUseCase>(GetLevelsUseCase);
  });

  it('should return all levels', async () => {
    lessonRepository.findLevels.mockResolvedValue([{ id: 1, name: 'N5' }]);
    const result = await useCase.execute();
    expect(result.length).toBe(1);
    expect(result[0].name).toBe('N5');
  });
});
