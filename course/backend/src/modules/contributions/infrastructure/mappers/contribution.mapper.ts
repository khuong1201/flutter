import { Contribution } from '../../domain/entities/contribution.entity';
import { UserContribution } from '@prisma/client';

export class ContributionMapper {
  static toDomain(prismaContribution: UserContribution): Contribution {
    return new Contribution(
      prismaContribution.id,
      prismaContribution.userId,
      prismaContribution.date,
      prismaContribution.count,
      prismaContribution.createdAt,
      prismaContribution.updatedAt,
    );
  }
}
