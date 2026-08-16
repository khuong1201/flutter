import { Test, TestingModule } from '@nestjs/testing';
import { GenerateQuizUseCase } from './generate-quiz.use-case';
import { PrismaService } from '../../../../database/prisma.service';

describe('GenerateQuizUseCase', () => {
  let useCase: GenerateQuizUseCase;
  let prisma: any;

  beforeEach(async () => {
    prisma = {
      lessonVocabulary: { findMany: jest.fn() },
      character: { findMany: jest.fn() },
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        GenerateQuizUseCase,
        { provide: PrismaService, useValue: prisma },
      ],
    }).compile();

    useCase = module.get<GenerateQuizUseCase>(GenerateQuizUseCase);
  });

  it('should generate quiz from specific lesson', async () => {
    prisma.lessonVocabulary.findMany.mockResolvedValue([
      {
        vocabulary: {
          characters: [
            { character: { id: 1, charText: 'A', meaning: 'A_mean' } },
            { character: { id: 2, charText: 'B', meaning: 'B_mean' } }
          ]
        }
      }
    ]);
    prisma.character.findMany.mockResolvedValue([
      { meaning: 'C_mean' }, { meaning: 'D_mean' }, { meaning: 'E_mean' }, { meaning: 'F_mean' }
    ]);

    const result = await useCase.execute(1, 2);

    expect(result.length).toBe(2);
    expect(result[0].options.length).toBe(4);
    expect(result[0].options).toContain('A_mean');
  });

  it('should generate random quiz if no lesson specified', async () => {
    prisma.character.findMany
      .mockResolvedValueOnce([
        { id: 1, charText: 'A', meaning: 'A_mean' },
        { id: 2, charText: 'B', meaning: 'B_mean' }
      ])
      .mockResolvedValueOnce([
        { meaning: 'C_mean' }, { meaning: 'D_mean' }, { meaning: 'E_mean' }, { meaning: 'F_mean' }
      ]);

    const result = await useCase.execute(undefined, 2);

    expect(result.length).toBe(2);
    expect(prisma.lessonVocabulary.findMany).not.toHaveBeenCalled();
  });
});
