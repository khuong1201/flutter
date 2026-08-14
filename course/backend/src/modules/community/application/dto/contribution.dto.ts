import { ApiProperty } from '@nestjs/swagger';

export class ContributionDto {
  @ApiProperty({ example: 'uuid', description: 'Contribution ID' })
  id: string;

  @ApiProperty({ example: 'uuid', description: 'User ID' })
  userId: string;

  @ApiProperty({ example: '2026-08-15T00:00:00.000Z', description: 'Date of contribution' })
  date: Date;

  @ApiProperty({ example: 5, description: 'Number of actions (e.g. lessons completed) on this date' })
  count: number;
}
