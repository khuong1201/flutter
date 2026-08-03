import { Controller, Post, Body, HttpCode, HttpStatus } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiBody } from '@nestjs/swagger';

import { SocialLoginUseCase, SocialLoginDto } from '../../application/use-cases/social-login.use-case';

@ApiTags('Auth')
@Controller('auth')
export class AuthController {
  constructor(
    private readonly socialLoginUseCase: SocialLoginUseCase
  ) {}

  @Post('login')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Login with email and password' })
  @ApiBody({ schema: { type: 'object', properties: { email: { type: 'string' }, password: { type: 'string' } } } })
  @ApiResponse({ status: 200, description: 'Successful login', schema: { properties: { token: { type: 'string' } } } })
  async login(@Body() body: any) {
    return { token: 'mock-jwt-token' };
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
  @ApiBody({ schema: { type: 'object', properties: { email: { type: 'string' }, password: { type: 'string' }, fullName: { type: 'string' }, targetLanguage: { type: 'string' } } } })
  async register(@Body() body: any) {
    return { message: 'User registered successfully' };
  }
}
