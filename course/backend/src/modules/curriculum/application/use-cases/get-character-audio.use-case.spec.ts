import { Test, TestingModule } from '@nestjs/testing';
import { GetCharacterAudioUseCase } from './get-character-audio.use-case';
import { CHARACTER_REPOSITORY } from '../../domain/repositories/character.repository.interface';
import { AUDIO_PROVIDER } from '../ports/audio-provider.interface';
import { STORAGE_SERVICE } from '../ports/storage-service.interface';
import { NotFoundException } from '@nestjs/common';

describe('GetCharacterAudioUseCase', () => {
  let useCase: GetCharacterAudioUseCase;
  let characterRepository: any;
  let audioProvider: any;
  let storageService: any;

  beforeEach(async () => {
    characterRepository = { findById: jest.fn(), update: jest.fn() };
    audioProvider = { generateAudio: jest.fn() };
    storageService = { getUrl: jest.fn(), upload: jest.fn() };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        GetCharacterAudioUseCase,
        { provide: CHARACTER_REPOSITORY, useValue: characterRepository },
        { provide: AUDIO_PROVIDER, useValue: audioProvider },
        { provide: STORAGE_SERVICE, useValue: storageService },
      ],
    }).compile();

    useCase = module.get<GetCharacterAudioUseCase>(GetCharacterAudioUseCase);
  });

  it('should throw NOT_FOUND if character does not exist', async () => {
    characterRepository.findById.mockResolvedValue(null);
    await expect(useCase.execute(1)).rejects.toThrow(NotFoundException);
  });

  it('should return URL if audioKey already exists', async () => {
    characterRepository.findById.mockResolvedValue({ id: 1, audioKey: 'audio.mp3' });
    storageService.getUrl.mockReturnValue('http://url.com/audio.mp3');

    const result = await useCase.execute(1);
    expect(result.url).toBe('http://url.com/audio.mp3');
    expect(audioProvider.generateAudio).not.toHaveBeenCalled();
  });

  it('should generate audio, store it and return URL', async () => {
    characterRepository.findById.mockResolvedValue({ id: 1, charText: 'A', language: 'ja' });
    audioProvider.generateAudio.mockResolvedValue(Buffer.from('audio'));
    storageService.getUrl.mockReturnValue('http://url.com/new.mp3');

    const result = await useCase.execute(1);
    
    expect(audioProvider.generateAudio).toHaveBeenCalledWith('A', 'ja');
    expect(storageService.upload).toHaveBeenCalled();
    expect(characterRepository.update).toHaveBeenCalled();
    expect(result.url).toBe('http://url.com/new.mp3');
  });
});
