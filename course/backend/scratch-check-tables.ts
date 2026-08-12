import { PrismaClient } from '@prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';
import { Pool } from 'pg';
import * as dotenv from 'dotenv';

dotenv.config();

const pool = new Pool({ connectionString: process.env.DATABASE_URL });
const adapter = new PrismaPg(pool);
const prisma = new PrismaClient({ adapter });

async function main() {
  const charCount = await prisma.character.count();
  const vocabCount = await prisma.vocabulary.count();
  const levelCount = await prisma.level.count();
  const lessonCount = await prisma.lesson.count();
  const radicalCount = await prisma.radical.count();

  console.log(`Character count: ${charCount}`);
  console.log(`Vocabulary count: ${vocabCount}`);
  console.log(`Level count: ${levelCount}`);
  console.log(`Lesson count: ${lessonCount}`);
  console.log(`Radical count: ${radicalCount}`);
}

main().finally(async () => {
  await prisma.$disconnect();
  await pool.end();
});
