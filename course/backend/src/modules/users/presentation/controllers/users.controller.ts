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
} from '@nestjs/swagger';
import { GetUserProfileUseCase } from '../../application/use-cases/get-user-profile.use-case';
import {
  UpdateProfileUseCase,
  UpdateProfileDto,
} from '../../application/use-cases/update-profile.use-case';
import { GetLeaderboardUseCase } from '../../application/use-cases/get-leaderboard.use-case';
import { JwtAuthGuard } from '../../../auth/presentation/guards/jwt-auth.guard';

@ApiTags('Users')
@ApiBearerAuth()
@Controller('users')
export class UsersController {
  constructor(
    private readonly getUserProfileUseCase: GetUserProfileUseCase,
    private readonly updateProfileUseCase: UpdateProfileUseCase,
    private readonly getLeaderboardUseCase: GetLeaderboardUseCase,
  ) {}

  @Get('profile')
  @UseGuards(JwtAuthGuard)
  @ApiOperation({ summary: 'Get current user profile' })
  async getProfile(@Request() req: any) {
    const userId = req.user.id;
    return this.getUserProfileUseCase.execute(userId);
  }

  @Put('profile')
  @UseGuards(JwtAuthGuard)
  @ApiOperation({ summary: 'Update current user profile' })
  async updateProfile(@Request() req: any, @Body() data: UpdateProfileDto) {
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
  async getLeaderboard(@Query('limit') limit: number = 10) {
    return this.getLeaderboardUseCase.execute(Number(limit) || 10);
  }
}
