import { Radical } from './radical.entity';
import { Vocabulary } from './vocabulary.entity';

export interface StrokeData {
  type: string;
  outline_path: string;
  median_path?: string;
  points?: { x: number; y: number }[];
}

export class Character {
  constructor(
    public readonly id: number,
    public readonly charText: string,
    public readonly language: string,
    public readonly meaning: string,
    public readonly strokeData?: any[],
    public readonly pronunciation?: any | null,
    public readonly audioKey?: string | null,
    public readonly radicals?: Radical[],
    public readonly vocabularies?: any[],
  ) {}
}
