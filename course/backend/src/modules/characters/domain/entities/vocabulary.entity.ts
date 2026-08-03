export class Vocabulary {
  constructor(
    public readonly id: number,
    public readonly characterId: number,
    public readonly word: string,
    public readonly meaning: string,
    public readonly pronunciation?: string | null,
  ) {}
}
