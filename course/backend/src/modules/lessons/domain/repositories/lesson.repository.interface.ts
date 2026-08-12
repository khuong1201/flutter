import { Level } from '../entities/level.entity';
import { Lesson } from '../entities/lesson.entity';

export const LESSON_REPOSITORY = 'LESSON_REPOSITORY';

export interface ILessonRepository {
  findLevels(): Promise<Level[]>;
  findLessonsByLevel(levelId: number): Promise<Lesson[]>;
  findUserLessons(
    userId: string,
  ): Promise<{ lessonId: number; status: string; completedAt: Date | null }[]>;
  findCharactersByLesson(lessonId: number): Promise<any[]>;
  completeUserLesson(userId: string, lessonId: number): Promise<void>;
}
