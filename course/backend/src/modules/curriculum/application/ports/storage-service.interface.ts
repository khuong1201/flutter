export const STORAGE_SERVICE = 'STORAGE_SERVICE';

export interface IStorageService {
  /**
   * Uploads a file buffer to the storage backend.
   * @param key The unique identifier/path for the file.
   * @param data The file buffer.
   * @param mimeType The mime type of the file.
   * @returns The fully qualified public URL of the uploaded file.
   */
  upload(key: string, data: Buffer, mimeType: string): Promise<string>;

  /**
   * Gets the public URL for a given key.
   * @param key The unique identifier/path for the file.
   */
  getUrl(key: string): string;
}
