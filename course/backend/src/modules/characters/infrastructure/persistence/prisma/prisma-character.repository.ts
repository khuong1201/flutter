import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../../../database/prisma.service';
import type { ICharacterRepository } from '../../../domain/repositories/character.repository.interface';
import { Character } from '../../../domain/entities/character.entity';
import { CharacterMapper } from '../../mappers/character.mapper';

@Injectable()
export class PrismaCharacterRepository implements ICharacterRepository {
  constructor(private readonly prisma: PrismaService) {}

  async findById(id: number): Promise<Character | null> {
    const character = await this.prisma.character.findUnique({
      where: { id },
      include: {
        radicals: {
          include: { radical: true },
        },
        vocabularies: true,
      },
    });

    if (!character) return null;
    return CharacterMapper.toDomain(character);
  }

  async findByText(text: string): Promise<Character | null> {
    const character = await this.prisma.character.findFirst({
      where: { charText: text },
      include: {
        radicals: {
          include: { radical: true },
        },
        vocabularies: true,
      },
    });

    if (!character) return null;
    return CharacterMapper.toDomain(character);
  }

  async findAll(limit: number = 20, offset: number = 0): Promise<Character[]> {
    const models = await this.prisma.character.findMany({
      include: {
        radicals: { include: { radical: true } },
        vocabularies: true,
      },
      take: limit,
      skip: offset,
    });
    return models.map(CharacterMapper.toDomain);
  }

  async search(query: string, limit: number = 10): Promise<Character[]> {
    const models = await this.prisma.character.findMany({
      where: {
        OR: [
          { charText: { contains: query, mode: 'insensitive' } },
          { meaning: { contains: query, mode: 'insensitive' } },
        ],
      },
      include: {
        radicals: { include: { radical: true } },
        vocabularies: true,
      },
      take: limit,
    });
    return models.map(CharacterMapper.toDomain);
  }

  async update(character: Character): Promise<Character> {
    const updated = await this.prisma.character.update({
      where: { id: character.id },
      data: {
        charText: character.charText,
        language: character.language,
        meaning: character.meaning,
        pronunciation: character.pronunciation,
        audioKey: character.audioKey,
        strokeData: character.strokeData as any,
      },
      include: {
        radicals: { include: { radical: true } },
        vocabularies: true,
      },
    });
    return CharacterMapper.toDomain(updated);
  }
}
