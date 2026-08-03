import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../../../database/prisma.service';
import type { ILessonRepository } from '../../../domain/repositories/lesson.repository.interface';
import { Level } from '../../../domain/entities/level.entity';
import { Lesson } from '../../../domain/entities/lesson.entity';
import { LessonMapper } from '../../mappers/lesson.mapper';

@Injectable()
export class PrismaLessonRepository implements ILessonRepository {
  constructor(private readonly prisma: PrismaService) {}

  async findLevels(): Promise<Level[]> {
    const levels = await this.prisma.level.findMany({
      orderBy: { id: 'asc' },
    });
    return levels.map(LessonMapper.toLevelDomain);
  }

  async findLessonsByLevel(levelId: number): Promise<Lesson[]> {
    const lessons = await this.prisma.lesson.findMany({
      where: { levelId },
      orderBy: { orderIndex: 'asc' },
    });
    return lessons.map(LessonMapper.toLessonDomain);
  }

  async findUserLessons(userId: string): Promise<{ lessonId: number; status: string; completedAt: Date | null; }[]> {
    return this.prisma.userLesson.findMany({
      where: { userId },
      select: {
        lessonId: true,
        status: true,
        completedAt: true,
      }
    });
  }

  async findCharactersByLesson(lessonId: number): Promise<any[]> {
    const records = await this.prisma.lessonCharacter.findMany({
      where: { lessonId },
      include: {
        character: true,
      },
      orderBy: { orderIndex: 'asc' },
    });
    return records.map(r => r.character);
  }
}
