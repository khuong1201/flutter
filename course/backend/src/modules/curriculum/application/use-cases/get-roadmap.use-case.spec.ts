import { Test, TestingModule } from '@nestjs/testing';
import { GetRoadmapUseCase } from './get-roadmap.use-case';
import { LESSON_REPOSITORY } from '../../domain/repositories/lesson.repository.interface';

describe('GetRoadmapUseCase', () => {
  let useCase: GetRoadmapUseCase;
  let lessonRepository: any;

  beforeEach(async () => {
    lessonRepository = {
      findLevels: jest.fn(),
      findUserLessons: jest.fn(),
      findLessonsByLevel: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        GetRoadmapUseCase,
        { provide: LESSON_REPOSITORY, useValue: lessonRepository },
      ],
    }).compile();

    useCase = module.get<GetRoadmapUseCase>(GetRoadmapUseCase);
  });

  it('should return mapped roadmap', async () => {
    lessonRepository.findLevels.mockResolvedValue([{ id: 1, code: 'N5' }]);
    lessonRepository.findUserLessons.mockResolvedValue([{ lessonId: 1, status: 'completed' }]);
    lessonRepository.findLessonsByLevel.mockResolvedValue([
      { id: 1, orderIndex: 1 },
      { id: 2, orderIndex: 2 }
    ]);

    const result = await useCase.execute('uuid');

    expect(result.length).toBe(1);
    expect(result[0].lessons.length).toBe(2);
    // lesson 1 is completed based on userLessons
    expect(result[0].lessons[0].status).toBe('completed');
    // lesson 2 is locked because not in userLessons and not orderIndex 1
    expect(result[0].lessons[1].status).toBe('locked');
  });
});
