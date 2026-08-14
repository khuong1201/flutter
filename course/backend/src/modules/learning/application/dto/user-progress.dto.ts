import { ApiProperty } from '@nestjs/swagger';

export class UserProgressDto {
  @ApiProperty({ example: 'uuid', description: 'User ID' })
  userId: string;

  @ApiProperty({ example: 1, description: 'Character ID' })
  characterId: number;

  @ApiProperty({ example: 2.5, description: 'Easiness factor for SM2 algorithm' })
  easinessFactor: number;

  @ApiProperty({ example: 10, description: 'Interval in days before next review' })
  interval: number;

  @ApiProperty({ example: 3, description: 'Number of successful repetitions' })
  repetitions: number;

  @ApiProperty({ example: '2026-08-15T00:00:00.000Z', description: 'Next review date' })
  nextReviewDate: Date;
}
