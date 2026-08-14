export class Lesson {
  constructor(
    public readonly id: number,
    public readonly levelId: number,
    public readonly title: string,
    public readonly orderIndex: number,
  ) {}
}
