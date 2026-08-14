import { ApiProperty } from '@nestjs/swagger';

export class LevelDto {
  @ApiProperty({ example: 1 })
  id: number;

  @ApiProperty({ example: 'N5' })
  code: string;

  @ApiProperty({ example: 'JLPT N5' })
  name: string;

  @ApiProperty({ example: 'ja' })
  language: string;
}
