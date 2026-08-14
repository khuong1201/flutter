import { ApiProperty } from '@nestjs/swagger';

export class UserResponseDto {
  @ApiProperty({ example: 'uuid-1234', description: 'User unique ID' })
  id: string;

  @ApiProperty({ example: 'test@example.com' })
  email: string;

  @ApiProperty({ example: 'Test User' })
  fullName: string;

  @ApiProperty({ example: 'ja', description: 'Target language code' })
  targetLanguage: string;

  @ApiProperty({ example: 'N5', required: false })
  targetLevel?: string;

  @ApiProperty({ example: 'https://avatar.com/1.png', required: false })
  avatarUrl?: string;

  @ApiProperty({ example: 100, description: 'User experience points' })
  xpPoints: number;

  @ApiProperty({ example: 5, description: 'Current consecutive study days' })
  currentStreak: number;

  @ApiProperty({ example: 10, description: 'Longest consecutive study days' })
  longestStreak: number;
}
