import { Test, TestingModule } from '@nestjs/testing';
import { SocialLoginUseCase } from './social-login.use-case';
import { USER_REPOSITORY } from '../../domain/repositories/user.repository.interface';
import { JwtService } from '@nestjs/jwt';

describe('SocialLoginUseCase', () => {
  let useCase: SocialLoginUseCase;
  let userRepository: any;
  let jwtService: any;

  beforeEach(async () => {
    userRepository = { findByProviderId: jest.fn(), findByEmail: jest.fn(), create: jest.fn(), update: jest.fn() };
    jwtService = { signAsync: jest.fn() };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        SocialLoginUseCase,
        { provide: USER_REPOSITORY, useValue: userRepository },
        { provide: JwtService, useValue: jwtService },
      ],
    }).compile();

    useCase = module.get<SocialLoginUseCase>(SocialLoginUseCase);
  });

  const dto = { provider: 'google', providerId: '123', email: 'a@b.com', name: 'A' };

  it('should login existing social user', async () => {
    userRepository.findByEmail.mockResolvedValue({ id: 'uuid' });
    jwtService.signAsync.mockResolvedValue('token');

    const result = await useCase.execute(dto);
    
    expect(result.accessToken).toBe('token');
    expect(userRepository.create).not.toHaveBeenCalled();
  });

  it('should create new user if not exists', async () => {
    userRepository.findByProviderId.mockResolvedValue(null);
    userRepository.findByEmail.mockResolvedValue(null);
    jwtService.signAsync.mockResolvedValue('token');

    const result = await useCase.execute(dto);

    expect(userRepository.create).toHaveBeenCalled();
    expect(result.accessToken).toBe('token');
  });
});
