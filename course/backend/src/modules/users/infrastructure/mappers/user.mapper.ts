import { User as PrismaUser } from '@prisma/client';
import { User } from '../../domain/entities/user.entity';

export class UserMapper {
  static toDomain(prismaUser: PrismaUser): User {
    return new User(
      prismaUser.id,
      prismaUser.email,
      prismaUser.fullName,
      prismaUser.targetLanguage,
      prismaUser.xpPoints,
      prismaUser.avatarUrl,
      prismaUser.targetLevel,
      prismaUser.provider,
      prismaUser.providerId,
      prismaUser.currentStreak,
      prismaUser.longestStreak,
      prismaUser.lastStudyDate,
      prismaUser.passwordHash,
      prismaUser.createdAt,
      prismaUser.updatedAt,
    );
  }

  static toPersistence(user: User): PrismaUser {
    return {
      id: user.id,
      email: user.email,
      fullName: user.fullName,
      targetLanguage: user.targetLanguage,
      xpPoints: user.xpPoints,
      avatarUrl: user.avatarUrl ?? null,
      targetLevel: user.targetLevel ?? null,
      provider: user.provider ?? null,
      providerId: user.providerId ?? null,
      currentStreak: user.currentStreak,
      longestStreak: user.longestStreak,
      lastStudyDate: user.lastStudyDate ?? null,
      passwordHash: user.passwordHash ?? null,
      createdAt: user.createdAt || new Date(),
      updatedAt: user.updatedAt || new Date(),
    };
  }
}
