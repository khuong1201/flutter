import { Test, TestingModule } from '@nestjs/testing';
import { GetProgressStatsUseCase } from './get-progress-stats.use-case';
import { PROGRESS_REPOSITORY } from '../../domain/repositories/progress.repository.interface';

describe('GetProgressStatsUseCase', () => {
  let useCase: GetProgressStatsUseCase;
  let progressRepository: any;

  beforeEach(async () => {
    progressRepository = { getStats: jest.fn() };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        GetProgressStatsUseCase,
        { provide: PROGRESS_REPOSITORY, useValue: progressRepository },
      ],
    }).compile();

    useCase = module.get<GetProgressStatsUseCase>(GetProgressStatsUseCase);
  });

  it('should return progress stats', async () => {
    progressRepository.getStats.mockResolvedValue({ totalStudied: 10, masterCount: 5 });

    const result = await useCase.execute('uuid');

    expect(result).toEqual({ totalStudied: 10, masterCount: 5 });
    expect(progressRepository.getStats).toHaveBeenCalledWith('uuid');
  });
});
