import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

class StrokeDto {
  @ApiProperty({ description: 'SVG outline path for rendering the stroke' })
  outline_path: string;

  @ApiPropertyOptional({ description: 'Median path for tracing/evaluation' })
  median_path?: string;

  @ApiPropertyOptional({ description: 'Order index of the stroke' })
  order?: number;
}

export class CharacterResponseDto {
  @ApiProperty()
  id: number;

  @ApiProperty()
  charText: string;

  @ApiProperty()
  language: string;

  @ApiProperty()
  meaning: string;

  @ApiProperty({
    type: [StrokeDto],
    description:
      'List of strokes containing SVG paths and order for drawing/tracing',
  })
  strokeData: StrokeDto[];

  @ApiPropertyOptional()
  pronunciation?: any;

  @ApiPropertyOptional()
  audioKey?: string;

  @ApiPropertyOptional()
  radicals?: { radicalText: string; meaning: string }[];

  @ApiPropertyOptional()
  vocabularies?: { word: string; meaning: string; pronunciation: string }[];
}
