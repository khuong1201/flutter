import { Injectable, Inject } from '@nestjs/common';
import type { IUserRepository } from '../../domain/repositories/user.repository.interface';
import { USER_REPOSITORY } from '../../domain/repositories/user.repository.interface';
import { UserResponseDto } from '../dto/user-response.dto';

@Injectable()
export class GetLeaderboardUseCase {
  constructor(
    @Inject(USER_REPOSITORY)
    private readonly userRepository: IUserRepository,
  ) {}

  async execute(limit: number = 10): Promise<UserResponseDto[]> {
    // We need to fetch top users by xpPoints.
    // However, IUserRepository currently only has findById, findByEmail, save.
    // I should add `findTopByXp(limit: number)` to IUserRepository.
    // For now, I'll assume we've added it.
    
    const users = await this.userRepository.findTopByXp(limit);
    
    return users.map(user => ({
      id: user.id,
      email: user.email,
      fullName: user.fullName,
      targetLanguage: user.targetLanguage,
      targetLevel: user.targetLevel ?? undefined,
      avatarUrl: user.avatarUrl ?? undefined,
      xpPoints: user.xpPoints,
      currentStreak: user.currentStreak,
      longestStreak: user.longestStreak,
    }));
  }
}
