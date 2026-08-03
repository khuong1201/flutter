import { Test, TestingModule } from '@nestjs/testing';
import { SubmitReviewResultUseCase, SubmitReviewDto } from './submit-review-result.use-case';
import { REVIEW_LOG_REPOSITORY, IReviewLogRepository } from '../../domain/repositories/review-log.repository.interface';
import { UpdateProgressUseCase } from '../../../progress/application/use-cases/update-progress.use-case';

describe('SubmitReviewResultUseCase', () => {
  let useCase: SubmitReviewResultUseCase;
  let reviewLogRepository: IReviewLogRepository;
  let updateProgressUseCase: UpdateProgressUseCase;

  const mockReviewLogRepository = {
    create: jest.fn(),
  };

  const mockUpdateProgressUseCase = {
    execute: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        SubmitReviewResultUseCase,
        {
          provide: REVIEW_LOG_REPOSITORY,
          useValue: mockReviewLogRepository,
        },
        {
          provide: UpdateProgressUseCase,
          useValue: mockUpdateProgressUseCase,
        },
      ],
    }).compile();

    useCase = module.get<SubmitReviewResultUseCase>(SubmitReviewResultUseCase);
    reviewLogRepository = module.get<IReviewLogRepository>(REVIEW_LOG_REPOSITORY);
    updateProgressUseCase = module.get<UpdateProgressUseCase>(UpdateProgressUseCase);
  });

  it('should save review log and update progress', async () => {
    mockReviewLogRepository.create.mockResolvedValue(null);
    mockUpdateProgressUseCase.execute.mockResolvedValue(null);

    const dto: SubmitReviewDto = { characterId: 1, grade: 5 };
    await useCase.execute('user-1', dto);

    expect(mockReviewLogRepository.create).toHaveBeenCalled();
    expect(mockUpdateProgressUseCase.execute).toHaveBeenCalledWith('user-1', 1, 5);
  });
});
