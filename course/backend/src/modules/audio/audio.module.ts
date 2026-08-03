import { Module } from '@nestjs/common';
import { AUDIO_PROVIDER } from './application/ports/audio-provider.interface';
import { STORAGE_SERVICE } from './application/ports/storage-service.interface';
import { TtsAudioProvider } from './infrastructure/providers/tts-audio.provider';
import { LocalStorageService } from './infrastructure/storage/local-storage.service';

@Module({
  providers: [
    {
      provide: AUDIO_PROVIDER,
      useClass: TtsAudioProvider,
    },
    {
      provide: STORAGE_SERVICE,
      useClass: LocalStorageService,
    },
  ],
  exports: [AUDIO_PROVIDER, STORAGE_SERVICE],
})
export class AudioModule {}
