import { Test, TestingModule } from '@nestjs/testing';
import { GetContributionsUseCase } from './get-contributions.use-case';

describe('GetContributionsUseCase', () => {
  let useCase: GetContributionsUseCase;
  let contributionRepository: any;

  beforeEach(async () => {
    contributionRepository = { findByUserIdAndDateRange: jest.fn() };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        GetContributionsUseCase,
        { provide: 'IContributionRepository', useValue: contributionRepository },
      ],
    }).compile();

    useCase = module.get<GetContributionsUseCase>(GetContributionsUseCase);
  });

  it('should return formatted contributions', async () => {
    const mockDate = new Date('2026-08-16T12:00:00Z');
    contributionRepository.findByUserIdAndDateRange.mockResolvedValue([
      { date: mockDate, count: 5 }
    ]);

    const result = await useCase.execute('uuid', 2026);

    expect(result.length).toBe(1);
    expect(result[0].date).toBe('2026-08-16');
    expect(result[0].count).toBe(5);
    expect(contributionRepository.findByUserIdAndDateRange).toHaveBeenCalledWith(
      'uuid',
      expect.any(Date),
      expect.any(Date)
    );
  });
});
