import { Injectable, Inject, NotFoundException, Logger } from '@nestjs/common';
import type { ICharacterRepository } from '../../domain/repositories/character.repository.interface';
import { CHARACTER_REPOSITORY } from '../../domain/repositories/character.repository.interface';
import { AUDIO_PROVIDER } from '../../../audio/application/ports/audio-provider.interface';
import type { IAudioProvider } from '../../../audio/application/ports/audio-provider.interface';
import { STORAGE_SERVICE } from '../../../audio/application/ports/storage-service.interface';
import type { IStorageService } from '../../../audio/application/ports/storage-service.interface';

@Injectable()
export class GetCharacterAudioUseCase {
  private readonly logger = new Logger(GetCharacterAudioUseCase.name);

  // In-memory lock to prevent multiple simultaneous TTS generations for the same character
  private locks = new Map<number, Promise<string>>();

  constructor(
    @Inject(CHARACTER_REPOSITORY)
    private readonly characterRepository: ICharacterRepository,
    @Inject(AUDIO_PROVIDER)
    private readonly audioProvider: IAudioProvider,
    @Inject(STORAGE_SERVICE)
    private readonly storageService: IStorageService,
  ) {}

  async execute(id: number): Promise<{ url: string }> {
    const character = await this.characterRepository.findById(id);

    if (!character) {
      throw new NotFoundException('Character not found');
    }

    if (character.audioKey) {
      return { url: this.storageService.getUrl(character.audioKey) };
    }

    // Use lock to prevent concurrent generations
    if (this.locks.has(id)) {
      this.logger.log(
        `Audio generation for character ${id} is already in progress, waiting...`,
      );
      const key = await this.locks.get(id);
      return { url: this.storageService.getUrl(key!) };
    }

    const promise = this.generateAndStoreAudio(character);
    this.locks.set(id, promise);

    try {
      const key = await promise;
      return { url: this.storageService.getUrl(key) };
    } finally {
      this.locks.delete(id);
    }
  }

  private async generateAndStoreAudio(character: any): Promise<string> {
    try {
      this.logger.log(
        `Downloading audio stream for character ${character.charText}`,
      );
      const audioBuffer = await this.audioProvider.generateAudio(
        character.charText,
        character.language,
      );

      const audioKey = `audio/characters/${character.language}_${character.charText}.mp3`;
      await this.storageService.upload(audioKey, audioBuffer, 'audio/mpeg');

      character.audioKey = audioKey;
      await this.characterRepository.update(character);

      return audioKey;
    } catch (error) {
      this.logger.error(
        `Failed to generate/store audio for character ${character.id}`,
        error.stack,
      );
      throw error;
    }
  }
}
