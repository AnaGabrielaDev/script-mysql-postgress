import { Pool as PgPool } from 'pg';
import mysql from 'mysql2/promise';
import fs from 'fs/promises';
import fsSync from 'fs';
import path from 'path';
import dotenv from 'dotenv';
import { performance } from 'perf_hooks';

dotenv.config();

const OUTPUT_CSV = './benchmark_results.csv';
const QUERIES = ['test1', 'test2', 'test3', 'test4', 'test5', 'test6', 'test7', 'test8', 'test9', 'test10']; 
const REPETITIONS = 10;

function calculateStats(times: number[]) {
  const avg = times.reduce((a, b) => a + b, 0) / times.length;
  const sorted = [...times].sort((a, b) => a - b);
  const median = sorted.length % 2 === 0
    ? (sorted[sorted.length / 2 - 1] + sorted[sorted.length / 2]) / 2
    : sorted[Math.floor(sorted.length / 2)];
  const variance = times.reduce((a, b) => a + Math.pow(b - avg, 2), 0) / times.length;
  const stdDev = Math.sqrt(variance);
  return { avg, median, stdDev, min: sorted[0], max: sorted[sorted.length - 1] };
}

async function readQuery(label: string): Promise<string> {
  let query = await fs.readFile(`./src/queries/test/${label}.sql`, 'utf-8');

  query = query.replace(/\b(FROM|JOIN|UPDATE|INTO)\s+([`"]?)([a-zA-Z_][a-zA-Z0-9_]*)([`"]?)/g, (_, clause, open, name, close) => {
    return `${clause} ${open}${name.toLowerCase()}${close}`;
  });

  return query;
}


function writeCSV(engine: string, label: string, stats: ReturnType<typeof calculateStats>) {
  const line = `${engine},${label},${stats.avg.toFixed(2)},${stats.median.toFixed(2)},${stats.stdDev.toFixed(2)},${stats.min.toFixed(2)},${stats.max.toFixed(2)}\n`;
  fsSync.appendFileSync(OUTPUT_CSV, line);
}

async function runPostgres(label: string): Promise<void> {
  const pool = new PgPool({ connectionString: process.env.POSTGRES_URL });
  const query = await readQuery(label);
  const times: number[] = [];

  for (let i = 0; i < REPETITIONS; i++) {
    try {
      const start = performance.now();
      await pool.query(query);
      const end = performance.now();
      times.push(end - start);
    } catch (error) {
      console.error(`[PostgreSQL][${label}][Exec ${i + 1}] Error:`, error);
    }
  }

  await pool.end();

  const stats = calculateStats(times);
  console.log(`PostgreSQL - ${label}:`, stats);
  writeCSV('PostgreSQL', label, stats);
}

async function runMySQL(label: string): Promise<void> {
  const pool = await mysql.createPool({ uri: process.env.MYSQL_URL });
  const query = await readQuery(label);
  const times: number[] = [];

  for (let i = 0; i < REPETITIONS; i++) {
    const conn = await pool.getConnection();
    try {
      const start = performance.now();
      await conn.query(query);
      const end = performance.now();
      times.push(end - start);
    } catch (error) {
      console.error(`[MySQL][${label}][Exec ${i + 1}] Error:`, error);
    } finally {
      conn.release();
    }
  }

  await pool.end();

  const stats = calculateStats(times);
  console.log(`MySQL - ${label}:`, stats);
  writeCSV('MySQL', label, stats);
}

async function setupCSV() {
  if (!fsSync.existsSync(OUTPUT_CSV)) {
    fsSync.writeFileSync(OUTPUT_CSV, 'Engine,Query,Avg(ms),Median(ms),StdDev(ms),Min(ms),Max(ms)\n');
  }
}

export async function runBenchmark() {
  await setupCSV();

  for (const label of QUERIES) {
    console.log(`\nBenchmarking query: ${label} (${REPETITIONS} reps)\n`);
    await runPostgres(label);
    await runMySQL(label);
  }
}

runBenchmark();
