import { Test, TestingModule } from '@nestjs/testing';
import { CompleteLessonUseCase } from './complete-lesson.use-case';
import { LESSON_REPOSITORY } from '../../domain/repositories/lesson.repository.interface';
import { RecordContributionUseCase } from '../../../community/application/use-cases/record-contribution.use-case';

describe('CompleteLessonUseCase', () => {
  let useCase: CompleteLessonUseCase;
  let lessonRepository: any;
  let recordContributionUseCase: any;

  beforeEach(async () => {
    lessonRepository = { completeUserLesson: jest.fn() };
    recordContributionUseCase = { execute: jest.fn() };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        CompleteLessonUseCase,
        { provide: LESSON_REPOSITORY, useValue: lessonRepository },
        { provide: RecordContributionUseCase, useValue: recordContributionUseCase },
      ],
    }).compile();

    useCase = module.get<CompleteLessonUseCase>(CompleteLessonUseCase);
  });

  it('should complete lesson and record contribution', async () => {
    await useCase.execute('uuid', 1);

    expect(lessonRepository.completeUserLesson).toHaveBeenCalledWith('uuid', 1);
    expect(recordContributionUseCase.execute).toHaveBeenCalledWith('uuid');
  });
});
