import { UserProgress } from '../entities/user-progress.entity';

export class Sm2Service {
  /**
   * Calculate next review intervals using SuperMemo-2 (SM-2) algorithm.
   * Grade is on a scale of 0-5.
   * 0-2: Complete blackout or incorrect.
   * 3: Correct, but required significant effort.
   * 4: Correct, after some hesitation.
   * 5: Perfect response.
   */
  static calculateNextReview(progress: UserProgress, grade: number): void {
    if (grade >= 3) {
      if (progress.consecutiveCorrect === 0) {
        progress.intervalDays = 1;
      } else if (progress.consecutiveCorrect === 1) {
        progress.intervalDays = 6;
      } else {
        progress.intervalDays = Math.round(
          progress.intervalDays * progress.easeFactor,
        );
      }
      progress.consecutiveCorrect += 1;
    } else {
      progress.consecutiveCorrect = 0;
      progress.intervalDays = 1;
    }

    // Update Ease Factor (EF)
    progress.easeFactor =
      progress.easeFactor + (0.1 - (5 - grade) * (0.08 + (5 - grade) * 0.02));
    if (progress.easeFactor < 1.3) {
      progress.easeFactor = 1.3;
    }

    progress.totalReviews += 1;
    progress.status = 'reviewing';

    const nextDate = new Date();
    nextDate.setDate(nextDate.getDate() + progress.intervalDays);
    progress.nextReviewAt = nextDate;
  }
}
