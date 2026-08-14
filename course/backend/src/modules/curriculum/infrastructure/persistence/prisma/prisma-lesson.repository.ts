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

  async findUserLessons(
    userId: string,
  ): Promise<{ lessonId: number; status: string; completedAt: Date | null }[]> {
    return this.prisma.userLesson.findMany({
      where: { userId },
      select: {
        lessonId: true,
        status: true,
        completedAt: true,
      },
    });
  }

  async findCharactersByLesson(lessonId: number): Promise<any[]> {
    const records = await this.prisma.lessonVocabulary.findMany({
      where: { lessonId },
      include: {
        vocabulary: {
          include: {
            characters: { include: { character: true }, orderBy: { orderIndex: 'asc' } }
          }
        }
      },
      orderBy: { orderIndex: 'asc' },
    });
    const chars: any[] = [];
    for (const r of records) {
      if (r.vocabulary && r.vocabulary.characters) {
        for (const vc of r.vocabulary.characters) {
          if (vc.character && !chars.find(c => c.id === vc.character.id)) {
            chars.push(vc.character);
          }
        }
      }
    }
    return chars;
  }

  async completeUserLesson(userId: string, lessonId: number): Promise<void> {
    await this.prisma.userLesson.upsert({
      where: {
        userId_lessonId: {
          userId,
          lessonId,
        },
      },
      update: {
        status: 'completed',
        completedAt: new Date(),
      },
      create: {
        userId,
        lessonId,
        status: 'completed',
        completedAt: new Date(),
      },
    });
  }
}
