import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import appConfig from './config/app.config';
import databaseConfig from './config/database.config';
import redisConfig from './config/redis.config';
import { PrismaModule } from './database/prisma.module';
import { RedisModule } from './providers/redis/redis.module';
import { HealthModule } from './modules/health/health.module';
import { UsersModule } from './modules/users/users.module';
import { AuthModule } from './modules/auth/auth.module';
import { CharactersModule } from './modules/characters/characters.module';
import { LessonsModule } from './modules/lessons/lessons.module';
import { ProgressModule } from './modules/progress/progress.module';
import { PracticeModule } from './modules/practice/practice.module';
import { LevelsModule } from './modules/levels/levels.module';
import { ContributionsModule } from './modules/contributions/contributions.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      load: [appConfig, databaseConfig, redisConfig],
    }),
    PrismaModule,
    RedisModule,
    HealthModule,
    UsersModule,
    AuthModule,
    CharactersModule,
    LessonsModule,
    ProgressModule,
    PracticeModule,
    LevelsModule,
    ContributionsModule,
  ],
  controllers: [],
  providers: [],
})
export class AppModule {}
