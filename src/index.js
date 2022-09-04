#!/usr/bin/env node
import words from "../words.json" assert { type: "json" };
import sqlite3 from "sqlite3";

const db = new sqlite3.Database("dist/com.sqlite3");

/** @type {string[]} */ const available = [];
function pushIfAvailable(val, val2, domain) {
  const exists = Object.values(val2)[0] == 1;
  if (!exists) available.push(domain);
}

db.serialize(() => { 
  const query = db.prepare(
    "select exists(select 1 from domains where domain = ?)",
  );
  for (const lhs of words) {
    query.get(lhs, (val1, val2) => pushIfAvailable(val1, val2, lhs));
    for (const rhs of words) {
      const domain = lhs + rhs;
      query.get(domain, (val1, val2) => pushIfAvailable(val1, val2, domain));
    }
  }
  query.finalize(() => {
    available.sort((lhs, rhs) => lhs.localeCompare(rhs));
    available.forEach((domain) => console.log(domain));
  });
});

db.close();
