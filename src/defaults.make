# Report unitialized variable usage. Pass as a CLI flag to catch everything; see
# https://savannah.gnu.org/bugs/?9060.
MAKEFLAGS += --warn-undefined-variables

# Only use the rules and variables supplied.
MAKEFLAGS += --no-builtin-rules --no-builtin-variables

# Parallelize by default. Everything should have correct dependencies. This also
# allows multiple watch tasks to execute in parallel without `xargs -P`.
MAKEFLAGS += --jobs

# Use spaces instead of tabs for recipes.
empty :=
space := $(empty) $(empty)
.RECIPEPREFIX := $(space)

# Execute each recipe in one shell and fail on first error and undefined
# variable usage within the recipe.
.ONESHELL:
.SHELLFLAGS := -euc

# Don't echo recipes.
.SILENT:

# If a recipe fails, delete the target.
.DELETE_ON_ERROR:

# Preserve intermediate targets.
.SECONDARY:

# Preserve all and overwrite.
cp := cp --archive --force

# Only report warnings and errors.
deno := deno --quiet

# Create directory hierarchies.
mkdir := mkdir --parents

# Delete hierarchy if present.
rm := rm --force --recursive
