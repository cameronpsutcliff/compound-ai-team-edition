#!/usr/bin/env bash
set -euo pipefail

files="$(git diff --cached --name-only --diff-filter=ACM || true)"

if [ -z "$files" ]; then
  exit 0
fi

found=0
while IFS= read -r file; do
  if [ -f "$file" ] && grep -n $'\u2014' "$file"; then
    found=1
  fi
done <<< "$files"

if [ "$found" -eq 1 ]; then
  echo "Commit blocked: em dash found. Use commas, colons, periods, or hyphens."
  exit 1
fi

exit 0
