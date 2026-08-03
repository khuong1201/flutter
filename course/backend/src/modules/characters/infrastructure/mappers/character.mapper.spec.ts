import { CharacterMapper } from './character.mapper';

describe('CharacterMapper', () => {
  it('should map Prisma model to Domain Entity correctly', () => {
    const prismaCharacter: any = {
      id: 1,
      charText: '日',
      language: 'ja',
      meaning: 'Sun/Day',
      pronunciation: { onyomi: ['nichi', 'jitsu'], kunyomi: ['hi', 'ka'] },
      audioUrl: null,
      strokeData: { strokes: [] },
      radicals: [
        {
          radical: {
            id: 1,
            radicalText: '日',
            meaning: 'sun',
            variants: null,
          }
        }
      ],
      vocabularies: [
        {
          id: 1,
          characterId: 1,
          word: '日本',
          meaning: 'Japan',
          pronunciation: 'Nihon',
        }
      ]
    };

    const domainEntity = CharacterMapper.toDomain(prismaCharacter);

    expect(domainEntity.id).toBe(1);
    expect(domainEntity.charText).toBe('日');
    expect(domainEntity.radicals.length).toBe(1);
    expect(domainEntity.radicals[0].radicalText).toBe('日');
    expect(domainEntity.vocabularies.length).toBe(1);
    expect(domainEntity.vocabularies[0].word).toBe('日本');
  });
});
