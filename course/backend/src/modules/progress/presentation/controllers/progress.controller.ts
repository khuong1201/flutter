import { Controller, Get, UseGuards, Request } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { GetDueReviewsUseCase } from '../../application/use-cases/get-due-reviews.use-case';
import { GetProgressStatsUseCase } from '../../application/use-cases/get-progress-stats.use-case';
import { JwtAuthGuard } from '../../../auth/presentation/guards/jwt-auth.guard';

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
  async getDueReviews(@Request() req: any) {
    return this.getDueReviewsUseCase.execute(req.user.id);
  }

  @Get('stats')
  @ApiOperation({ summary: 'Get user learning statistics' })
  async getStats(@Request() req: any) {
    return this.getProgressStatsUseCase.execute(req.user.id);
  }
}
