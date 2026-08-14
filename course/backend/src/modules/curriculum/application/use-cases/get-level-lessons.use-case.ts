import { Injectable, Inject, NotFoundException } from '@nestjs/common';
import type { ILevelRepository } from '../../domain/repositories/level.repository.interface';
import { LEVEL_REPOSITORY } from '../../domain/repositories/level.repository.interface';

@Injectable()
export class GetLevelLessonsUseCase {
  constructor(
    @Inject(LEVEL_REPOSITORY)
    private readonly levelRepository: ILevelRepository,
  ) {}

  async execute(levelId: number): Promise<any[]> {
    return this.levelRepository.findLessonsByLevel(levelId);
  }
}
