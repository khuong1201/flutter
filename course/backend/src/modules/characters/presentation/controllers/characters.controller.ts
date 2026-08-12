import {
  Controller,
  Get,
  Param,
  ParseIntPipe,
  Query,
  UseGuards,
  Redirect,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiBearerAuth,
  ApiQuery,
  ApiParam,
} from '@nestjs/swagger';
import { GetCharacterDetailsUseCase } from '../../application/use-cases/get-character-details.use-case';
import { SearchCharactersUseCase } from '../../application/use-cases/search-characters.use-case';
import { GetCharacterAudioUseCase } from '../../application/use-cases/get-character-audio.use-case';
import { JwtAuthGuard } from '../../../auth/presentation/guards/jwt-auth.guard';

@ApiTags('Characters')
@ApiBearerAuth()
@Controller('characters')
@UseGuards(JwtAuthGuard)
export class CharactersController {
  constructor(
    private readonly getCharacterDetailsUseCase: GetCharacterDetailsUseCase,
    private readonly searchCharactersUseCase: SearchCharactersUseCase,
    private readonly getCharacterAudioUseCase: GetCharacterAudioUseCase,
  ) {}

  @Get()
  @ApiOperation({ summary: 'Search characters by text or meaning' })
  @ApiQuery({
    name: 'q',
    required: false,
    type: String,
    description: 'Search query',
  })
  @ApiQuery({
    name: 'limit',
    required: false,
    type: Number,
    description: 'Limit results',
  })
  async searchCharacters(
    @Query('q') query: string,
    @Query('limit') limit: number = 10,
  ) {
    return this.searchCharactersUseCase.execute(
      query || '',
      Number(limit) || 10,
    );
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get character details by ID' })
  @ApiParam({ name: 'id', type: Number, description: 'Character ID' })
  async getCharacter(@Param('id', ParseIntPipe) id: number) {
    return this.getCharacterDetailsUseCase.execute(id);
  }

  @Get(':id/audio')
  @ApiOperation({ summary: 'Get audio URL for a character (lazy cached)' })
  @ApiParam({ name: 'id', description: 'Character ID', type: Number })
  @Redirect()
  async getCharacterAudio(@Param('id', ParseIntPipe) id: number) {
    const { url } = await this.getCharacterAudioUseCase.execute(id);
    return { url };
  }
}
