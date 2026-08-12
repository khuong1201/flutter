import {
  Controller,
  Post,
  Body,
  UseGuards,
  Request,
  Get,
  Query,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiBearerAuth,
  ApiQuery,
} from '@nestjs/swagger';
import {
  SubmitReviewResultUseCase,
  SubmitReviewDto,
} from '../../application/use-cases/submit-review-result.use-case';
import { JwtAuthGuard } from '../../../auth/presentation/guards/jwt-auth.guard';
import { GenerateQuizUseCase } from '../../application/use-cases/generate-quiz.use-case';

@ApiTags('Practice')
@ApiBearerAuth()
@Controller('practice')
export class PracticeController {
  constructor(
    private readonly submitReviewResultUseCase: SubmitReviewResultUseCase,
    private readonly generateQuizUseCase: GenerateQuizUseCase,
  ) {}

  @Get('quiz')
  @UseGuards(JwtAuthGuard)
  @ApiOperation({ summary: 'Generate a quiz (random or by lesson)' })
  @ApiQuery({
    name: 'lessonId',
    required: false,
    type: Number,
    description: 'Optional lesson ID',
  })
  @ApiQuery({
    name: 'limit',
    required: false,
    type: Number,
    description: 'Number of questions',
  })
  async getQuiz(
    @Query('lessonId') lessonId?: number,
    @Query('limit') limit: number = 10,
  ) {
    return this.generateQuizUseCase.execute(
      lessonId ? Number(lessonId) : undefined,
      Number(limit) || 10,
    );
  }

  @Post('review')
  @UseGuards(JwtAuthGuard)
  @ApiOperation({ summary: 'Submit SRS review result for a character' })
  async submitReview(@Request() req: any, @Body() dto: SubmitReviewDto) {
    // Get user id from JWT
    const userId = req.user.id;
    await this.submitReviewResultUseCase.execute(userId, dto);
    return { success: true };
  }
}
