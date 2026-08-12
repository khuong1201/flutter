import { Injectable, Inject, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsNotEmpty, IsString, MinLength } from 'class-validator';

import type { IUserRepository } from '../../../users/domain/repositories/user.repository.interface';
import { USER_REPOSITORY } from '../../../users/domain/repositories/user.repository.interface';
import { AppException } from '../../../../common/exceptions/app.exception';
import { ApiCode } from '../../../../common/constants/api-code.constant';

export class LoginDto {
  @ApiProperty({ example: 'user@example.com' })
  @IsEmail()
  @IsNotEmpty()
  email: string;

  @ApiProperty({ example: 'password123' })
  @IsString()
  @IsNotEmpty()
  @MinLength(6)
  password: string;
}

@Injectable()
export class LoginUseCase {
  constructor(
    @Inject(USER_REPOSITORY)
    private readonly userRepository: IUserRepository,
    private readonly jwtService: JwtService,
  ) {}

  async execute(data: LoginDto): Promise<{ accessToken: string }> {
    const user = await this.userRepository.findByEmail(data.email);
    if (!user) {
      throw new AppException(
        ApiCode.INVALID_CREDENTIALS,
        'Invalid email or password',
        401,
      );
    }

    if (!user.passwordHash) {
      throw new AppException(
        ApiCode.INVALID_CREDENTIALS,
        'User registered via social provider. Please use social login.',
        401,
      );
    }

    const isPasswordValid = await bcrypt.compare(
      data.password,
      user.passwordHash,
    );
    if (!isPasswordValid) {
      throw new AppException(
        ApiCode.INVALID_CREDENTIALS,
        'Invalid email or password',
        401,
      );
    }

    const payload = { sub: user.id, email: user.email };
    const accessToken = await this.jwtService.signAsync(payload);

    return { accessToken };
  }
}
