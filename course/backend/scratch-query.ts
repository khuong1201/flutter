import { PrismaClient } from '@prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';
import { Pool } from 'pg';
import * as dotenv from 'dotenv';

dotenv.config();

const pool = new Pool({ connectionString: process.env.DATABASE_URL });
const adapter = new PrismaPg(pool);
const prisma = new PrismaClient({ adapter });

async function main() {
  const zhChars = await prisma.character.findMany({
    where: { language: 'zh' },
    take: 3
  });
  console.log('--- ZH Characters ---');
  console.log(JSON.stringify(zhChars, null, 2));

  const jaChars = await prisma.character.findMany({
    where: { language: 'ja' },
    take: 3
  });
  console.log('--- JA Characters ---');
  console.log(JSON.stringify(jaChars, null, 2));
  
  // Try to fetch something that is expected to be complete, e.g. "学"
  const hao = await prisma.character.findFirst({
    where: { charText: '好', language: 'zh' }
  });
  console.log('--- Character 好 (zh) ---');
  console.log(JSON.stringify(hao, null, 2));
}

main().finally(async () => {
  await prisma.$disconnect();
  await pool.end();
});
