import { Injectable, Inject, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import type { IUserRepository } from '../../domain/repositories/user.repository.interface';
import { USER_REPOSITORY } from '../../domain/repositories/user.repository.interface';
import { User } from '../../domain/entities/user.entity';
import { randomUUID } from 'crypto';

import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString } from 'class-validator';

export class SocialLoginDto {
  @ApiProperty({
    example: 'google',
    description: 'Social provider (google, apple)',
  })
  @IsString()
  @IsNotEmpty()
  provider: string;

  @ApiProperty({
    example: 'eyJhbGciOiJSUzI1...',
    description: 'ID Token from provider',
  })
  @IsString()
  @IsNotEmpty()
  idToken: string;
}

@Injectable()
export class SocialLoginUseCase {
  constructor(
    @Inject(USER_REPOSITORY)
    private readonly userRepository: IUserRepository,
    private readonly jwtService: JwtService,
  ) {}

  async execute(data: SocialLoginDto): Promise<{ accessToken: string; refreshToken: string }> {
    // 1. Verify idToken with the provider (Google/Apple).
    // In a real app, use google-auth-library or apple-signin-auth to verify.
    // For now, we mock the verification and assume idToken contains user info.
    let email = '';
    let fullName = '';
    let providerId = '';

    if (data.provider === 'google') {
      // Mock logic: decode JWT or call Google API
      email = `google_${data.idToken}@example.com`; // mock payload extraction
      fullName = 'Google User';
      providerId = data.idToken;
    } else if (data.provider === 'apple') {
      email = `apple_${data.idToken}@example.com`;
      fullName = 'Apple User';
      providerId = data.idToken;
    } else {
      throw new UnauthorizedException('Unsupported provider');
    }

    // 2. Find existing user
    let user = await this.userRepository.findByEmail(email);

    // 3. If not found, create new user
    if (!user) {
      user = new User(
        randomUUID(),
        email,
        fullName,
        'ja', // default target language
        0,
        null,
        null,
        data.provider,
        providerId,
      );
      await this.userRepository.create(user);
    }

    // 4. Generate internal JWT
    const payload = { sub: user.id, email: user.email };
    const accessToken = await this.jwtService.signAsync(payload, { expiresIn: '1h' });
    const refreshToken = await this.jwtService.signAsync(payload, { expiresIn: '30d' });

    user.refreshToken = refreshToken;
    await this.userRepository.update(user.id, user);

    return { accessToken, refreshToken };
  }
}
