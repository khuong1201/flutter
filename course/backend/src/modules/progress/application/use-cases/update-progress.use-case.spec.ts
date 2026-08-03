import { Test, TestingModule } from '@nestjs/testing';
import { UpdateProgressUseCase } from './update-progress.use-case';
import { PROGRESS_REPOSITORY, IProgressRepository } from '../../domain/repositories/progress.repository.interface';
import { UserProgress } from '../../domain/entities/user-progress.entity';

describe('UpdateProgressUseCase', () => {
  let useCase: UpdateProgressUseCase;
  let progressRepository: IProgressRepository;

  const mockProgressRepository = {
    findByUserAndCharacter: jest.fn(),
    save: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        UpdateProgressUseCase,
        {
          provide: PROGRESS_REPOSITORY,
          useValue: mockProgressRepository,
        },
      ],
    }).compile();

    useCase = module.get<UpdateProgressUseCase>(UpdateProgressUseCase);
    progressRepository = module.get<IProgressRepository>(PROGRESS_REPOSITORY);
  });

  it('should create new progress if not exists and save', async () => {
    mockProgressRepository.findByUserAndCharacter.mockResolvedValue(null);
    mockProgressRepository.save.mockImplementation(async (p) => p);

    const result = await useCase.execute('uuid-user', 1, 4);

    expect(result.userId).toBe('uuid-user');
    expect(result.characterId).toBe(1);
    expect(result.intervalDays).toBe(1); // SM2 rule for first correct
    expect(result.consecutiveCorrect).toBe(1);
    expect(mockProgressRepository.save).toHaveBeenCalled();
  });

  it('should update existing progress and save', async () => {
    const existingProgress = new UserProgress(
      'uuid-prog',
      'uuid-user',
      1,
      'learning',
      2.5,
      1,
      new Date(),
      1,
      1
    );
    mockProgressRepository.findByUserAndCharacter.mockResolvedValue(existingProgress);
    mockProgressRepository.save.mockImplementation(async (p) => p);

    const result = await useCase.execute('uuid-user', 1, 4);

    expect(result.intervalDays).toBe(6); // SM2 rule for second correct
    expect(result.consecutiveCorrect).toBe(2);
    expect(mockProgressRepository.save).toHaveBeenCalledWith(existingProgress);
  });
});
