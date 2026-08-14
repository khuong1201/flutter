import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { LevelDto } from './level.dto';

export class LessonDto {
  @ApiProperty({ example: 1 })
  id: number;

  @ApiProperty({ example: 1 })
  levelId: number;

  @ApiProperty({ example: 'Lesson 1' })
  title: string;

  @ApiProperty({ example: 1 })
  orderIndex: number;

  @ApiPropertyOptional({ example: true, description: 'Whether the current user has completed this lesson' })
  isCompleted?: boolean;
}

export class RoadmapLevelDto extends LevelDto {
  @ApiProperty({ type: [LessonDto] })
  lessons: LessonDto[];
}
