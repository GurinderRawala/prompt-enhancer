import fs from 'fs';
import path from 'path';
import { Logger } from 'winston';

export function readTaskPrompt(logger: Logger): string {
  const filePath = path.resolve(process.cwd(), 'custom_task.txt');

  try {
    const prompt = fs.readFileSync(filePath, 'utf-8');
    return prompt;
  } catch (err) {
    // If the file is missing or unreadable, return an empty string so callers can fall back.
    logger.error(`Failed to read custom_task.txt: ${err}`);
    return '';
  }
}
