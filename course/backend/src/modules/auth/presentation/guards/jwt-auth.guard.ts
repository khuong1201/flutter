import { Injectable, CanActivate, ExecutionContext, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { Request } from 'express';
import { AppException } from '../../../../common/exceptions/app.exception';
import { ApiCode } from '../../../../common/constants/api-code.constant';

@Injectable()
export class JwtAuthGuard implements CanActivate {
  constructor(private jwtService: JwtService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest();
    const token = this.extractTokenFromHeader(request);
    
    if (!token) {
      throw new AppException(ApiCode.UNAUTHORIZED, 'Token not found', 401);
    }
    
    try {
      const payload = await this.jwtService.verifyAsync(token);
      // We're assigning the payload to the request object here
      // so that we can access it in our route handlers
      request['user'] = { id: payload.sub, email: payload.email };
    } catch {
      throw new AppException(ApiCode.TOKEN_INVALID, 'Invalid token', 401);
    }
    return true;
  }

  private extractTokenFromHeader(request: Request): string | undefined {
    const [type, token] = request.headers.authorization?.split(' ') ?? [];
    return type === 'Bearer' ? token : undefined;
  }
}
