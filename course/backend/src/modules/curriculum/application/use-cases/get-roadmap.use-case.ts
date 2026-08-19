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

  async execute(userId: string, language?: string): Promise<RoadmapLevelDto[]> {
    let levels = await this.lessonRepository.findLevels();
    
    // Filter by language if provided
    if (language) {
      levels = levels.filter(l => l.language === language);
    }

    const userLessons = await this.lessonRepository.findUserLessons(userId);

    const userLessonMap = new Map();
    for (const ul of userLessons) {
      userLessonMap.set(ul.lessonId, ul);
    }

    const roadmap: RoadmapLevelDto[] = [];
    let previousLessonCompleted = false;
    let isFirstLessonOverall = true;

    for (const level of levels) {
      const lessons = await this.lessonRepository.findLessonsByLevel(level.id);
      const lessonDtos: RoadmapLessonDto[] = lessons.map((lesson) => {
        const ul = userLessonMap.get(lesson.id);
        let status = ul ? ul.status : 'locked';

        // Unlock first lesson always for the selected language
        if (isFirstLessonOverall && status === 'locked') {
          status = 'unlocked';
        }
        isFirstLessonOverall = false;

        // If previous lesson was completed, unlock this one
        if (previousLessonCompleted && status === 'locked') {
          status = 'unlocked';
        }

        previousLessonCompleted = status === 'completed';

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
