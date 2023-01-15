# 🕵 whois-local

[Find a good .com not yet taken](https://sive.rs/com) code. Does two things:

1. Pair a list of words with itself and
2. Query [WHOIS](https://en.wikipedia.org/wiki/WHOIS) offline for `<pair>.com`
   and report domain availability.

## Set up

1. [Request a .com zone file](https://czds.icann.org/home) per the
   [article](https://sive.rs/com).
   - My given request rationale was:
   > Quickly and privately query domain availability locally without flooding
   > whois with requests.
   - It expires about 11 years after granted. It seems to be updated
     periodically.
   - com domains alone is about 4.8 gigabytes.

2. Download the zone file and move it to zones/.
   - I had to copy the network request as a curl command.

3. Fill out words.json with some candidates to mishmash.

4. Execute `make`. Warning: this generates about 50 gigabytes of additional
   data.

5. 🤞 no one is hoarding domains just for money.

## Quick WHOIS query

### Example of an unavailable domain

```
$ sqlite3 dist/com.sqlite3 "select domain from domains where domain = 'example';"
domain 
-------
example
```

### Example of an available domain

```
$ sqlite3 dist/com.sqlite3 "select domain from domains where domain = 'example99';"
```

## License

© Stephen Niedzielski.

### AGPL-3.0-only

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU Affero General Public License as published by the Free
Software Foundation, either version 3 of the License, or (at your option) any
later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License along
with this program. If not, see <https://www.gnu.org/licenses/>.
