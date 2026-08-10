import {
  ExceptionFilter,
  Catch,
  ArgumentsHost,
  HttpException,
  HttpStatus,
  Logger,
} from '@nestjs/common';
import { Request, Response } from 'express';
import { AppException } from '../exceptions/app.exception';
import { ApiCode } from '../constants/api-code.constant';

@Catch()
export class GlobalExceptionFilter implements ExceptionFilter {
  private readonly logger = new Logger(GlobalExceptionFilter.name);

  catch(exception: unknown, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();
    const request = ctx.getRequest<Request>();

    let status = HttpStatus.INTERNAL_SERVER_ERROR;
    let message: unknown = 'Internal server error';
    let code: string = ApiCode.INTERNAL_ERROR;

    if (exception instanceof AppException) {
      status = exception.getStatus();
      message = exception.message;
      code = exception.code;
    } else if (exception instanceof HttpException) {
      status = exception.getStatus();
      
      switch (status) {
        case HttpStatus.BAD_REQUEST:
          code = ApiCode.BAD_REQUEST;
          break;
        case HttpStatus.UNAUTHORIZED:
          code = ApiCode.UNAUTHORIZED;
          break;
        case HttpStatus.FORBIDDEN:
          code = ApiCode.FORBIDDEN;
          break;
        case HttpStatus.NOT_FOUND:
          code = ApiCode.NOT_FOUND;
          break;
        default:
          code = ApiCode.INTERNAL_ERROR;
      }

      const exceptionResponse = exception.getResponse();
      if (typeof exceptionResponse === 'string') {
        message = exceptionResponse;
      } else if (
        typeof exceptionResponse === 'object' &&
        exceptionResponse !== null
      ) {
        message =
          (exceptionResponse as Record<string, unknown>).message ||
          exceptionResponse;
      }
    }

    this.logger.error(
      `${request.method} ${request.url} ${status} - ${JSON.stringify(message)}`,
      exception instanceof Error ? exception.stack : '',
    );

    response.status(status).json({
      code,
      message,
      data: null,
      statusCode: status,
      timestamp: new Date().toISOString(),
      path: request.url,
    });
  }
}
