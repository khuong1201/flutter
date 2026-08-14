import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString } from 'class-validator';

export class RefreshTokenDto {
  @ApiProperty({
    example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.refresh...',
    description: 'The refresh token obtained during login',
  })
  @IsString()
  @IsNotEmpty()
  refreshToken: string;
}
