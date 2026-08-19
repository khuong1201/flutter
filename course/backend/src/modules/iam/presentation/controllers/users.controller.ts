import {
  Controller,
  Get,
  Put,
  Body,
  Query,
  UseGuards,
  Request,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiBearerAuth,
  ApiQuery,
  ApiResponse,
} from '@nestjs/swagger';
import { GetUserProfileUseCase } from '../../application/use-cases/get-user-profile.use-case';
import { DeleteAccountUseCase } from '../../application/use-cases/delete-account.use-case';
import {
  UpdateProfileUseCase,
  UpdateProfileDto,
} from '../../application/use-cases/update-profile.use-case';
import { GetLeaderboardUseCase } from '../../application/use-cases/get-leaderboard.use-case';
import { JwtAuthGuard } from '../guards/jwt-auth.guard';
import { UserResponseDto } from '../../application/dto/user-response.dto';
import { Delete } from '@nestjs/common';

@ApiTags('Users')
@ApiBearerAuth()
@Controller('users')
export class UsersController {
  constructor(
    private readonly getUserProfileUseCase: GetUserProfileUseCase,
    private readonly updateProfileUseCase: UpdateProfileUseCase,
    private readonly getLeaderboardUseCase: GetLeaderboardUseCase,
    private readonly deleteAccountUseCase: DeleteAccountUseCase,
  ) {}

  @Get('profile')
  @UseGuards(JwtAuthGuard)
  @ApiOperation({ summary: 'Get current user profile' })
  @ApiResponse({ status: 200, description: 'User profile retrieved successfully', type: UserResponseDto })
  async getProfile(@Request() req: any): Promise<UserResponseDto> {
    const userId = req.user.id;
    return this.getUserProfileUseCase.execute(userId);
  }

  @Put('profile')
  @UseGuards(JwtAuthGuard)
  @ApiOperation({ summary: 'Update current user profile' })
  @ApiResponse({ status: 200, description: 'User profile updated successfully', type: UserResponseDto })
  async updateProfile(@Request() req: any, @Body() data: UpdateProfileDto): Promise<UserResponseDto> {
    const userId = req.user.id;
    return this.updateProfileUseCase.execute(userId, data);
  }

  @Get('leaderboard')
  @ApiOperation({ summary: 'Get global leaderboard by XP' })
  @ApiQuery({
    name: 'limit',
    required: false,
    type: Number,
    description: 'Number of users to return',
  })
  @ApiResponse({ status: 200, description: 'Leaderboard retrieved successfully', type: [UserResponseDto] })
  async getLeaderboard(@Query('limit') limit: number = 10): Promise<UserResponseDto[]> {
    return this.getLeaderboardUseCase.execute(Number(limit) || 10);
  }

  @Delete('profile')
  @UseGuards(JwtAuthGuard)
  @ApiOperation({ summary: 'Delete current user account and all related data' })
  @ApiResponse({ status: 200, description: 'Account deleted successfully' })
  async deleteAccount(@Request() req: any): Promise<{ success: boolean }> {
    const userId = req.user.id;
    await this.deleteAccountUseCase.execute(userId);
    return { success: true };
  }
}

