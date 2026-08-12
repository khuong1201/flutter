import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../../../database/prisma.service';
import type { ILevelRepository } from '../../../domain/repositories/level.repository.interface';
import { Level } from '../../../domain/entities/level.entity';

@Injectable()
export class PrismaLevelRepository implements ILevelRepository {
  constructor(private readonly prisma: PrismaService) {}

  async findAll(): Promise<Level[]> {
    const models = await this.prisma.level.findMany({
      orderBy: { id: 'asc' },
    });
    return models.map((m) => new Level(m.id, m.code, m.name, m.language));
  }

  async findLessonsByLevel(levelId: number): Promise<any[]> {
    return this.prisma.lesson.findMany({
      where: { levelId },
      orderBy: { orderIndex: 'asc' },
    });
  }
}
