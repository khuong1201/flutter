import { Injectable, Inject } from '@nestjs/common';
import type { ILevelRepository } from '../../domain/repositories/level.repository.interface';
import { LEVEL_REPOSITORY } from '../../domain/repositories/level.repository.interface';
import { Level } from '../../domain/entities/level.entity';

@Injectable()
export class GetAllLevelsUseCase {
  constructor(
    @Inject(LEVEL_REPOSITORY)
    private readonly levelRepository: ILevelRepository,
  ) {}

  async execute(): Promise<Level[]> {
    return this.levelRepository.findAll();
  }
}
