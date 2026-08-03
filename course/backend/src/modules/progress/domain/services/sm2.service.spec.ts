import { Sm2Service } from './sm2.service';
import { UserProgress } from '../entities/user-progress.entity';
import { randomUUID } from 'crypto';

describe('Sm2Service', () => {
  let progress: UserProgress;

  beforeEach(() => {
    progress = new UserProgress(
      randomUUID(),
      randomUUID(),
      1,
      'learning',
      2.5,
      0,
      new Date(),
      0,
      0,
    );
  });

  it('should reset interval to 1 when grade < 3', () => {
    progress.intervalDays = 5;
    progress.consecutiveCorrect = 2;
    progress.easeFactor = 2.5;

    Sm2Service.calculateNextReview(progress, 2);

    expect(progress.intervalDays).toBe(1);
    expect(progress.consecutiveCorrect).toBe(0);
    expect(progress.easeFactor).toBeLessThan(2.5); // EF should decrease
  });

  it('should set interval to 1 on first correct answer', () => {
    Sm2Service.calculateNextReview(progress, 4);

    expect(progress.intervalDays).toBe(1);
    expect(progress.consecutiveCorrect).toBe(1);
  });

  it('should set interval to 6 on second correct answer', () => {
    progress.consecutiveCorrect = 1;

    Sm2Service.calculateNextReview(progress, 4);

    expect(progress.intervalDays).toBe(6);
    expect(progress.consecutiveCorrect).toBe(2);
  });

  it('should multiply interval by ease factor on third correct answer', () => {
    progress.consecutiveCorrect = 2;
    progress.intervalDays = 6;
    progress.easeFactor = 2.5;

    Sm2Service.calculateNextReview(progress, 4);

    expect(progress.intervalDays).toBe(Math.round(6 * 2.5)); // 15
    expect(progress.consecutiveCorrect).toBe(3);
  });

  it('should not let ease factor drop below 1.3', () => {
    progress.easeFactor = 1.3;

    Sm2Service.calculateNextReview(progress, 1);

    expect(progress.easeFactor).toBe(1.3);
  });
});
