import { Test, TestingModule } from '@nestjs/testing';
import { PracticeController } from './practice.controller';
import {
  SubmitReviewResultUseCase,
  SubmitReviewDto,
} from '../../application/use-cases/submit-review-result.use-case';
import { JwtAuthGuard } from '../../../iam/presentation/guards/jwt-auth.guard';

import { GenerateQuizUseCase } from '../../application/use-cases/generate-quiz.use-case';

describe('PracticeController', () => {
  let controller: PracticeController;
  let submitReviewUseCase: SubmitReviewResultUseCase;

  const mockSubmitReviewUseCase = {
    execute: jest.fn(),
  };

  const mockGenerateQuizUseCase = {
    execute: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [PracticeController],
      providers: [
        {
          provide: SubmitReviewResultUseCase,
          useValue: mockSubmitReviewUseCase,
        },
        {
          provide: GenerateQuizUseCase,
          useValue: mockGenerateQuizUseCase,
        },
      ],
    })
      .overrideGuard(JwtAuthGuard)
      .useValue({ canActivate: () => true })
      .compile();

    controller = module.get<PracticeController>(PracticeController);
    submitReviewUseCase = module.get<SubmitReviewResultUseCase>(
      SubmitReviewResultUseCase,
    );
  });

  it('should call submit review use case on POST /practice/review', async () => {
    mockSubmitReviewUseCase.execute.mockResolvedValue(undefined);

    const dto: SubmitReviewDto = { characterId: 1, grade: 5 };
    const req = { user: { id: 'uuid-123' } };

    const result = await controller.submitReview(req, dto);

    expect(result).toEqual({ success: true });
    expect(mockSubmitReviewUseCase.execute).toHaveBeenCalledWith(
      'uuid-123',
      dto,
    );
  });
});
