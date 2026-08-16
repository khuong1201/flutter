import { Injectable, Inject } from '@nestjs/common';
import { HandwritingEvaluationService } from '../services/handwriting-evaluation.service';
import { EvaluateHandwritingDto } from '../dto/evaluate-handwriting.dto';
import { PrismaService } from '../../../../database/prisma.service';
import { AppException } from '../../../../common/exceptions/app.exception';
import { ApiCode } from '../../../../common/constants/api-code.constant';
import { UpdateProgressUseCase } from './update-progress.use-case';

@Injectable()
export class EvaluateHandwritingUseCase {
  constructor(
    private readonly handwritingEvaluationService: HandwritingEvaluationService,
    private readonly prisma: PrismaService,
    private readonly updateProgressUseCase: UpdateProgressUseCase,
  ) {}

  async execute(userId: string, data: EvaluateHandwritingDto): Promise<{ score: number; feedback: string; xpGained: number }> {
    // 1. Fetch character strokes from database
    const strokes = await this.prisma.characterStroke.findMany({
      where: { characterId: data.characterId },
      orderBy: { order: 'asc' },
    });

    if (!strokes || strokes.length === 0) {
      throw new AppException(ApiCode.NOT_FOUND, 'Character strokes not found in database', 404);
    }

    // 2. Parse medianPath
    const expectedStrokes: { x: number; y: number }[][] = strokes.map(stroke => {
      try {
        const points = JSON.parse(stroke.medianPath);
        return points.map((p: number[]) => ({ x: p[0], y: p[1] }));
      } catch {
        return [];
      }
    }).filter(stroke => stroke.length > 0);

    if (expectedStrokes.length === 0) {
      throw new AppException(ApiCode.INTERNAL_ERROR, 'Failed to parse median paths', 500);
    }

    // 3. Evaluate score
    const score = this.handwritingEvaluationService.evaluate(
      data.userStrokes,
      expectedStrokes,
    );

    let feedback = 'Excellent';
    let srsGrade = 5;
    if (score < 50) {
      feedback = 'Needs improvement. Please check stroke order and direction.';
      srsGrade = 1;
    } else if (score < 80) {
      feedback = 'Good, but could be more accurate.';
      srsGrade = 3;
    }

    // 4. Calculate XP based on Max Score achieved previously
    // Only fetch HANDWRITING logs for this user & character
    const previousLogs = await this.prisma.reviewLog.findMany({
      where: {
        userId: userId,
        characterId: data.characterId,
        actionType: 'HANDWRITING',
      },
      select: { grade: true }, // we store the score (0-100) in grade for HANDWRITING
    });

    const maxPreviousScore = previousLogs.length > 0
      ? Math.max(...previousLogs.map(log => log.grade))
      : 0;

    const xpGained = Math.max(0, score - maxPreviousScore);

    // 5. Run Database Transactions (Update XP, create Log)
    await this.prisma.$transaction(async (tx) => {
      if (xpGained > 0) {
        await tx.user.update({
          where: { id: userId },
          data: { xpPoints: { increment: xpGained } },
        });
      }

      await tx.reviewLog.create({
        data: {
          userId: userId,
          characterId: data.characterId,
          actionType: 'HANDWRITING',
          grade: Math.round(score), // Store the score out of 100
          errorDetails: { xpGained, maxPreviousScore },
        },
      });
    });

    // 6. Update Spaced Repetition System (UserProgress)
    // Only update progress if they scored reasonably well, or just let UpdateProgressUseCase handle it.
    await this.updateProgressUseCase.execute(userId, data.characterId, srsGrade);

    return { score, feedback, xpGained };
  }
}
