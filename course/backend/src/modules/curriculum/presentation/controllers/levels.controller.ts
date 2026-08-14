import {
  Controller,
  Get,
  Param,
  ParseIntPipe,
  UseGuards,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiBearerAuth,
  ApiParam,
  ApiResponse,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../../../iam/presentation/guards/jwt-auth.guard';
import { GetAllLevelsUseCase } from '../../application/use-cases/get-all-levels.use-case';
import { GetLevelLessonsUseCase } from '../../application/use-cases/get-level-lessons.use-case';
import { LevelDto } from '../../application/dto/level.dto';
import { LessonDto } from '../../application/dto/lesson.dto';

@ApiTags('Levels')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('levels')
export class LevelsController {
  constructor(
    private readonly getAllLevelsUseCase: GetAllLevelsUseCase,
    private readonly getLevelLessonsUseCase: GetLevelLessonsUseCase,
  ) {}

  @Get()
  @ApiOperation({ summary: 'Get all levels' })
  @ApiResponse({ status: 200, description: 'List of all levels', type: [LevelDto] })
  async getAllLevels() {
    return this.getAllLevelsUseCase.execute();
  }

  @Get(':id/lessons')
  @ApiOperation({ summary: 'Get all lessons for a specific level' })
  @ApiParam({ name: 'id', description: 'Level ID', type: Number })
  @ApiResponse({ status: 200, description: 'List of lessons in a level', type: [LessonDto] })
  async getLevelLessons(@Param('id', ParseIntPipe) id: number): Promise<LessonDto[]> {
    return this.getLevelLessonsUseCase.execute(id) as any;
  }
}
