import { Injectable, Inject, NotFoundException } from '@nestjs/common';
import type { IUserRepository } from '../../domain/repositories/user.repository.interface';
import { USER_REPOSITORY } from '../../domain/repositories/user.repository.interface';
import { UserResponseDto } from '../dto/user-response.dto';

@Injectable()
export class GetUserProfileUseCase {
  constructor(
    @Inject(USER_REPOSITORY)
    private readonly userRepository: IUserRepository,
  ) {}

  async execute(userId: string): Promise<UserResponseDto> {
    const user = await this.userRepository.findById(userId);

    if (!user) {
      throw new NotFoundException('User not found');
    }

    return {
      id: user.id,
      email: user.email,
      fullName: user.fullName,
      targetLanguage: user.targetLanguage,
      targetLevel: user.targetLevel ?? undefined,
      avatarUrl: user.avatarUrl ?? undefined,
      xpPoints: user.xpPoints,
      currentStreak: user.currentStreak,
      longestStreak: user.longestStreak,
    };
  }
}
