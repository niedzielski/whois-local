#!/usr/bin/env -S deno run --allow-read --allow-write
import { DB } from "sqlite";

const db = new DB("dist/com.sqlite3");

const decoder = new TextDecoder('utf8')
const wordsBin = (await Deno.readFile('src/words.text'))
const words = decoder.decode(wordsBin).split('\n').filter(Boolean);

function isAvailable(db: DB, domain: string): boolean {
  return db.query(
    "select exists(select 1 from domains where domain = ?)",
    [domain],
  )[0][0] == 0;
}

const available: string[] = [];
for (const lhs of words) {
  if (isAvailable(db, lhs)) available.push(lhs);
  for (const rhs of words) {
    const domain = lhs + rhs;
    if (isAvailable(db, domain)) available.push(domain);
  }
}
available.sort((lhs, rhs) => lhs.localeCompare(rhs));
for (const domain of available) console.log(domain);

db.close();
