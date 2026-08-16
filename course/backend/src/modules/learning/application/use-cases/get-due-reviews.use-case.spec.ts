import { Test, TestingModule } from '@nestjs/testing';
import { GetDueReviewsUseCase } from './get-due-reviews.use-case';
import { PROGRESS_REPOSITORY } from '../../domain/repositories/progress.repository.interface';

describe('GetDueReviewsUseCase', () => {
  let useCase: GetDueReviewsUseCase;
  let progressRepository: any;

  beforeEach(async () => {
    progressRepository = { findDueReviews: jest.fn() };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        GetDueReviewsUseCase,
        { provide: PROGRESS_REPOSITORY, useValue: progressRepository },
      ],
    }).compile();

    useCase = module.get<GetDueReviewsUseCase>(GetDueReviewsUseCase);
  });

  it('should return due reviews for user', async () => {
    progressRepository.findDueReviews.mockResolvedValue([{ id: 'prog1' }, { id: 'prog2' }]);

    const result = await useCase.execute('uuid');

    expect(result.length).toBe(2);
    expect(progressRepository.findDueReviews).toHaveBeenCalledWith('uuid', expect.any(Date));
  });
});
