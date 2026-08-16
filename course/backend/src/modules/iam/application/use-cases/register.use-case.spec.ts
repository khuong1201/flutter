import { Test, TestingModule } from '@nestjs/testing';
import { RegisterUseCase } from './register.use-case';
import { USER_REPOSITORY } from '../../domain/repositories/user.repository.interface';
import { JwtService } from '@nestjs/jwt';
import { AppException } from '../../../../common/exceptions/app.exception';
import * as bcrypt from 'bcrypt';

jest.mock('bcrypt', () => ({
  genSalt: jest.fn(),
  hash: jest.fn(),
}));

describe('RegisterUseCase', () => {
  let useCase: RegisterUseCase;
  let userRepository: any;
  let jwtService: any;

  beforeEach(async () => {
    userRepository = { findByEmail: jest.fn(), create: jest.fn() };
    jwtService = { signAsync: jest.fn() };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        RegisterUseCase,
        { provide: USER_REPOSITORY, useValue: userRepository },
        { provide: JwtService, useValue: jwtService },
      ],
    }).compile();

    useCase = module.get<RegisterUseCase>(RegisterUseCase);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  const dto = { email: 'test@example.com', password: 'pw123', fullName: 'Tester' };

  it('should throw USER_EXISTS if email already taken', async () => {
    userRepository.findByEmail.mockResolvedValue({});
    await expect(useCase.execute(dto)).rejects.toThrow(AppException);
  });

  it('should create user and return tokens', async () => {
    userRepository.findByEmail.mockResolvedValue(null);
    (bcrypt.genSalt as jest.Mock).mockResolvedValue('salt');
    (bcrypt.hash as jest.Mock).mockResolvedValue('hash');
    jwtService.signAsync.mockResolvedValue('token');

    const result = await useCase.execute(dto);

    expect(userRepository.create).toHaveBeenCalled();
    const savedUser = userRepository.create.mock.calls[0][0];
    expect(savedUser.email).toBe(dto.email);
    expect(savedUser.passwordHash).toBe('hash');
    
    expect(result.accessToken).toBe('token');
    expect(result.refreshToken).toBe('token');
  });
});
