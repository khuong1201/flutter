import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { ApiCode } from '../constants/api-code.constant';

export interface Response<T> {
  code: string;
  message: string;
  data: T;
}

@Injectable()
export class ResponseInterceptor<T> implements NestInterceptor<T, Response<T>> {
  intercept(
    context: ExecutionContext,
    next: CallHandler,
  ): Observable<Response<T>> {
    return next.handle().pipe(
      map((data: unknown) => {
        // Handle pagination envelopes or already formatted responses
        if (
          data &&
          typeof data === 'object' &&
          'meta' in data &&
          'data' in data
        ) {
          return {
            code: ApiCode.SUCCESS,
            message: 'Success',
            ...data,
          } as unknown as Response<T>;
        }

        if (
          data &&
          typeof data === 'object' &&
          'code' in data &&
          'message' in data &&
          'data' in data
        ) {
          return data as unknown as Response<T>;
        }

        return {
          code: ApiCode.SUCCESS,
          message: 'Success',
          data: data as T,
        };
      }),
    );
  }
}
