#!/usr/bin/env bash
# verify-portable.sh
# Portability guardrail for the Compound AI Team edition.
#
# Scans a target directory for "leak" patterns that would tie this kit to a
# private machine, a vendor, a specific person, or a vector-DB runtime. The kit
# must be standalone and publishable: nothing personal, nothing vendor-bound,
# no hidden infrastructure dependency.
#
# Usage:
#   bin/verify-portable.sh            # scans the team-edition root (parent of bin/)
#   bin/verify-portable.sh /some/dir  # scans an explicit directory instead
#
# Exits 1 (after printing every file:line violation) if anything is found.
# Exits 0 and prints "PORTABLE: clean" if the tree is clean.

set -u

# --- resolve the target directory --------------------------------------------
# Default target is the team-edition root, i.e. the parent of bin/, derived from
# this script's own location so it works no matter where it is invoked from.
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEFAULT_TARGET="$(cd "$SCRIPT_DIR/.." && pwd)"
TARGET="${1:-$DEFAULT_TARGET}"

if [ ! -d "$TARGET" ]; then
  echo "verify-portable: target directory not found: $TARGET" >&2
  exit 2
fi

# --- leak pattern list --------------------------------------------------------
# Each entry is a single grep extended-regex. Keep these readable and grouped by
# the reason they are forbidden. The em-dash and the word "sync" are handled
# separately below because they need special matching.
PATTERNS=(
  # absolute personal paths
  '/Users/'
  '/Volumes/'
  'Cameron Brain'
  'masterportfolio'

  # vector-DB runtime couplings (the bare word "chroma" as a config value is
  # allowed; only these coupling tokens are flagged)
  'mcp__chroma'
  'chroma_query_documents'
  '~/\.chroma'
  'mcp-cli'

  # vendor / personal leak tokens (the names are matched as whole words so they
  # do not snag ordinary text; "Cameron Sutcliff" author credit is allowed)
  'Accenture'
  'NAV AI'
  'CCO'
  'ECO'
  '\bAmir\b'
  '\bIon\b'
  '\bJason\b'
  '\bShaheen\b'

  # orphan Obsidian cross-links that point at files outside a standalone repo
  '\[\[[^]]*\]\]'
)

# Shared grep options: recursive, line numbers, skip binary files, ignore .git
# and exclude this script (it legitimately contains every pattern as a string).
SELF_NAME="$(basename "$0")"
GREP_OPTS=(-rnIE --exclude-dir='.git' --exclude="$SELF_NAME")

VIOLATIONS=0

report() {
  # $1 = label, $2 = grep output (file:line:match). Prints and counts hits.
  if [ -n "$2" ]; then
    echo "LEAK ($1):"
    echo "$2"
    VIOLATIONS=$((VIOLATIONS + 1))
  fi
}

# --- run the standard pattern list -------------------------------------------
for pat in "${PATTERNS[@]}"; do
  hits="$(grep "${GREP_OPTS[@]}" -e "$pat" "$TARGET" 2>/dev/null)"
  report "$pat" "$hits"
done

# --- em-dash (U+2014) ---------------------------------------------------------
# Matched as a literal byte sequence so it works on plain grep without locale
# surprises. printf renders the character; grep -F treats it literally.
EMDASH="$(printf '\xe2\x80\x94')"
hits="$(grep -rnIF --exclude-dir='.git' --exclude="$SELF_NAME" -e "$EMDASH" "$TARGET" 2>/dev/null)"
report "em-dash U+2014" "$hits"

# --- the whole word "sync" (case-insensitive) --------------------------------
hits="$(grep -rnIiE --exclude-dir='.git' --exclude="$SELF_NAME" -e '\bsync\b' "$TARGET" 2>/dev/null)"
report "forbidden word sync" "$hits"

# --- verdict ------------------------------------------------------------------
if [ "$VIOLATIONS" -gt 0 ]; then
  echo "FAILED: $VIOLATIONS leak pattern(s) found in $TARGET"
  exit 1
fi

echo "PORTABLE: clean"
exit 0
