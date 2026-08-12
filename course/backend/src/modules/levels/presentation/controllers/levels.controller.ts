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
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../../../auth/presentation/guards/jwt-auth.guard';
import { GetAllLevelsUseCase } from '../../application/use-cases/get-all-levels.use-case';
import { GetLevelLessonsUseCase } from '../../application/use-cases/get-level-lessons.use-case';

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
  async getAllLevels() {
    return this.getAllLevelsUseCase.execute();
  }

  @Get(':id/lessons')
  @ApiOperation({ summary: 'Get all lessons for a specific level' })
  @ApiParam({ name: 'id', description: 'Level ID', type: Number })
  async getLevelLessons(@Param('id', ParseIntPipe) id: number) {
    return this.getLevelLessonsUseCase.execute(id);
  }
}
