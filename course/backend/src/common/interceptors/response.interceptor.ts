import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';

export interface Response<T> {
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
        // Handle pagination envelopes
        if (
          data &&
          typeof data === 'object' &&
          'meta' in data &&
          'data' in data
        ) {
          return data as unknown as Response<T>;
        }
        return { data: data as T };
      }),
    );
  }
}
