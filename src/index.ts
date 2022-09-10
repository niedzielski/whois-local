#!/usr/bin/env -S deno run --allow-read --allow-write
import { DB } from "sqlite";
import words from "./words.json" assert { type: "json" };

const db = new DB("dist/com.sqlite3");

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
