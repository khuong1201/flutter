import { Test, TestingModule } from '@nestjs/testing';
import { LevelsController } from './levels.controller';

import { GetAllLevelsUseCase } from '../../application/use-cases/get-all-levels.use-case';
import { GetLevelLessonsUseCase } from '../../application/use-cases/get-level-lessons.use-case';
import { JwtAuthGuard } from '../../../iam/presentation/guards/jwt-auth.guard';

describe('LevelsController', () => {
  let controller: LevelsController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [LevelsController],
      providers: [
        { provide: GetAllLevelsUseCase, useValue: { execute: jest.fn() } },
        { provide: GetLevelLessonsUseCase, useValue: { execute: jest.fn() } },
      ],
    })
      .overrideGuard(JwtAuthGuard)
      .useValue({ canActivate: () => true })
      .compile();

    controller = module.get<LevelsController>(LevelsController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
