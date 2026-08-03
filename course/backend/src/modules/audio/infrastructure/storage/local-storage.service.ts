import { Injectable, Logger } from '@nestjs/common';
import { IStorageService } from '../../application/ports/storage-service.interface';
import * as fs from 'fs';
import * as path from 'path';

@Injectable()
export class LocalStorageService implements IStorageService {
  private readonly logger = new Logger(LocalStorageService.name);
  private readonly uploadDir = path.join(process.cwd(), 'uploads');
  private readonly baseUrl = process.env.APP_URL || 'http://localhost:3000';

  constructor() {
    if (!fs.existsSync(this.uploadDir)) {
      fs.mkdirSync(this.uploadDir, { recursive: true });
    }
  }

  async upload(key: string, data: Buffer, mimeType: string): Promise<string> {
    const filePath = path.join(this.uploadDir, key);
    const dir = path.dirname(filePath);

    if (!fs.existsSync(dir)) {
      fs.mkdirSync(dir, { recursive: true });
    }

    await fs.promises.writeFile(filePath, data);
    this.logger.log(`File saved locally: ${filePath}`);
    
    return this.getUrl(key);
  }

  getUrl(key: string): string {
    // Serve via static route or controller, e.g. /static/...
    return `${this.baseUrl}/static/${key}`;
  }
}
