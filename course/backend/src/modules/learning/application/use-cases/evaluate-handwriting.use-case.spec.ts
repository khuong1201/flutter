import { Test, TestingModule } from '@nestjs/testing';
import { EvaluateHandwritingUseCase } from './evaluate-handwriting.use-case';
import { HandwritingEvaluationService } from '../services/handwriting-evaluation.service';
import { PrismaService } from '../../../../database/prisma.service';
import { UpdateProgressUseCase } from './update-progress.use-case';
import { AppException } from '../../../../common/exceptions/app.exception';

describe('EvaluateHandwritingUseCase', () => {
  let useCase: EvaluateHandwritingUseCase;
  let handwritingService: HandwritingEvaluationService;
  let prisma: any;
  let updateProgressUseCase: any;

  beforeEach(async () => {
    prisma = {
      characterStroke: { findMany: jest.fn() },
      reviewLog: { findMany: jest.fn(), create: jest.fn() },
      user: { update: jest.fn() },
      $transaction: jest.fn().mockImplementation(async (cb) => cb(prisma)),
    };

    updateProgressUseCase = {
      execute: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        EvaluateHandwritingUseCase,
        HandwritingEvaluationService,
        { provide: PrismaService, useValue: prisma },
        { provide: UpdateProgressUseCase, useValue: updateProgressUseCase },
      ],
    }).compile();

    useCase = module.get<EvaluateHandwritingUseCase>(EvaluateHandwritingUseCase);
    handwritingService = module.get<HandwritingEvaluationService>(HandwritingEvaluationService);
  });

  it('should be defined', () => {
    expect(useCase).toBeDefined();
  });

  describe('execute', () => {
    const userId = 'user-123';
    const characterId = 1;
    const userStrokes = [[{ x: 10, y: 20 }]];
    const medianPathStr = '[[10, 20]]';

    afterEach(() => {
      jest.clearAllMocks();
    });

    it('should throw NOT_FOUND if character strokes do not exist in database', async () => {
      prisma.characterStroke.findMany.mockResolvedValue([]);
      await expect(useCase.execute(userId, { characterId, userStrokes })).rejects.toThrow(AppException);
    });

    it('should throw INTERNAL_ERROR if median paths cannot be parsed', async () => {
      prisma.characterStroke.findMany.mockResolvedValue([
        { order: 1, medianPath: 'invalid json' } // will result in empty expectedStrokes
      ]);
      await expect(useCase.execute(userId, { characterId, userStrokes })).rejects.toThrow(AppException);
    });

    it('should return grade 1 and poor feedback if score < 50', async () => {
      prisma.characterStroke.findMany.mockResolvedValue([{ order: 1, medianPath: medianPathStr }]);
      jest.spyOn(handwritingService, 'evaluate').mockReturnValue(40);
      prisma.reviewLog.findMany.mockResolvedValue([]); 

      const result = await useCase.execute(userId, { characterId, userStrokes });

      expect(result.score).toBe(40);
      expect(result.feedback).toContain('Needs improvement');
      expect(result.xpGained).toBe(40);
      expect(updateProgressUseCase.execute).toHaveBeenCalledWith(userId, characterId, 1);
    });

    it('should return grade 3 and good feedback if 50 <= score < 80', async () => {
      prisma.characterStroke.findMany.mockResolvedValue([{ order: 1, medianPath: medianPathStr }]);
      jest.spyOn(handwritingService, 'evaluate').mockReturnValue(75);
      prisma.reviewLog.findMany.mockResolvedValue([]); 

      const result = await useCase.execute(userId, { characterId, userStrokes });

      expect(result.score).toBe(75);
      expect(result.feedback).toContain('Good');
      expect(result.xpGained).toBe(75);
      expect(updateProgressUseCase.execute).toHaveBeenCalledWith(userId, characterId, 3);
    });

    it('should return grade 5 and excellent feedback if score >= 80', async () => {
      prisma.characterStroke.findMany.mockResolvedValue([{ order: 1, medianPath: medianPathStr }]);
      jest.spyOn(handwritingService, 'evaluate').mockReturnValue(90);
      prisma.reviewLog.findMany.mockResolvedValue([]); 

      const result = await useCase.execute(userId, { characterId, userStrokes });

      expect(result.score).toBe(90);
      expect(result.feedback).toContain('Excellent');
      expect(updateProgressUseCase.execute).toHaveBeenCalledWith(userId, characterId, 5);
    });

    it('should correctly calculate max XP and update user when previous max is lower', async () => {
      prisma.characterStroke.findMany.mockResolvedValue([{ order: 1, medianPath: medianPathStr }]);
      jest.spyOn(handwritingService, 'evaluate').mockReturnValue(85);
      prisma.reviewLog.findMany.mockResolvedValue([{ grade: 50 }, { grade: 40 }]);

      const result = await useCase.execute(userId, { characterId, userStrokes });

      expect(result.score).toBe(85);
      expect(result.xpGained).toBe(35); // 85 - 50 = 35
      expect(prisma.user.update).toHaveBeenCalledWith({
        where: { id: userId },
        data: { xpPoints: { increment: 35 } }
      });
      expect(prisma.reviewLog.create).toHaveBeenCalledWith({
        data: expect.objectContaining({
          userId, characterId, actionType: 'HANDWRITING', grade: 85,
          errorDetails: { xpGained: 35, maxPreviousScore: 50 }
        })
      });
    });

    it('should give full XP if previous logs do not exist (maxPreviousScore = 0)', async () => {
      prisma.characterStroke.findMany.mockResolvedValue([{ order: 1, medianPath: medianPathStr }]);
      jest.spyOn(handwritingService, 'evaluate').mockReturnValue(100);
      prisma.reviewLog.findMany.mockResolvedValue([]);

      const result = await useCase.execute(userId, { characterId, userStrokes });

      expect(result.score).toBe(100);
      expect(result.xpGained).toBe(100);
      expect(prisma.user.update).toHaveBeenCalledWith({
        where: { id: userId },
        data: { xpPoints: { increment: 100 } }
      });
    });

    it('should give 0 XP if previous max score is equal or higher', async () => {
      prisma.characterStroke.findMany.mockResolvedValue([{ order: 1, medianPath: medianPathStr }]);
      jest.spyOn(handwritingService, 'evaluate').mockReturnValue(80);
      prisma.reviewLog.findMany.mockResolvedValue([{ grade: 90 }]); // Prev score 90 > new score 80

      const result = await useCase.execute(userId, { characterId, userStrokes });

      expect(result.score).toBe(80);
      expect(result.xpGained).toBe(0); 
      expect(prisma.user.update).not.toHaveBeenCalled();
      expect(prisma.reviewLog.create).toHaveBeenCalled(); // Should still log
    });
  });
});
