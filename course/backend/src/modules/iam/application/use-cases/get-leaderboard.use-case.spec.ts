import { Test, TestingModule } from '@nestjs/testing';
import { GetLeaderboardUseCase } from './get-leaderboard.use-case';
import { USER_REPOSITORY } from '../../domain/repositories/user.repository.interface';

describe('GetLeaderboardUseCase', () => {
  let useCase: GetLeaderboardUseCase;
  let userRepository: any;

  beforeEach(async () => {
    userRepository = { findTopByXp: jest.fn() };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        GetLeaderboardUseCase,
        { provide: USER_REPOSITORY, useValue: userRepository },
      ],
    }).compile();

    useCase = module.get<GetLeaderboardUseCase>(GetLeaderboardUseCase);
  });

  it('should map leaderboard users to LeaderboardDto', async () => {
    userRepository.findTopByXp.mockResolvedValue([
      { id: '1', fullName: 'A', xpPoints: 100, avatarUrl: 'av1' },
      { id: '2', fullName: 'B', xpPoints: 50, avatarUrl: 'av2' }
    ]);

    const result = await useCase.execute(2);
    
    expect(result.length).toBe(2);
    expect(result[0].id).toBe('1');
    expect(result[0].xpPoints).toBe(100);
    expect(userRepository.findTopByXp).toHaveBeenCalledWith(2);
  });
});
