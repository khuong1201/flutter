import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import appConfig from './config/app.config';
import databaseConfig from './config/database.config';
import redisConfig from './config/redis.config';
import { PrismaModule } from './database/prisma.module';
import { RedisModule } from './providers/redis/redis.module';
import { HealthModule } from './modules/health/health.module';
import { IamModule } from './modules/iam/iam.module';
import { CurriculumModule } from './modules/curriculum/curriculum.module';
import { LearningModule } from './modules/learning/learning.module';
import { CommunityModule } from './modules/community/community.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      load: [appConfig, databaseConfig, redisConfig],
    }),
    PrismaModule,
    RedisModule,
    HealthModule,
    IamModule,
    CurriculumModule,
    LearningModule,
    CommunityModule,
  ],
  controllers: [],
  providers: [],
})
export class AppModule {}
