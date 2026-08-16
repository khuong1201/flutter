import { Test, TestingModule } from '@nestjs/testing';
import { RecordContributionUseCase } from './record-contribution.use-case';

describe('RecordContributionUseCase', () => {
  let useCase: RecordContributionUseCase;
  let contributionRepository: any;

  beforeEach(async () => {
    contributionRepository = { incrementCount: jest.fn() };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        RecordContributionUseCase,
        { provide: 'IContributionRepository', useValue: contributionRepository },
      ],
    }).compile();

    useCase = module.get<RecordContributionUseCase>(RecordContributionUseCase);
  });

  it('should record contribution for today', async () => {
    await useCase.execute('uuid');

    expect(contributionRepository.incrementCount).toHaveBeenCalledWith(
      'uuid',
      expect.any(Date)
    );
  });
});
