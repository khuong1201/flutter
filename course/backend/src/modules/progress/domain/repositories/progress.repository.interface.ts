import { UserProgress } from '../entities/user-progress.entity';

export const PROGRESS_REPOSITORY = 'PROGRESS_REPOSITORY';

export interface IProgressRepository {
  findByUserAndCharacter(userId: string, characterId: number): Promise<UserProgress | null>;
  findDueReviews(userId: string, date: Date): Promise<UserProgress[]>;
  getStats(userId: string): Promise<{ totalLearned: number, dueReviews: number, totalXp: number, currentStreak: number, longestStreak: number }>;
  save(progress: UserProgress): Promise<UserProgress>;
}
