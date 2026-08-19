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
  ApiResponse,
} from '@nestjs/swagger';
import { GetCharacterDetailsUseCase } from '../../application/use-cases/get-character-details.use-case';
import { SearchCharactersUseCase } from '../../application/use-cases/search-characters.use-case';
import { GetCharacterAudioUseCase } from '../../application/use-cases/get-character-audio.use-case';
import { JwtAuthGuard } from '../../../iam/presentation/guards/jwt-auth.guard';
import { CharacterResponseDto } from '../../application/dto/character-response.dto';

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
  @ApiQuery({
    name: 'lang',
    required: false,
    type: String,
    description: 'Filter by language (e.g. ja or zh)',
  })
  @ApiResponse({ status: 200, description: 'Characters matching search query', type: [CharacterResponseDto] })
  async searchCharacters(
    @Query('q') query: string,
    @Query('limit') limit: number = 10,
    @Query('lang') lang?: string,
  ): Promise<CharacterResponseDto[]> {
    return this.searchCharactersUseCase.execute(
      query || '',
      Number(limit) || 10,
      lang,
    ) as any;
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get character details by ID' })
  @ApiParam({ name: 'id', type: Number, description: 'Character ID' })
  @ApiResponse({ status: 200, description: 'Character details including stroke paths', type: CharacterResponseDto })
  async getCharacter(@Param('id', ParseIntPipe) id: number): Promise<CharacterResponseDto> {
    return this.getCharacterDetailsUseCase.execute(id);
  }

  @Get(':id/audio')
  @ApiOperation({ summary: 'Get audio URL for a character (lazy cached)' })
  @ApiParam({ name: 'id', description: 'Character ID', type: Number })
  @ApiResponse({ status: 302, description: 'Redirects to the audio file URL' })
  @Redirect()
  async getCharacterAudio(@Param('id', ParseIntPipe) id: number) {
    const { url } = await this.getCharacterAudioUseCase.execute(id);
    return { url };
  }
}

