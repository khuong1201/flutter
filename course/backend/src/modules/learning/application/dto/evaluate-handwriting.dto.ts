import { ApiProperty } from '@nestjs/swagger';
import { IsArray, IsNumber, ValidateNested, ArrayMinSize } from 'class-validator';
import { Type } from 'class-transformer';

export class PointDto {
  @ApiProperty({ example: 10.5 })
  @IsNumber()
  x: number;

  @ApiProperty({ example: 20.5 })
  @IsNumber()
  y: number;
}

export class EvaluateHandwritingDto {
  @ApiProperty({ example: 1, description: 'Character ID to evaluate against' })
  @IsNumber()
  characterId: number;

  @ApiProperty({
    example: [[{ x: 10, y: 20 }, { x: 15, y: 25 }]],
    description: 'Array of strokes, where each stroke is an array of points'
  })
  @IsArray()
  @ArrayMinSize(1)
  userStrokes: { x: number; y: number }[][];
}
