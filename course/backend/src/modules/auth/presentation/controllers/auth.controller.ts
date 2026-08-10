import { Controller, Post, Body, HttpCode, HttpStatus } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiBody } from '@nestjs/swagger';

import { SocialLoginUseCase, SocialLoginDto } from '../../application/use-cases/social-login.use-case';
import { LoginUseCase, LoginDto } from '../../application/use-cases/login.use-case';
import { RegisterUseCase, RegisterDto } from '../../application/use-cases/register.use-case';

@ApiTags('Auth')
@Controller('auth')
export class AuthController {
  constructor(
    private readonly socialLoginUseCase: SocialLoginUseCase,
    private readonly loginUseCase: LoginUseCase,
    private readonly registerUseCase: RegisterUseCase,
  ) {}

  @Post('login')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Login with email and password' })
  @ApiBody({ type: LoginDto })
  @ApiResponse({ status: 200, description: 'Successful login', schema: { properties: { accessToken: { type: 'string' } } } })
  async login(@Body() body: LoginDto) {
    return this.loginUseCase.execute(body);
  }

  @Post('social-login')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Login or register with social provider' })
  @ApiResponse({ status: 200, description: 'Returns an access token', schema: { properties: { accessToken: { type: 'string' } } } })
  async socialLogin(@Body() data: SocialLoginDto) {
    return this.socialLoginUseCase.execute(data);
  }

  @Post('register')
  @ApiOperation({ summary: 'Register a new user' })
  @ApiBody({ type: RegisterDto })
  @ApiResponse({ status: 201, description: 'Successful registration', schema: { properties: { accessToken: { type: 'string' } } } })
  async register(@Body() body: RegisterDto) {
    return this.registerUseCase.execute(body);
  }
}
