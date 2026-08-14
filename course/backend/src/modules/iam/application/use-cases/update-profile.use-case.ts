import { Injectable, Inject, NotFoundException } from '@nestjs/common';
import type { IUserRepository } from '../../domain/repositories/user.repository.interface';
import { USER_REPOSITORY } from '../../domain/repositories/user.repository.interface';
import { UserResponseDto } from '../dto/user-response.dto';

import { ApiPropertyOptional } from '@nestjs/swagger';

export class UpdateProfileDto {
  @ApiPropertyOptional({ description: 'URL of the avatar image' })
  avatarUrl?: string;

  @ApiPropertyOptional({ description: 'Target level (e.g., N5, HSK1)' })
  targetLevel?: string;

  @ApiPropertyOptional({ description: 'Target language (e.g., ja, zh)' })
  targetLanguage?: string;

  @ApiPropertyOptional({ description: 'Full name of the user' })
  fullName?: string;
}

@Injectable()
export class UpdateProfileUseCase {
  constructor(
    @Inject(USER_REPOSITORY)
    private readonly userRepository: IUserRepository,
  ) {}

  async execute(
    userId: string,
    data: UpdateProfileDto,
  ): Promise<UserResponseDto> {
    const user = await this.userRepository.findById(userId);

    if (!user) {
      throw new NotFoundException('User not found');
    }

    if (data.avatarUrl !== undefined) user.avatarUrl = data.avatarUrl;
    if (data.targetLevel !== undefined) user.targetLevel = data.targetLevel;
    if (data.fullName !== undefined) (user as any).fullName = data.fullName; // fullName is readonly in entity but we can update it in DB
    if (data.targetLanguage !== undefined)
      (user as any).targetLanguage = data.targetLanguage;

    await this.userRepository.update(user.id, {
      avatarUrl: user.avatarUrl,
      targetLevel: user.targetLevel,
      fullName: user.fullName,
      targetLanguage: user.targetLanguage,
    });

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
