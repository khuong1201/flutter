import { Test, TestingModule } from '@nestjs/testing';
import { LoginUseCase } from './login.use-case';
import { USER_REPOSITORY } from '../../domain/repositories/user.repository.interface';
import { JwtService } from '@nestjs/jwt';
import { AppException } from '../../../../common/exceptions/app.exception';
import * as bcrypt from 'bcrypt';

jest.mock('bcrypt', () => ({
  compare: jest.fn(),
}));

describe('LoginUseCase', () => {
  let useCase: LoginUseCase;
  let userRepository: any;
  let jwtService: any;

  beforeEach(async () => {
    userRepository = { findByEmail: jest.fn(), update: jest.fn() };
    jwtService = { signAsync: jest.fn() };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        LoginUseCase,
        { provide: USER_REPOSITORY, useValue: userRepository },
        { provide: JwtService, useValue: jwtService },
      ],
    }).compile();

    useCase = module.get<LoginUseCase>(LoginUseCase);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  const dto = { email: 'test@example.com', password: 'password123' };

  it('should throw NOT_FOUND if user does not exist', async () => {
    userRepository.findByEmail.mockResolvedValue(null);
    await expect(useCase.execute(dto)).rejects.toThrow(AppException);
  });

  it('should throw UNAUTHORIZED if user logged in via social', async () => {
    userRepository.findByEmail.mockResolvedValue({ provider: 'google' });
    await expect(useCase.execute(dto)).rejects.toThrow(AppException);
  });

  it('should throw UNAUTHORIZED if password mismatch', async () => {
    userRepository.findByEmail.mockResolvedValue({ passwordHash: 'hash' });
    (bcrypt.compare as jest.Mock).mockResolvedValue(false);
    await expect(useCase.execute(dto)).rejects.toThrow(AppException);
  });

  it('should return tokens on success', async () => {
    const mockUser = { id: 'uuid', email: 'test@example.com', passwordHash: 'hash' };
    userRepository.findByEmail.mockResolvedValue(mockUser);
    (bcrypt.compare as jest.Mock).mockResolvedValue(true);
    jwtService.signAsync.mockResolvedValue('mock-token');

    const result = await useCase.execute(dto);
    
    expect(result.accessToken).toBe('mock-token');
    expect(result.refreshToken).toBe('mock-token');
    expect(jwtService.signAsync).toHaveBeenCalledTimes(2);
  });
});
