import {
  Injectable,
  OnModuleInit,
  OnModuleDestroy,
  Logger,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import Redis from 'ioredis';

@Injectable()
export class RedisService
  extends Redis
  implements OnModuleInit, OnModuleDestroy
{
  private readonly logger = new Logger(RedisService.name);

  constructor(private readonly configService: ConfigService) {
    super({
      host: configService.get<string>('redis.host'),
      port: configService.get<number>('redis.port'),
    });
  }

  onModuleInit() {
    this.on('connect', () => this.logger.log('Connected to Redis'));
    this.on('error', (err) => this.logger.error('Redis error', err));
  }

  onModuleDestroy() {
    this.disconnect();
  }
}
