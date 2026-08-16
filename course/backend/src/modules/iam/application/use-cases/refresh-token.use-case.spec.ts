import { Test, TestingModule } from '@nestjs/testing';
import { RefreshTokenUseCase } from './refresh-token.use-case';
import { USER_REPOSITORY } from '../../domain/repositories/user.repository.interface';
import { JwtService } from '@nestjs/jwt';
import { AppException } from '../../../../common/exceptions/app.exception';

describe('RefreshTokenUseCase', () => {
  let useCase: RefreshTokenUseCase;
  let userRepository: any;
  let jwtService: any;

  beforeEach(async () => {
    userRepository = { findById: jest.fn(), update: jest.fn() };
    jwtService = { verifyAsync: jest.fn(), signAsync: jest.fn() };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        RefreshTokenUseCase,
        { provide: USER_REPOSITORY, useValue: userRepository },
        { provide: JwtService, useValue: jwtService },
      ],
    }).compile();

    useCase = module.get<RefreshTokenUseCase>(RefreshTokenUseCase);
  });

  it('should throw UNAUTHORIZED if token verification fails', async () => {
    jwtService.verifyAsync.mockRejectedValue(new Error());
    await expect(useCase.execute({ refreshToken: 'bad' })).rejects.toThrow(AppException);
  });

  it('should throw NOT_FOUND if user not found', async () => {
    jwtService.verifyAsync.mockResolvedValue({ sub: 'user-1' });
    userRepository.findById.mockResolvedValue(null);
    await expect(useCase.execute({ refreshToken: 'token' })).rejects.toThrow(AppException);
  });

  it('should throw UNAUTHORIZED if token does not match DB', async () => {
    jwtService.verifyAsync.mockResolvedValue({ sub: 'user-1' });
    userRepository.findById.mockResolvedValue({ refreshToken: 'different' });
    await expect(useCase.execute({ refreshToken: 'token' })).rejects.toThrow(AppException);
  });

  it('should rotate tokens and update DB', async () => {
    jwtService.verifyAsync.mockResolvedValue({ sub: 'user-1' });
    userRepository.findById.mockResolvedValue({ id: 'user-1', refreshToken: 'token', email: 'test@mail' });
    jwtService.signAsync.mockResolvedValue('new-token');

    const result = await useCase.execute({ refreshToken: 'token' });
    
    expect(result.accessToken).toBe('new-token');
    expect(userRepository.update).toHaveBeenCalled();
  });
});
