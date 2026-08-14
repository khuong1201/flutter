import { Level as PrismaLevel, Lesson as PrismaLesson } from '@prisma/client';
import { Level } from '../../domain/entities/level.entity';
import { Lesson } from '../../domain/entities/lesson.entity';

export class LessonMapper {
  static toLevelDomain(prismaLevel: PrismaLevel): Level {
    return new Level(
      prismaLevel.id,
      prismaLevel.code,
      prismaLevel.name,
      prismaLevel.language,
    );
  }

  static toLessonDomain(prismaLesson: PrismaLesson): Lesson {
    return new Lesson(
      prismaLesson.id,
      prismaLesson.levelId,
      prismaLesson.title,
      prismaLesson.orderIndex,
    );
  }
}
