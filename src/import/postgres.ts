import { Pool } from 'pg';
import fs from 'fs/promises';
import path from 'path';
import dotenv from 'dotenv';
dotenv.config();

const pool = new Pool({ connectionString: process.env.POSTGRES_URL });

async function run() {
  // 1. Executa os scripts SQL (CREATE TABLE etc)
  const sqlDir = path.join(__dirname, '../queries');
  const allSqlEntries = await fs.readdir(sqlDir, { withFileTypes: true });
  const sqlFiles = allSqlEntries
    .filter(f => f.isFile() && f.name.endsWith('.sql'))
    .map(f => f.name);

  for (const file of sqlFiles) {
    const script = await fs.readFile(path.join(sqlDir, file), 'utf-8');
    try {
      await pool.query(script);
      console.log(`✅ Executado: ${file}`);
    } catch (err: any) {
      if (err.code === '42P07') {
        console.warn(`⚠️ Tabela já existe, ignorando: ${file}`);
      } else {
        console.error(`❌ Erro ao executar ${file}:`, err.message);
        throw err;
      }
    }
  }

  // 2. Lê os .txt e importa os dados para as tabelas
  const dataDir = path.join(__dirname, '../data');
  const allEntries = await fs.readdir(dataDir, { withFileTypes: true });
  const txtFiles = allEntries
    .filter(f => f.isFile() && f.name.endsWith('.txt'))
    .map(f => f.name);

  for (const file of txtFiles) {
    const tableName = file.replace('.txt', '');
    const content = await fs.readFile(path.join(dataDir, file), 'utf-8');
    const lines = content.trim().split('\n').slice(1); // Remove cabeçalho

    for (const line of lines) {
      const values = line.split(';').map(v => {
        const cleaned = v.trim().replace(',', '.');
        return cleaned === '' ? null : cleaned;
      });

      const placeholders = values.map((_, i) => `$${i + 1}`).join(', ');

      try {
        await pool.query(`INSERT INTO "${tableName}" VALUES (${placeholders})`, values);
      } catch (err) {
        console.error(`❌ Erro ao inserir na tabela ${tableName} com:`, values);
        console.error(err);
        throw err;
      }
    }

    console.log(`📥 Importado para ${tableName}`);
  }

  // 3. Finaliza a conexão
  await pool.end();
  console.log('🚀 PostgreSQL import concluído.');
}

run();
