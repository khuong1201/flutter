import { Injectable, Logger, HttpException, HttpStatus } from '@nestjs/common';
import { IAudioProvider } from '../../application/ports/audio-provider.interface';
import * as https from 'https';
import * as http from 'http';

@Injectable()
export class TtsAudioProvider implements IAudioProvider {
  private readonly logger = new Logger(TtsAudioProvider.name);

  async generateAudio(text: string, language: string): Promise<Buffer> {
    this.logger.log(`Generating audio for [${language}] ${text}`);

    let url = '';
    if (language === 'zh') {
      url = `https://translate.google.com/translate_tts?ie=UTF-8&q=${encodeURIComponent(text)}&tl=zh-CN&client=tw-ob`;
    } else if (language === 'ja') {
      url = `https://assets.languagepod101.com/dictionary/japanese/audiomp3.php?kanji=${encodeURIComponent(text)}`;
    } else {
      throw new HttpException(
        `Language ${language} not supported for TTS`,
        HttpStatus.BAD_REQUEST,
      );
    }

    return this.downloadBuffer(url);
  }

  private downloadBuffer(url: string): Promise<Buffer> {
    return new Promise((resolve, reject) => {
      const get = url.startsWith('https') ? https.get : http.get;
      const req = get(url, (res) => {
        if (
          res.statusCode &&
          res.statusCode >= 300 &&
          res.statusCode < 400 &&
          res.headers.location
        ) {
          // Follow redirect
          return this.downloadBuffer(res.headers.location)
            .then(resolve)
            .catch(reject);
        }

        if (res.statusCode !== 200) {
          return reject(
            new Error(`Failed to download audio. Status: ${res.statusCode}`),
          );
        }

        const chunks: Buffer[] = [];
        res.on('data', (chunk) => chunks.push(Buffer.from(chunk)));
        res.on('end', () => resolve(Buffer.concat(chunks)));
      });
      req.on('error', reject);
    });
  }
}
