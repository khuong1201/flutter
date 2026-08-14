import { Controller, Post, Body, HttpCode, HttpStatus } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiBody } from '@nestjs/swagger';

import {
  SocialLoginUseCase,
  SocialLoginDto,
} from '../../application/use-cases/social-login.use-case';
import {
  LoginUseCase,
  LoginDto,
} from '../../application/use-cases/login.use-case';
import {
  RegisterUseCase,
  RegisterDto,
} from '../../application/use-cases/register.use-case';
import {
  RefreshTokenUseCase,
  RefreshTokenDto,
} from '../../application/use-cases/refresh-token.use-case';
import { AuthResponseDto } from '../../application/dto/auth-response.dto';

@ApiTags('Auth')
@Controller('auth')
export class AuthController {
  constructor(
    private readonly socialLoginUseCase: SocialLoginUseCase,
    private readonly loginUseCase: LoginUseCase,
    private readonly registerUseCase: RegisterUseCase,
    private readonly refreshTokenUseCase: RefreshTokenUseCase,
  ) {}

  @Post('login')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Login with email and password' })
  @ApiBody({ type: LoginDto })
  @ApiResponse({
    status: 200,
    description: 'Successful login',
    type: AuthResponseDto,
  })
  async login(@Body() body: LoginDto): Promise<AuthResponseDto> {
    return this.loginUseCase.execute(body);
  }

  @Post('social-login')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Login or register with social provider' })
  @ApiResponse({
    status: 200,
    description: 'Returns an access token',
    type: AuthResponseDto,
  })
  async socialLogin(@Body() data: SocialLoginDto): Promise<AuthResponseDto> {
    return this.socialLoginUseCase.execute(data);
  }

  @Post('register')
  @ApiOperation({ summary: 'Register a new user' })
  @ApiBody({ type: RegisterDto })
  @ApiResponse({
    status: 201,
    description: 'Successful registration',
    type: AuthResponseDto,
  })
  async register(@Body() body: RegisterDto): Promise<AuthResponseDto> {
    return this.registerUseCase.execute(body);
  }

  @Post('refresh-token')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Get a new access token using a refresh token' })
  @ApiBody({ type: RefreshTokenDto })
  @ApiResponse({
    status: 200,
    description: 'Returns new access and refresh tokens',
    type: AuthResponseDto,
  })
  async refreshToken(@Body() body: RefreshTokenDto): Promise<AuthResponseDto> {
    return this.refreshTokenUseCase.execute(body);
  }
}

