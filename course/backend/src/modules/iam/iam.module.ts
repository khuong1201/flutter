import { Module } from '@nestjs/common';
import { GetLeaderboardUseCase } from './application/use-cases/get-leaderboard.use-case';
import { GetUserProfileUseCase } from './application/use-cases/get-user-profile.use-case';
import { LoginUseCase } from './application/use-cases/login.use-case';
import { RefreshTokenUseCase } from './application/use-cases/refresh-token.use-case';
import { RegisterUseCase } from './application/use-cases/register.use-case';
import { SocialLoginUseCase } from './application/use-cases/social-login.use-case';
import { UpdateProfileUseCase } from './application/use-cases/update-profile.use-case';
import { PrismaUserRepository } from './infrastructure/persistence/prisma/prisma-user.repository';
import { AuthController } from './presentation/controllers/auth.controller';
import { UsersController } from './presentation/controllers/users.controller';
import { JwtAuthGuard } from './presentation/guards/jwt-auth.guard';

@Module({
  imports: [],
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
    PrismaUserRepository,
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
    PrismaUserRepository,
    JwtAuthGuard
  ]
})
export class IamModule {}
