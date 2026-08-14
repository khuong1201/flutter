import { Injectable, Inject } from '@nestjs/common';
import type { ILessonRepository } from '../../domain/repositories/lesson.repository.interface';
import { LESSON_REPOSITORY } from '../../domain/repositories/lesson.repository.interface';

export interface RoadmapLevelDto {
  id: number;
  code: string;
  name: string;
  language: string;
  lessons: RoadmapLessonDto[];
}

export interface RoadmapLessonDto {
  id: number;
  title: string;
  orderIndex: number;
  status: string;
  completedAt?: Date | null;
}

@Injectable()
export class GetRoadmapUseCase {
  constructor(
    @Inject(LESSON_REPOSITORY)
    private readonly lessonRepository: ILessonRepository,
  ) {}

  async execute(userId: string): Promise<RoadmapLevelDto[]> {
    const levels = await this.lessonRepository.findLevels();
    const userLessons = await this.lessonRepository.findUserLessons(userId);

    const userLessonMap = new Map();
    for (const ul of userLessons) {
      userLessonMap.set(ul.lessonId, ul);
    }

    const roadmap: RoadmapLevelDto[] = [];

    for (const level of levels) {
      const lessons = await this.lessonRepository.findLessonsByLevel(level.id);
      const lessonDtos: RoadmapLessonDto[] = lessons.map((lesson) => {
        const ul = userLessonMap.get(lesson.id);
        // If not in UserLesson, default to 'locked', unless it's the very first lesson (orderIndex 1, level 1)
        // Usually, unlocking is handled when level/language is chosen, or first is always unlocked.
        let status = ul ? ul.status : 'locked';

        // Simple default logic: first lesson is unlocked if no record exists
        if (!ul && lesson.orderIndex === 1 && level.code === 'N5') {
          status = 'unlocked';
        }

        return {
          id: lesson.id,
          title: lesson.title,
          orderIndex: lesson.orderIndex,
          status,
          completedAt: ul ? ul.completedAt : null,
        };
      });

      roadmap.push({
        id: level.id,
        code: level.code,
        name: level.name,
        language: level.language,
        lessons: lessonDtos,
      });
    }

    return roadmap;
  }
}
