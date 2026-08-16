import { Test, TestingModule } from '@nestjs/testing';
import { UpdateProfileUseCase } from './update-profile.use-case';
import { USER_REPOSITORY } from '../../domain/repositories/user.repository.interface';
import { AppException } from '../../../../common/exceptions/app.exception';

import { NotFoundException } from '@nestjs/common';

describe('UpdateProfileUseCase', () => {
  let useCase: UpdateProfileUseCase;
  let userRepository: any;

  beforeEach(async () => {
    userRepository = { findById: jest.fn(), update: jest.fn() };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        UpdateProfileUseCase,
        { provide: USER_REPOSITORY, useValue: userRepository },
      ],
    }).compile();

    useCase = module.get<UpdateProfileUseCase>(UpdateProfileUseCase);
  });

  const dto = { fullName: 'New Name', targetLevel: 'N2', avatarUrl: 'link' };

  it('should throw NOT_FOUND if user not found', async () => {
    userRepository.findById.mockResolvedValue(null);
    await expect(useCase.execute('uuid', dto)).rejects.toThrow(NotFoundException);
  });

  it('should update user and return domain model without password', async () => {
    userRepository.findById.mockResolvedValue({ id: 'uuid', passwordHash: 'hash', fullName: 'Old Name' });
    
    await useCase.execute('uuid', dto);

    expect(userRepository.update).toHaveBeenCalled();
    const args = userRepository.update.mock.calls[0][1];
    expect(args.fullName).toBe('New Name');
    expect(args.targetLevel).toBe('N2');
  });
});
