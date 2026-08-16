import { Module } from '@nestjs/common';
import { GetLeaderboardUseCase } from './application/use-cases/get-leaderboard.use-case';
import { GetUserProfileUseCase } from './application/use-cases/get-user-profile.use-case';
import { LoginUseCase } from './application/use-cases/login.use-case';
import { RefreshTokenUseCase } from './application/use-cases/refresh-token.use-case';
import { RegisterUseCase } from './application/use-cases/register.use-case';
import { SocialLoginUseCase } from './application/use-cases/social-login.use-case';
import { UpdateProfileUseCase } from './application/use-cases/update-profile.use-case';
import { PrismaUserRepository } from './infrastructure/persistence/prisma/prisma-user.repository';
import { USER_REPOSITORY } from './domain/repositories/user.repository.interface';
import { AuthController } from './presentation/controllers/auth.controller';
import { UsersController } from './presentation/controllers/users.controller';
import { JwtAuthGuard } from './presentation/guards/jwt-auth.guard';

import { JwtModule } from '@nestjs/jwt';

@Module({
  imports: [
    JwtModule.register({
      secret: process.env.JWT_SECRET || 'super-secret',
      signOptions: { expiresIn: '1d' },
    }),
  ],
  controllers: [
    AuthController,
    UsersController
  ],
  providers: [
    GetLeaderboardUseCase,
    GetUserProfileUseCase,
    LoginUseCase,
    RefreshTokenUseCase,
    RegisterUseCase,
    SocialLoginUseCase,
    UpdateProfileUseCase,
    {
      provide: USER_REPOSITORY,
      useClass: PrismaUserRepository
    },
    JwtAuthGuard
  ],
  exports: [
    GetLeaderboardUseCase,
    GetUserProfileUseCase,
    LoginUseCase,
    RefreshTokenUseCase,
    RegisterUseCase,
    SocialLoginUseCase,
    UpdateProfileUseCase,
    USER_REPOSITORY,
    JwtAuthGuard,
    JwtModule
  ]
})
export class IamModule {}
