import { ApiProperty } from '@nestjs/swagger';

export class ProgressStatsDto {
  @ApiProperty({ example: 50, description: 'Total characters learned' })
  totalLearned: number;

  @ApiProperty({ example: 15, description: 'Total reviews due today' })
  dueToday: number;
}
