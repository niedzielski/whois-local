include src/defaults.make

dist_dir := dist
zone_dir := zones
src_dir := src

zone_files := $(wildcard $(zone_dir)/*.txt.gz)
src_files := $(wildcard $(src_dir)/*.foo)
db_files := $(zone_files:$(zone_dir)/%.txt.gz=$(dist_dir)/%.sqlite3)

.PHONY: query
query: build
  src/index.ts

.PHONY: build
build: $(db_files)

$(dist_dir)/%.sqlite3: $(dist_dir)/%.names | $(dist_dir)/
  $(rm) '$@' # Replace any existing database.
  sqlite3 '$@' < '$(src_dir)/init.sql'

# The format is a zone file (https://en.wikipedia.org/wiki/Zone_file)
# tab-delimited columns,
# `name ttl record_class record_type record_data_0, record_data_1, record_data_2, …`,
# where name appear across multiple rows. We only care about whether a name
# entry exists. Otherwise, a SQL script might be able to do something like:
#   .mode tab
#   .import com.txt domains
$(dist_dir)/%.names: $(dist_dir)/%.txt | $(dist_dir)/
  cut --delimiter=. --fields=1 '$<'|
  uniq - '$@'

$(dist_dir)/%.txt: $(zone_dir)/%.txt.gz | $(dist_dir)/
  gzip --decompress --to-stdout '$<' > '$@'

$(dist_dir)/:; $(mkdir) '$@'

.PHONY: clean
clean:; $(rm) '$(dist_dir)/'

# to-do: a list of short, simple (only a-z, no names, etc) dictionary words can
# be generated with:
#   iconv -c -f utf-8 -t ascii /usr/share/dict/words|
#   grep -E '^[a-z]{1,6}$'|
#   sort -u
