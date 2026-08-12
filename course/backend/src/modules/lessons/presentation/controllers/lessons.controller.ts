import { Controller, Get, UseGuards, Request } from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiBearerAuth,
  ApiParam,
} from '@nestjs/swagger';
import { GetLevelsUseCase } from '../../application/use-cases/get-levels.use-case';
import { GetRoadmapUseCase } from '../../application/use-cases/get-roadmap.use-case';
import { GetLessonCharactersUseCase } from '../../application/use-cases/get-lesson-characters.use-case';
import { CompleteLessonUseCase } from '../../application/use-cases/complete-lesson.use-case';
import { JwtAuthGuard } from '../../../auth/presentation/guards/jwt-auth.guard';
import { Param, ParseIntPipe, Post } from '@nestjs/common';

@ApiTags('Lessons')
@ApiBearerAuth()
@Controller('lessons')
export class LessonsController {
  constructor(
    private readonly getLevelsUseCase: GetLevelsUseCase,
    private readonly getRoadmapUseCase: GetRoadmapUseCase,
    private readonly getLessonCharactersUseCase: GetLessonCharactersUseCase,
    private readonly completeLessonUseCase: CompleteLessonUseCase,
  ) {}

  @Get('levels')
  @UseGuards(JwtAuthGuard)
  @ApiOperation({ summary: 'Get all levels (e.g., N5, N4)' })
  async getLevels() {
    return this.getLevelsUseCase.execute();
  }

  @Get('roadmap')
  @UseGuards(JwtAuthGuard)
  @ApiOperation({ summary: 'Get learning roadmap with user progress' })
  async getRoadmap(@Request() req: any) {
    return this.getRoadmapUseCase.execute(req.user.id);
  }

  @Get(':id/characters')
  @UseGuards(JwtAuthGuard)
  @ApiOperation({ summary: 'Get characters for a lesson' })
  @ApiParam({ name: 'id', description: 'Lesson ID', type: Number })
  async getLessonCharacters(@Param('id', ParseIntPipe) id: number) {
    return this.getLessonCharactersUseCase.execute(id);
  }

  @Post(':id/complete')
  @UseGuards(JwtAuthGuard)
  @ApiOperation({
    summary: 'Mark a lesson as completed and record contribution',
  })
  @ApiParam({ name: 'id', description: 'Lesson ID', type: Number })
  async completeLesson(
    @Request() req: any,
    @Param('id', ParseIntPipe) id: number,
  ) {
    await this.completeLessonUseCase.execute(req.user.id, id);
    return { success: true };
  }
}
