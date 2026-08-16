import { Test, TestingModule } from '@nestjs/testing';
import { GetLessonCharactersUseCase } from './get-lesson-characters.use-case';
import { LESSON_REPOSITORY } from '../../domain/repositories/lesson.repository.interface';

describe('GetLessonCharactersUseCase', () => {
  let useCase: GetLessonCharactersUseCase;
  let lessonRepository: any;

  beforeEach(async () => {
    lessonRepository = { findCharactersByLesson: jest.fn() };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        GetLessonCharactersUseCase,
        { provide: LESSON_REPOSITORY, useValue: lessonRepository },
      ],
    }).compile();

    useCase = module.get<GetLessonCharactersUseCase>(GetLessonCharactersUseCase);
  });

  it('should return characters for a given lesson', async () => {
    lessonRepository.findCharactersByLesson.mockResolvedValue([{ id: 1, charText: 'A' }]);
    const result = await useCase.execute(1);
    expect(result.length).toBe(1);
    expect(result[0].charText).toBe('A');
    expect(lessonRepository.findCharactersByLesson).toHaveBeenCalledWith(1);
  });
});
