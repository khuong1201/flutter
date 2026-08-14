export const AUDIO_PROVIDER = 'AUDIO_PROVIDER';

export interface IAudioProvider {
  /**
   * Generates audio buffer for the given text and language.
   * @param text The character or text to pronounce.
   * @param language The language code (e.g. 'zh', 'ja').
   * @returns Buffer containing MP3 audio data.
   */
  generateAudio(text: string, language: string): Promise<Buffer>;
}
