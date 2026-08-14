import { Injectable, Inject } from '@nestjs/common';
import { HandwritingEvaluationService } from '../services/handwriting-evaluation.service';
import { EvaluateHandwritingDto } from '../dto/evaluate-handwriting.dto';
import { PrismaService } from '../../../../database/prisma.service';
import { AppException } from '../../../../common/exceptions/app.exception';
import { ApiCode } from '../../../../common/constants/api-code.constant';

@Injectable()
export class EvaluateHandwritingUseCase {
  constructor(
    private readonly handwritingEvaluationService: HandwritingEvaluationService,
    private readonly prisma: PrismaService,
  ) {}

  async execute(data: EvaluateHandwritingDto): Promise<{ score: number; feedback: string }> {
    // 1. Fetch character strokes from database
    const strokes = await this.prisma.characterStroke.findMany({
      where: { characterId: data.characterId },
      orderBy: { order: 'asc' },
    });

    if (!strokes || strokes.length === 0) {
      throw new AppException(
        ApiCode.NOT_FOUND,
        'Character strokes not found in database',
        404,
      );
    }

    // 2. Parse medianPath
    const expectedStrokes: { x: number; y: number }[][] = strokes.map(stroke => {
      try {
        const points = JSON.parse(stroke.medianPath);
        // expected format: [[x1,y1], [x2,y2], ...]
        return points.map((p: number[]) => ({ x: p[0], y: p[1] }));
      } catch {
        return [];
      }
    }).filter(stroke => stroke.length > 0);

    if (expectedStrokes.length === 0) {
      throw new AppException(
        ApiCode.INTERNAL_ERROR,
        'Failed to parse median paths',
        500,
      );
    }

    // 3. Evaluate
    const score = this.handwritingEvaluationService.evaluate(
      data.userStrokes,
      expectedStrokes,
    );

    let feedback = 'Excellent';
    if (score < 50) {
      feedback = 'Needs improvement. Please check stroke order and direction.';
    } else if (score < 80) {
      feedback = 'Good, but could be more accurate.';
    }

    return { score, feedback };
  }
}
