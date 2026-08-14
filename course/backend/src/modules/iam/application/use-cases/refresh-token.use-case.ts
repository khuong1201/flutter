import { Injectable, Inject } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString } from 'class-validator';

import type { IUserRepository } from '../../domain/repositories/user.repository.interface';
import { USER_REPOSITORY } from '../../domain/repositories/user.repository.interface';
import { AppException } from '../../../../common/exceptions/app.exception';
import { ApiCode } from '../../../../common/constants/api-code.constant';

export class RefreshTokenDto {
  @ApiProperty({
    example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
    description: 'Refresh token to get a new access token',
  })
  @IsString()
  @IsNotEmpty()
  refreshToken: string;
}

@Injectable()
export class RefreshTokenUseCase {
  constructor(
    @Inject(USER_REPOSITORY)
    private readonly userRepository: IUserRepository,
    private readonly jwtService: JwtService,
  ) {}

  async execute(data: RefreshTokenDto): Promise<{ accessToken: string; refreshToken: string }> {
    let payload;
    try {
      payload = await this.jwtService.verifyAsync(data.refreshToken);
    } catch {
      throw new AppException(ApiCode.TOKEN_INVALID, 'Invalid or expired refresh token', 401);
    }

    const userId = payload.sub;
    const user = await this.userRepository.findById(userId);

    if (!user) {
      throw new AppException(ApiCode.USER_NOT_FOUND, 'User not found', 404);
    }

    if (user.refreshToken !== data.refreshToken) {
      throw new AppException(ApiCode.TOKEN_INVALID, 'Refresh token mismatch', 401);
    }

    // Generate new tokens
    const newPayload = { sub: user.id, email: user.email };
    const newAccessToken = await this.jwtService.signAsync(newPayload, { expiresIn: '1h' });
    const newRefreshToken = await this.jwtService.signAsync(newPayload, { expiresIn: '30d' });

    user.refreshToken = newRefreshToken;
    await this.userRepository.update(user.id, user);

    return { accessToken: newAccessToken, refreshToken: newRefreshToken };
  }
}
