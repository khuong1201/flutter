import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { AuthController } from './presentation/controllers/auth.controller';
import { SocialLoginUseCase } from './application/use-cases/social-login.use-case';
import { LoginUseCase } from './application/use-cases/login.use-case';
import { RegisterUseCase } from './application/use-cases/register.use-case';
import { PrismaUserRepository } from '../users/infrastructure/persistence/prisma/prisma-user.repository';
import { USER_REPOSITORY } from '../users/domain/repositories/user.repository.interface';

@Module({
  imports: [
    JwtModule.register({
      global: true,
      secret: process.env.JWT_SECRET || 'super-secret',
      signOptions: { expiresIn: '1d' },
    }),
  ],
  controllers: [AuthController],
  providers: [
    SocialLoginUseCase,
    LoginUseCase,
    RegisterUseCase,
    {
      provide: USER_REPOSITORY,
      useClass: PrismaUserRepository,
    },
  ],
  exports: [],
})
export class AuthModule {}
