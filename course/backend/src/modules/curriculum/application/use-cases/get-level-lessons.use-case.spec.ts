import { Test, TestingModule } from '@nestjs/testing';
import { GetLevelLessonsUseCase } from './get-level-lessons.use-case';
import { LEVEL_REPOSITORY } from '../../domain/repositories/level.repository.interface';

describe('GetLevelLessonsUseCase', () => {
  let useCase: GetLevelLessonsUseCase;
  let levelRepository: any;

  beforeEach(async () => {
    levelRepository = { findLessonsByLevel: jest.fn() };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        GetLevelLessonsUseCase,
        { provide: LEVEL_REPOSITORY, useValue: levelRepository },
      ],
    }).compile();

    useCase = module.get<GetLevelLessonsUseCase>(GetLevelLessonsUseCase);
  });

  it('should return lessons for a given level', async () => {
    levelRepository.findLessonsByLevel.mockResolvedValue([{ id: 1, title: 'Lesson 1' }]);
    const result = await useCase.execute(1);
    expect(result.length).toBe(1);
    expect(result[0].title).toBe('Lesson 1');
    expect(levelRepository.findLessonsByLevel).toHaveBeenCalledWith(1);
  });
});
