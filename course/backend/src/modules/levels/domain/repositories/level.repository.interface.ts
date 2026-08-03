import { Level } from '../entities/level.entity';

export const LEVEL_REPOSITORY = 'LEVEL_REPOSITORY';

export interface ILevelRepository {
  findAll(): Promise<Level[]>;
  findLessonsByLevel(levelId: number): Promise<any[]>;
}
