import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../../../database/prisma.service';
import type { IUserRepository } from '../../../domain/repositories/user.repository.interface';
import { User } from '../../../domain/entities/user.entity';
import { UserMapper } from '../../mappers/user.mapper';

@Injectable()
export class PrismaUserRepository implements IUserRepository {
  constructor(private readonly prisma: PrismaService) {}

  async findById(id: string): Promise<User | null> {
    const user = await this.prisma.user.findUnique({ where: { id } });
    if (!user) return null;
    return UserMapper.toDomain(user);
  }

  async findByEmail(email: string): Promise<User | null> {
    const userModel = await this.prisma.user.findUnique({
      where: { email },
    });

    if (!userModel) {
      return null;
    }

    return UserMapper.toDomain(userModel);
  }

  async findTopByXp(limit: number): Promise<User[]> {
    const userModels = await this.prisma.user.findMany({
      orderBy: { xpPoints: 'desc' },
      take: limit,
    });

    return userModels.map(UserMapper.toDomain);
  }

  async create(user: User): Promise<User> {
    const data = UserMapper.toPersistence(user);
    const createdUser = await this.prisma.user.create({ data });
    return UserMapper.toDomain(createdUser);
  }

  async update(id: string, data: Partial<User>): Promise<User> {
    const updateData: any = { ...data };
    
    const updatedUser = await this.prisma.user.update({
      where: { id },
      data: updateData,
    });
    return UserMapper.toDomain(updatedUser);
  }
}
