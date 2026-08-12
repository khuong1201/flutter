import { Controller, Get, UseGuards, Request, Query } from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiBearerAuth,
  ApiQuery,
} from '@nestjs/swagger';
import { GetContributionsUseCase } from '../../application/use-cases/get-contributions.use-case';
import { JwtAuthGuard } from '../../../auth/presentation/guards/jwt-auth.guard';

@ApiTags('Contributions')
@ApiBearerAuth()
@Controller('contributions')
export class ContributionsController {
  constructor(
    private readonly getContributionsUseCase: GetContributionsUseCase,
  ) {}

  @Get()
  @UseGuards(JwtAuthGuard)
  @ApiOperation({ summary: 'Get user contribution graph data' })
  @ApiQuery({
    name: 'year',
    required: false,
    type: Number,
    description: 'Optional year to fetch',
  })
  async getContributions(@Request() req: any, @Query('year') year?: string) {
    return this.getContributionsUseCase.execute(
      req.user.id,
      year ? parseInt(year, 10) : undefined,
    );
  }
}
