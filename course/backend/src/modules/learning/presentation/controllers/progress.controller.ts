import { Controller, Get, UseGuards, Request } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiResponse } from '@nestjs/swagger';
import { GetDueReviewsUseCase } from '../../application/use-cases/get-due-reviews.use-case';
import { GetProgressStatsUseCase } from '../../application/use-cases/get-progress-stats.use-case';
import { JwtAuthGuard } from '../../../iam/presentation/guards/jwt-auth.guard';
import { UserProgressDto } from '../../application/dto/user-progress.dto';
import { ProgressStatsDto } from '../../application/dto/progress-stats.dto';

@ApiTags('Progress')
@ApiBearerAuth()
@Controller('progress')
@UseGuards(JwtAuthGuard)
export class ProgressController {
  constructor(
    private readonly getDueReviewsUseCase: GetDueReviewsUseCase,
    private readonly getProgressStatsUseCase: GetProgressStatsUseCase,
  ) {}

  @Get('due')
  @ApiOperation({ summary: 'Get SRS reviews due for today' })
  @ApiResponse({ status: 200, description: 'List of due reviews', type: [UserProgressDto] })
  async getDueReviews(@Request() req: any): Promise<UserProgressDto[]> {
    return this.getDueReviewsUseCase.execute(req.user.id) as any;
  }

  @Get('stats')
  @ApiOperation({ summary: 'Get user learning statistics' })
  @ApiResponse({ status: 200, description: 'User learning stats', type: ProgressStatsDto })
  async getStats(@Request() req: any): Promise<ProgressStatsDto> {
    return this.getProgressStatsUseCase.execute(req.user.id) as any;
  }
}
