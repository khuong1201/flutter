import { HttpException, HttpStatus } from '@nestjs/common';
import { ApiCode } from '../constants/api-code.constant';

export class AppException extends HttpException {
  constructor(
    public readonly code: ApiCode,
    public readonly message: string,
    status: HttpStatus = HttpStatus.BAD_REQUEST,
  ) {
    super(message, status);
  }
}
