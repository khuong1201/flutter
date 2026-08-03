export class ReviewLog {
  constructor(
    public readonly id: string,
    public readonly userId: string,
    public readonly characterId: number,
    public readonly actionType: string,
    public readonly grade: number,
    public readonly errorDetails?: any | null,
    public readonly createdAt?: Date,
  ) {}
}
