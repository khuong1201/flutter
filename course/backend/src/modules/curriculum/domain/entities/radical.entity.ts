export class Radical {
  constructor(
    public readonly id: number,
    public readonly radicalText: string,
    public readonly meaning: string,
    public readonly variants?: any | null,
  ) {}
}
