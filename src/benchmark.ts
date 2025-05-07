import { Pool as PgPool } from 'pg';
import mysql from 'mysql2/promise';
import fs from 'fs/promises';
import dotenv from 'dotenv';
dotenv.config();

const queries = ['test1'];

async function runPostgres(label: string) {
  const pool = new PgPool({ connectionString: process.env.POSTGRES_URL });
  const query = await fs.readFile(`./src/queries/test/${label}.sql`, 'utf-8');
  console.time(`PostgreSQL - ${label}`);
  await pool.query(query);
  console.timeEnd(`PostgreSQL - ${label}`);
  await pool.end();
}

async function runMySQL(label: string) {
  const pool = await mysql.createPool({ uri: process.env.MYSQL_URL });
  const conn = await pool.getConnection();
  const query = await fs.readFile(`./src/queries/test/${label}.sql`, 'utf-8');
  console.time(`MySQL - ${label}`);
  await conn.query(query);
  console.timeEnd(`MySQL - ${label}`);
  conn.release();
  await pool.end();
}

async function runBenchmark() {
  for (const label of queries) {
    await runPostgres(label);
    await runMySQL(label);
  }
}

runBenchmark();
