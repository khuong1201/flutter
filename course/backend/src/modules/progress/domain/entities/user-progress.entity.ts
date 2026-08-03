export class UserProgress {
  constructor(
    public readonly id: string,
    public readonly userId: string,
    public readonly characterId: number,
    public status: string,
    public easeFactor: number,
    public intervalDays: number,
    public nextReviewAt: Date,
    public totalReviews: number,
    public consecutiveCorrect: number,
  ) {}
}
