import { Test, TestingModule } from '@nestjs/testing';
import { GetUserProfileUseCase } from './get-user-profile.use-case';
import { USER_REPOSITORY } from '../../domain/repositories/user.repository.interface';
import { AppException } from '../../../../common/exceptions/app.exception';

import { NotFoundException } from '@nestjs/common';

describe('GetUserProfileUseCase', () => {
  let useCase: GetUserProfileUseCase;
  let userRepository: any;

  beforeEach(async () => {
    userRepository = { findById: jest.fn() };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        GetUserProfileUseCase,
        { provide: USER_REPOSITORY, useValue: userRepository },
      ],
    }).compile();

    useCase = module.get<GetUserProfileUseCase>(GetUserProfileUseCase);
  });

  it('should throw NOT_FOUND if user not found', async () => {
    userRepository.findById.mockResolvedValue(null);
    await expect(useCase.execute('uuid')).rejects.toThrow(NotFoundException);
  });

  it('should return user domain model mapped properly', async () => {
    userRepository.findById.mockResolvedValue({
      id: 'uuid',
      email: 'a@b.com',
      passwordHash: 'hash',
      fullName: 'A'
    });
    const result = await useCase.execute('uuid');
    
    expect(result.id).toBe('uuid');
    expect(result.email).toBe('a@b.com');
    // Ensure we are returning User domain which strips password by default in UI mappings
    // but the use case just returns the User entity instance.
    expect(result).toBeDefined();
  });
});
