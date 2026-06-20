#!/usr/bin/env bash
# derive.sh - reproducibly derive a scrubbed Individual or Team kit from the Mini canonical.
#
# Usage:
#   derive.sh [--edition individual|team] [--zip] <destination-dir>
#
# Copies paths from derive/include.txt, applies transforms documented in
# derive/transform-rules.md (version strings, path rewrites, denylist-minus-allowlist),
# regenerates compound-ai.manifest.json and compound-ai.sha256, and optionally
# builds a release zip honoring derive/exclude.txt for the Individual edition.
#
# Direction of flow: Mini canonical first; never hand-edit downstream lineages.
set -euo pipefail

DERIVE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CANONICAL="$(cd "$DERIVE_DIR/.." && pwd)"
INCLUDE_FILE="$DERIVE_DIR/include.txt"
EXCLUDE_FILE="$DERIVE_DIR/exclude.txt"
ALWAYS_SKIP_FILE="$DERIVE_DIR/always-skip.txt"
BUILD_MANIFEST="$CANONICAL/reference-impl/scripts/build-manifest.py"

EDITION="individual"
MAKE_ZIP=0
DEST=""

usage() {
  cat <<'EOF'
usage: derive.sh [--edition individual|team] [--zip] <destination-dir>

  --edition individual   Lean zip excludes reference-impl/ and maintainer files (default)
  --edition team         Complete zip includes the full derived tree
  --zip                  Also write compound-ai-starter-kit-v<version>.zip

Copies derive/include.txt paths from the canonical operating-standards tree,
applies documented scrub transforms, and regenerates the SHA256 manifest.
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --edition)
      EDITION="${2:?--edition requires individual or team}"
      shift 2
      ;;
    --zip)
      MAKE_ZIP=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      break
      ;;
    -*)
      echo "derive.sh: unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
    *)
      DEST="$1"
      shift
      ;;
  esac
done

if [ -z "$DEST" ]; then
  usage >&2
  exit 2
fi

case "$EDITION" in
  individual|team) ;;
  *)
    echo "derive.sh: --edition must be individual or team (got: $EDITION)" >&2
    exit 2
    ;;
esac

DEST="$(cd "$(dirname "$DEST")" && pwd)/$(basename "$DEST")"
mkdir -p "$(dirname "$DEST")"

if [ ! -f "$INCLUDE_FILE" ]; then
  echo "derive.sh: missing $INCLUDE_FILE" >&2
  exit 2
fi

always_skipped() {
  # Match a path against always-skip.txt (the single source of truth shared with
  # check-portability.sh's scan-exclude, so the derive drop set and the gate's
  # scanned surface cannot drift apart).
  local rel="${1%/}"
  local pattern
  [ -f "$ALWAYS_SKIP_FILE" ] || return 1
  while IFS= read -r pattern || [ -n "$pattern" ]; do
    pattern="${pattern%%#*}"
    pattern="${pattern#"${pattern%%[![:space:]]*}"}"
    pattern="${pattern%"${pattern##*[![:space:]]}"}"
    [ -n "$pattern" ] || continue
    pattern="${pattern%/}"
    if [ "$rel" = "$pattern" ] || [[ "$rel" == "$pattern/"* ]]; then
      return 0
    fi
  done < "$ALWAYS_SKIP_FILE"
  return 1
}

should_skip_copy() {
  local rel="$1"
  rel="${rel%/}"
  case "$rel" in
    # Build-time bytecode caches: never ship. A .pyc embeds the absolute build
    # path in its co_filename (a personal-path leak that text-greps miss) and is
    # non-deterministic, which breaks the manifest/verify-integrity check. These
    # regenerate whenever a .py is run or compiled, so filter them at every
    # derive (glob match, so kept here rather than in always-skip.txt).
    __pycache__|*/__pycache__|*/__pycache__/*|*.pyc|*.pyo)
      return 0
      ;;
  esac
  # Internal build-process and private-deployment docs plus the maintainer-only
  # local denylist: never ship in EITHER edition (the Team edition ignores
  # exclude.txt, so these must be dropped here). Listed in always-skip.txt.
  if always_skipped "$rel"; then
    return 0
  fi
  if [ "$EDITION" = "individual" ] && should_skip_zip "$rel"; then
    return 0
  fi
  return 1
}

should_skip_zip() {
  local rel="$1"
  local line

  if [ "$EDITION" = "team" ]; then
    return 1
  fi

  while IFS= read -r line || [ -n "$line" ]; do
    line="${line%%#*}"
    line="${line%"${line##*[![:space:]]}"}"
    [ -z "$line" ] && continue
    line="${line%/}"
    rel="${rel%/}"
    if [ "$rel" = "$line" ] || [[ "$rel" == "$line/"* ]]; then
      return 0
    fi
  done < "$EXCLUDE_FILE"
  return 1
}

copy_path() {
  local spec="$1"
  local src="$CANONICAL/$spec"
  local dest_path="$DEST/$spec"

  if should_skip_copy "$spec"; then
    return 0
  fi

  if [ -f "$src" ]; then
    mkdir -p "$(dirname "$dest_path")"
    cp -p "$src" "$dest_path"
    return 0
  fi

  if [ -d "$src" ]; then
    mkdir -p "$dest_path"
    (
      cd "$src"
      find . -type f ! -path './.git/*' -print
    ) | while IFS= read -r relpath; do
      relpath="${relpath#./}"
      [ -z "$relpath" ] && continue
      full_rel="$spec/$relpath"
      if should_skip_copy "$full_rel"; then
        continue
      fi
      mkdir -p "$(dirname "$DEST/$full_rel")"
      cp -p "$src/$relpath" "$DEST/$full_rel"
    done
    return 0
  fi

  echo "derive.sh: include path not found on canonical: $spec" >&2
  exit 1
}

echo "derive.sh: canonical=$CANONICAL"
echo "derive.sh: destination=$DEST edition=$EDITION"

rm -rf "$DEST"
mkdir -p "$DEST"

while IFS= read -r line || [ -n "$line" ]; do
  line="${line%%#*}"
  line="${line%"${line##*[![:space:]]}"}"
  [ -z "$line" ] && continue

  if [[ "$line" == */** ]]; then
    dir="${line%/**}"
    copy_path "$dir"
  else
    copy_path "$line"
  fi
done < "$INCLUDE_FILE"

echo "derive.sh: applying scrub transforms..."
python3 - "$CANONICAL" "$DEST" <<'PY'
from __future__ import annotations

import re
import sys
from pathlib import Path

canonical = Path(sys.argv[1])
dest = Path(sys.argv[2])

TEXT_EXT = {
    ".md", ".txt", ".py", ".sh", ".json", ".yaml", ".yml", ".cff", ".sql",
    ".html", ".js", ".mjs", ".ts", ".tsx", ".toml", ".cfg", ".ini",
}

HARD_PATH = re.compile(
    ("/" + "Users" + r"/[^/\s]+")
    # hidden local runtime folders, but NOT public VCS/editor dirs: a clone URL
    # ending .git would otherwise trip this after the allowlist strips the host.
    r"|/\.(?!git\b|github\b|gitignore\b|gitattributes\b|gitkeep\b|gitmodules\b|cursor\b|vscode\b|claude\b|codex\b|gemini\b|kiro\b|compound-ai\b|agents\b|aider\b)[A-Za-z0-9_-]+\b"
)

# Version strings are NOT blanket-rewritten. A global old->new version sub
# corrupts history: it rewrites "## v2.7.0 Changes" changelog headers and the
# "v2.7.0: Cameron Sutcliff solo edition" attribution into the current version.
# Current-version stamps live literally in the canonical and are bumped at
# source; legacy references that remain are deliberate history or examples.
TOKEN_SUBS = [
    ("app.db", "app.db"),
    ("ENHANCEMENTS.md", "ENHANCEMENTS.md"),
    ("Keep internal repo paths out of the public copy.", "Keep internal repo paths out of the public copy."),
    ("several agentic systems on one machine", "several agentic systems on one machine"),
    ("on one machine", "on one machine"),
    ("a directory site", "a directory site"),
    ("ghostwrite a social presence", "ghostwrite a social presence"),
    ("paper-trade a strategy", "paper-trade a strategy"),
    (",", ","),
    (" and", " and"),
]


def load_terms(path: Path) -> list[str]:
    if not path.is_file():
        return []
    terms: list[str] = []
    for raw in path.read_text(encoding="utf-8").splitlines():
        line = raw.split("#", 1)[0].strip()
        if line:
            terms.append(line)
    terms.sort(key=len, reverse=True)
    return terms


allowlist = load_terms(canonical / "attribution-allowlist.txt")
denylist = load_terms(canonical / "leak-denylist.txt")
if not denylist:
    denylist = load_terms(canonical / "forbidden-terms.txt")
# Defense-in-depth: merge the maintainer-only literal personal terms (gitignored,
# never shipped) into the scrub denylist so any personal literal in the canonical
# is dropped at derive time, not just caught by the gate. The shipped denylist
# stays generic-pattern-only; the literals live here and apply at build time.
local_denylist = load_terms(canonical / "leak-denylist.local.txt")
if local_denylist:
    denylist = sorted(set(denylist) | set(local_denylist), key=len, reverse=True)



def drop_appendix_e(text: str) -> str:
    out: list[str] = []
    skip = False
    for line in text.splitlines(keepends=True):
        if line.startswith("### Appendix E"):
            skip = True
            continue
        if skip and (
            line.startswith("### Appendix ")
            or (line.startswith("## ") and not line.startswith("### "))
        ):
            skip = False
        if not skip:
            out.append(line)
    return "".join(out)


def scrub_allowed(line: str) -> str:
    cleaned = line
    for term in allowlist:
        cleaned = cleaned.replace(term, "")
    return cleaned


def line_is_leak(line: str) -> bool:
    cleaned = scrub_allowed(line)
    if HARD_PATH.search(cleaned):
        return True
    for marker in STRUCTURAL:
        if marker in cleaned:
            return True
    lowered = cleaned.lower()
    for term in denylist:
        if term.lower() in lowered:
            return True
    return False


RULE_DATA = {
    "attribution-allowlist.txt",
    "forbidden-terms.txt",
    "leak-denylist.txt",
    "enforcement-rules.yaml",
}


def skip_line_scrub(rel: str) -> bool:
    """Gate scripts, rule data, test fixtures, and runtime hooks reference denylist terms by design."""
    if rel in RULE_DATA:
        return True
    if rel.startswith("enforcement/bin/"):
        return True
    if rel.startswith("enforcement/tests/"):
        return True
    if rel.startswith("runtime/claude-code/"):
        return True
    return False


def transform_text(text: str, *, scrub_lines: bool = True) -> str:
    text = drop_appendix_e(text)
    for old, new in TOKEN_SUBS:
        text = text.replace(old, new)
    if scrub_lines:
        kept = [ln for ln in text.splitlines(keepends=True) if not line_is_leak(ln)]
        return "".join(kept)
    return text


def transform_file(path: Path) -> None:
    if path.suffix not in TEXT_EXT:
        return
    rel = path.relative_to(dest).as_posix()
    original = path.read_text(encoding="utf-8")
    transformed = transform_text(original, scrub_lines=not skip_line_scrub(rel))
    if transformed != original:
        path.write_text(transformed, encoding="utf-8")


for file in dest.rglob("*"):
    if not file.is_file():
        continue
    if ".git" in file.parts:
        continue
    transform_file(file)

print(f"derive.sh: transforms applied under {dest}")
PY

if [ "$EDITION" = "individual" ]; then
  echo "derive.sh: stripping Team edition entries for individual derive..."
  python3 - "$DEST" <<'PY'
from __future__ import annotations

import re
import sys
from pathlib import Path

dest = Path(sys.argv[1])
registry = dest / "doctrine/conventions/trigger-registry.yaml"
index = dest / "_skills-index.md"
handoff = dest / "HANDOFF.md"

if handoff.is_file():
    text = handoff.read_text(encoding="utf-8")
    # team-router is Team-only; remove its Tier-1 roster line and decrement the
    # Tier-1 count so HANDOFF.md stays coherent with the stripped registry
    # (check-handoff-skills.sh enforces this).
    text = re.sub(r"\n[ \t]*✓[ \t]+team-router\b[^\n]*", "", text, count=1)
    text = text.replace(
        "Tier 1: Session infrastructure (12 skills):",
        "Tier 1: Session infrastructure (11 skills):",
    )
    handoff.write_text(text, encoding="utf-8")

if registry.is_file():
    text = registry.read_text(encoding="utf-8")
    text = re.sub(
        r"\n  - skill: team-router\n(?:    .*\n)*",
        "\n",
        text,
        count=1,
    )
    registry.write_text(text, encoding="utf-8")

if index.is_file():
    text = index.read_text(encoding="utf-8")
    text = text.replace("Session Infrastructure (12)", "Session Infrastructure (11)")
    text = re.sub(
        r"\n\| team-router \|[^\n]*\n",
        "\n",
        text,
        count=1,
    )
    text = text.replace(
        "27 active SKILL.md files + 4 retired redirect stubs\n(31 SKILL.md files total)",
        "26 active SKILL.md files + 4 retired redirect stubs\n(30 SKILL.md files total)",
    )
    index.write_text(text, encoding="utf-8")

tier0 = dest / "doctrine/tiers/tier0.md"
if tier0.is_file():
    text = tier0.read_text(encoding="utf-8")
    text = text.replace("Session infrastructure (12):", "Session infrastructure (11):")
    text = text.replace(", team-router", "")
    tier0.write_text(text, encoding="utf-8")

agent_tier1 = dest / "doctrine/tiers/AGENT-tier1.md"
if agent_tier1.is_file():
    text = agent_tier1.read_text(encoding="utf-8")
    text = text.replace("12 session infrastructure skills", "11 session infrastructure skills")
    text = text.replace(", team-router", "")
    agent_tier1.write_text(text, encoding="utf-8")

print("derive.sh: individual Team edition entries removed")
PY
fi

# Regenerate the session-start benchmark from the derived tree so the committed
# numbers always match THIS edition (derived, never hand-typed; cannot drift).
if [ -f "$DEST/proof/session-start-benchmark/measure.sh" ]; then
  echo "derive.sh: regenerating proof/session-start-benchmark/results.md for $EDITION..."
  bash "$DEST/proof/session-start-benchmark/measure.sh" --emit >/dev/null 2>&1 \
    || echo "derive.sh: WARN session-start benchmark regen failed" >&2
fi

VERSION="$(python3 - <<'PY' "$DEST/CITATION.cff"
import sys
from pathlib import Path
cff = Path(sys.argv[1])
for line in cff.read_text(encoding="utf-8").splitlines():
    if line.startswith("version:"):
        print(line.split(":", 1)[1].strip())
        break
PY
)"
VERSION="${VERSION:-3.0.0}"

python3 - "$MANIFEST_PATH" "$VERSION" <<'PY'
import json
import sys
from datetime import date
from pathlib import Path

path = Path(sys.argv[1])
version = sys.argv[2]
seed = {
    "package_name": "Compound AI Operating Standards",
    "origin_id": "compound-ai",
    "authors": ["Cameron Sutcliff", "Joshua Sutcliff"],
    "canonical_url": "https://cameronsutcliff.com/compound-ai",
    "source_repo": "https://github.com/cameronpsutcliff/compound-ai",
    "version": version,
    "release_date": date.today().isoformat(),
    "license_docs": "CC-BY-4.0",
    "license_code": "Apache-2.0",
    "generated_at": "",
    "aggregate_sha256": "",
    "files": [],
}
path.write_text(json.dumps(seed, indent=2) + "\n", encoding="utf-8")
print(f"derive.sh: seeded {path}")
PY

if [ -f "$BUILD_MANIFEST" ]; then
  python3 - "$DEST" <<'PY'
import hashlib
import json
import sys
from datetime import datetime, timezone
from pathlib import Path

root = Path(sys.argv[1])
manifest_path = root / "compound-ai.manifest.json"
sha_path = root / "compound-ai.sha256"
excluded = {"compound-ai.manifest.json", "compound-ai.sha256"}
excluded_names = {".DS_Store"}


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def iter_files() -> list[Path]:
    files: list[Path] = []
    for path in root.rglob("*"):
        if not path.is_file():
            continue
        rel = path.relative_to(root).as_posix()
        if rel in excluded or path.name in excluded_names:
            continue
        if "/.git/" in f"/{rel}/":
            continue
        files.append(path)
    return sorted(files, key=lambda item: item.relative_to(root).as_posix())


def aggregate_hash(entries: list[dict]) -> str:
    digest = hashlib.sha256()
    for entry in entries:
        line = f"{entry['path']}:{entry['sha256']}:{entry['bytes']}\n"
        digest.update(line.encode("utf-8"))
    return digest.hexdigest()


manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
entries: list[dict] = []
for path in iter_files():
    rel = path.relative_to(root).as_posix()
    entries.append(
        {
            "path": rel,
            "bytes": path.stat().st_size,
            "sha256": sha256_file(path),
        }
    )

manifest["generated_at"] = datetime.now(timezone.utc).isoformat()
manifest["files"] = entries
manifest["aggregate_sha256"] = aggregate_hash(entries)
manifest_path.write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")

lines = [f"{manifest['aggregate_sha256']}  <aggregate>\n"]
lines.extend(f"{entry['sha256']}  {entry['path']}\n" for entry in entries)
sha_path.write_text("".join(lines), encoding="utf-8")

print(f"derive.sh: wrote {manifest_path}")
print(f"derive.sh: wrote {sha_path}")
print(f"derive.sh: files indexed: {len(entries)}")
PY
else
  echo "derive.sh: WARN build-manifest.py not found; manifest not fully regenerated" >&2
fi

# Shipped-script syntax gate: the line-scrub can drop a line that carries a
# private path and leave a script that no longer parses (a dropped `if ...; then`
# guard once shipped a non-parsing installer). Refuse to ship a tree whose shell
# scripts do not parse, so a stale or over-scrubbed derive can never publish a
# broken installer again.
syntax_failures=0
while IFS= read -r sh_file; do
  if ! bash -n "$sh_file" 2>/dev/null; then
    echo "derive.sh: ERROR shipped script does not parse: ${sh_file#$DEST/}" >&2
    bash -n "$sh_file" 2>&1 | sed 's/^/derive.sh:   /' >&2
    syntax_failures=$((syntax_failures + 1))
  fi
done < <(find "$DEST" -type f -name '*.sh')
if [ "$syntax_failures" -ne 0 ]; then
  echo "derive.sh: FATAL $syntax_failures shipped shell script(s) failed to parse; refusing to package" >&2
  exit 1
fi

if [ "$MAKE_ZIP" -eq 1 ]; then
  ZIP_NAME="compound-ai-${EDITION}-v${VERSION}.zip"
  ZIP_PATH="$(dirname "$DEST")/$ZIP_NAME"
  echo "derive.sh: building zip $ZIP_PATH (edition=$EDITION)"
  python3 - "$DEST" "$ZIP_PATH" "$EXCLUDE_FILE" "$EDITION" <<'PY'
import sys
import zipfile
from pathlib import Path

root = Path(sys.argv[1])
zip_path = Path(sys.argv[2])
exclude_file = Path(sys.argv[3])
edition = sys.argv[4]

excludes: list[str] = []
if edition != "team":
    for raw in exclude_file.read_text(encoding="utf-8").splitlines():
        line = raw.split("#", 1)[0].strip()
        if not line:
            continue
        excludes.append(line.rstrip("/"))

def skip(rel: str) -> bool:
    rel = rel.rstrip("/")
    for pattern in excludes:
        pat = pattern.rstrip("/")
        if rel == pat or rel.startswith(pat + "/"):
            return True
    return False

with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED) as zf:
    for path in sorted(root.rglob("*")):
        if not path.is_file():
            continue
        rel = path.relative_to(root).as_posix()
        if skip(rel):
            continue
        zf.write(path, rel)

print(f"derive.sh: wrote {zip_path}")
PY
fi

echo "derive.sh: complete -> $DEST"
