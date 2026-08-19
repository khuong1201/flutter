import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { RegisterUseCase } from './application/use-cases/register.use-case';
import { LoginUseCase } from './application/use-cases/login.use-case';
import { SocialLoginUseCase } from './application/use-cases/social-login.use-case';
import { RefreshTokenUseCase } from './application/use-cases/refresh-token.use-case';
import { GetUserProfileUseCase } from './application/use-cases/get-user-profile.use-case';
import { UpdateProfileUseCase } from './application/use-cases/update-profile.use-case';
import { GetLeaderboardUseCase } from './application/use-cases/get-leaderboard.use-case';
import { DeleteAccountUseCase } from './application/use-cases/delete-account.use-case';
import { AuthController } from './presentation/controllers/auth.controller';
import { UsersController } from './presentation/controllers/users.controller';
import { JwtAuthGuard } from './presentation/guards/jwt-auth.guard';
import { PrismaUserRepository } from './infrastructure/persistence/prisma/prisma-user.repository';
import { USER_REPOSITORY } from './domain/repositories/user.repository.interface';

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
    DeleteAccountUseCase,
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
    DeleteAccountUseCase,
    USER_REPOSITORY,
    JwtAuthGuard,
    JwtModule
  ]
})
export class IamModule {}
