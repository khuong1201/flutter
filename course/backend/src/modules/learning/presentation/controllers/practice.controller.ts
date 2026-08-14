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
  ApiResponse,
} from '@nestjs/swagger';
import {
  SubmitReviewResultUseCase,
  SubmitReviewDto,
} from '../../application/use-cases/submit-review-result.use-case';
import { JwtAuthGuard } from '../../../iam/presentation/guards/jwt-auth.guard';
import { GenerateQuizUseCase, QuizQuestionDto } from '../../application/use-cases/generate-quiz.use-case';
import { EvaluateHandwritingUseCase } from '../../application/use-cases/evaluate-handwriting.use-case';
import { EvaluateHandwritingDto } from '../../application/dto/evaluate-handwriting.dto';

@ApiTags('Practice')
@ApiBearerAuth()
@Controller('practice')
export class PracticeController {
  constructor(
    private readonly submitReviewResultUseCase: SubmitReviewResultUseCase,
    private readonly generateQuizUseCase: GenerateQuizUseCase,
    private readonly evaluateHandwritingUseCase: EvaluateHandwritingUseCase,
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
  @ApiResponse({ status: 200, description: 'Generated quiz questions', type: [QuizQuestionDto] })
  async getQuiz(
    @Query('lessonId') lessonId?: number,
    @Query('limit') limit: number = 10,
  ): Promise<QuizQuestionDto[]> {
    return this.generateQuizUseCase.execute(
      lessonId ? Number(lessonId) : undefined,
      Number(limit) || 10,
    );
  }

  @Post('review')
  @UseGuards(JwtAuthGuard)
  @ApiOperation({ summary: 'Submit SRS review result for a character' })
  @ApiResponse({ status: 201, description: 'Review logged successfully', schema: { properties: { success: { type: 'boolean' } } } })
  async submitReview(@Request() req: any, @Body() dto: SubmitReviewDto) {
    const userId = req.user.id;
    await this.submitReviewResultUseCase.execute(userId, dto);
    return { success: true };
  }

  @Post('evaluate-handwriting')
  @UseGuards(JwtAuthGuard)
  @ApiOperation({ summary: 'Evaluate handwriting strokes against median path' })
  @ApiResponse({
    status: 200,
    description: 'Score and feedback',
    schema: {
      properties: {
        score: { type: 'number' },
        feedback: { type: 'string' }
      }
    }
  })
  async evaluateHandwriting(@Body() dto: EvaluateHandwritingDto) {
    return this.evaluateHandwritingUseCase.execute(dto);
  }
}
