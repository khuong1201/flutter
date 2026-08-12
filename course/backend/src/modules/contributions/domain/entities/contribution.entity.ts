export class Contribution {
  constructor(
    public readonly id: string,
    public readonly userId: string,
    public readonly date: Date,
    public readonly count: number,
    public readonly createdAt: Date,
    public readonly updatedAt: Date,
  ) {}
}
