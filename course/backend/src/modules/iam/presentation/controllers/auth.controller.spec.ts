import { Test, TestingModule } from '@nestjs/testing';
import { AuthController } from './auth.controller';
import { SocialLoginUseCase } from '../../application/use-cases/social-login.use-case';

import { LoginUseCase } from '../../application/use-cases/login.use-case';
import { RegisterUseCase } from '../../application/use-cases/register.use-case';
import { RefreshTokenUseCase } from '../../application/use-cases/refresh-token.use-case';

describe('AuthController', () => {
  let controller: AuthController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [AuthController],
      providers: [
        { provide: SocialLoginUseCase, useValue: { execute: jest.fn() } },
        { provide: LoginUseCase, useValue: { execute: jest.fn().mockResolvedValue({ token: 'mock-jwt-token' }) } },
        { provide: RegisterUseCase, useValue: { execute: jest.fn().mockResolvedValue({ message: 'User registered successfully' }) } },
        { provide: RefreshTokenUseCase, useValue: { execute: jest.fn() } },
      ],
    }).compile();

    controller = module.get<AuthController>(AuthController);
  });

  it('should return a mock token on login', async () => {
    const result = await controller.login({
      email: 'test@example.com',
      password: 'password',
    });
    expect(result).toEqual({ token: 'mock-jwt-token' });
  });

  it('should return success message on register', async () => {
    const result = await controller.register({
      email: 'test@example.com',
      password: 'password',
    });
    expect(result).toEqual({ message: 'User registered successfully' });
  });
});
