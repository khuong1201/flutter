import { Controller, Get, UseGuards, Request, Query } from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiBearerAuth,
  ApiQuery,
  ApiResponse,
} from '@nestjs/swagger';
import { GetContributionsUseCase } from '../../application/use-cases/get-contributions.use-case';
import { JwtAuthGuard } from '../../../iam/presentation/guards/jwt-auth.guard';
import { ContributionDto } from '../../application/dto/contribution.dto';

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
  @ApiResponse({ status: 200, description: 'List of contributions (Github style)', type: [ContributionDto] })
  async getContributions(@Request() req: any, @Query('year') year?: string): Promise<ContributionDto[]> {
    return this.getContributionsUseCase.execute(
      req.user.id,
      year ? parseInt(year, 10) : undefined,
    ) as any;
  }
}
