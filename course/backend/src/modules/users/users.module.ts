import { Module } from '@nestjs/common';
import { PrismaModule } from '../../database/prisma.module';
import { UsersController } from './presentation/controllers/users.controller';
import { GetUserProfileUseCase } from './application/use-cases/get-user-profile.use-case';
import { UpdateProfileUseCase } from './application/use-cases/update-profile.use-case';
import { GetLeaderboardUseCase } from './application/use-cases/get-leaderboard.use-case';
import { PrismaUserRepository } from './infrastructure/persistence/prisma/prisma-user.repository';
import { USER_REPOSITORY } from './domain/repositories/user.repository.interface';

@Module({
  imports: [PrismaModule],
  controllers: [UsersController],
  providers: [
    GetUserProfileUseCase,
    UpdateProfileUseCase,
    GetLeaderboardUseCase,
    {
      provide: USER_REPOSITORY,
      useClass: PrismaUserRepository,
    },
  ],
  exports: [USER_REPOSITORY],
})
export class UsersModule {}
