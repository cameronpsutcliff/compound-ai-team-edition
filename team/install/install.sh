#!/bin/sh
# Compound AI Team edition installer (POSIX sh).
# Mirrors team/install/install.py: same layout, skips, and idempotence.
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
KIT_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/../.." && pwd)
REGISTRY_TEMPLATE="$KIT_ROOT/team/team-router/templates/routing-registry.md"

AUTO=0
DRY_RUN=0
UNINSTALL=0

usage() {
  cat <<'EOF'
Usage: install.sh [--yes|-y|--auto|--non-interactive] [--dry-run] [--uninstall]

Copies the Compound AI kit into a "Compound AI" folder under your cloud-docs
root, creates a Teams area in your notes root, and writes a routing registry.
Non-destructive: asks before overwriting unless --yes is passed.
--dry-run prints the files and Claude settings keys that would change.
--uninstall removes Compound AI Claude Code hook wiring from settings.
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    -y|--yes|--auto|--non-interactive)
      AUTO=1
      shift
      ;;
    --dry-run)
      DRY_RUN=1
      AUTO=1
      shift
      ;;
    --uninstall)
      UNINSTALL=1
      AUTO=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'install.sh: unknown argument: %s\n' "$1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

say() {
  printf '%s\n' "$1"
}

expand_user_path() {
  # Quote the tilde in the patterns so the shell matches a LITERAL leading `~`,
  # not a tilde-expanded `$HOME`. An unquoted `~/*` pattern expands to `$HOME/*`
  # and then wrongly matches any absolute path already under $HOME, doubling it.
  case "$1" in
    '~/'*)
      if [ -z "${HOME:-}" ]; then
        printf 'install.sh: HOME is not set; cannot expand %s\n' "$1" >&2
        exit 1
      fi
      printf '%s' "${HOME}${1#\~}"
      ;;
    '~')
      if [ -z "${HOME:-}" ]; then
        printf 'install.sh: HOME is not set; cannot expand ~\n' >&2
        exit 1
      fi
      printf '%s' "$HOME"
      ;;
    *)
      printf '%s' "$1"
      ;;
  esac
}

resolve_dir() {
  raw=$(expand_user_path "$1")
  case "$raw" in
    /*) abs="$raw" ;;
    *) abs="$(pwd)/$raw" ;;
  esac
  parent=$(dirname "$abs")
  base=$(basename "$abs")
  if [ -d "$abs" ]; then
    CDPATH= cd -- "$abs" && pwd
  elif [ -d "$parent" ]; then
    printf '%s/%s\n' "$(CDPATH= cd -- "$parent" && pwd)" "$base"
  else
    printf '%s\n' "$abs"
  fi
}

ask() {
  prompt=$1
  default=$2
  if [ "$AUTO" -eq 1 ]; then
    printf '%s [%s] -> %s\n' "$prompt" "$default" "$default" >&2
    printf '%s' "$default"
    return 0
  fi
  printf '%s [%s]: ' "$prompt" "$default" >&2
  IFS= read -r reply || reply=""
  if [ -z "$reply" ]; then
    printf '%s' "$default"
  else
    printf '%s' "$reply"
  fi
}

ask_yes() {
  prompt=$1
  default_yes=$2
  if [ "$AUTO" -eq 1 ]; then
    if [ "$default_yes" -eq 1 ]; then
      printf '%s (Y/n) -> yes\n' "$prompt" >&2
      return 0
    fi
    printf '%s (y/N) -> no\n' "$prompt" >&2
    return 1
  fi
  if [ "$default_yes" -eq 1 ]; then
    suffix="Y/n"
  else
    suffix="y/N"
  fi
  printf '%s (%s): ' "$prompt" "$suffix" >&2
  IFS= read -r reply || reply=""
  reply=$(printf '%s' "$reply" | tr '[:upper:]' '[:lower:]')
  if [ -z "$reply" ]; then
    [ "$default_yes" -eq 1 ]
    return $?
  fi
  case "$reply" in
    y|yes) return 0 ;;
    *) return 1 ;;
  esac
}

should_skip_copy() {
  rel=$1
  case "$rel" in
    *.pyc) return 0 ;;
  esac
  old_ifs=$IFS
  IFS=/
  set -- $rel
  IFS=$old_ifs
  for part in "$@"; do
    case "$part" in
      .git|__pycache__|reference-impl|derive|leak-denylist.local.txt)
        return 0
        ;;
    esac
  done
  return 1
}

copy_tree() {
  src=$1
  dst=$2
  find "$src" -type f | sort | while IFS= read -r item; do
    rel=${item#"$src"/}
    if should_skip_copy "$rel"; then
      continue
    fi
    target="$dst/$rel"
    mkdir -p "$(dirname "$target")"
    if [ -f "$target" ]; then
      if [ "$AUTO" -eq 0 ]; then
        if ! ask_yes "Overwrite existing $rel?" 0; then
          printf '  kept existing %s\n' "$rel"
          continue
        fi
      fi
    fi
    cp -p "$item" "$target"
    printf '  copied %s\n' "$rel"
  done
}

list_copy_tree() {
  src=$1
  dst=$2
  find "$src" -type f | sort | while IFS= read -r item; do
    rel=${item#"$src"/}
    if should_skip_copy "$rel"; then
      continue
    fi
    printf '  would copy %s -> %s\n' "$rel" "$dst/$rel"
  done
}

claude_settings_target() {
  if [ -n "${CLAUDE_SETTINGS:-}" ]; then
    printf '%s' "$CLAUDE_SETTINGS"
    return 0
  fi
  if [ -z "${HOME:-}" ]; then
    printf 'install.sh: HOME is not set; cannot locate Claude settings\n' >&2
    exit 1
  fi
  printf '%s/.claude/settings.json' "$HOME"
}

preview_claude_runtime() {
  adapter="$KIT_ROOT/runtime/claude-code/install-adapter.sh"
  [ -f "$adapter" ] || return 0
  if ! command -v python3 >/dev/null 2>&1; then
    say "DRY RUN: python3 not found; would skip Claude settings merge."
    return 0
  fi
  bash "$adapter" --dry-run --settings "$(claude_settings_target)"
}

uninstall_claude_runtime() {
  adapter="$KIT_ROOT/runtime/claude-code/install-adapter.sh"
  [ -f "$adapter" ] || return 0
  if ! command -v python3 >/dev/null 2>&1; then
    say "Uninstall skipped: python3 is required for JSON settings updates."
    exit 1
  fi
  bash "$adapter" --uninstall --settings "$(claude_settings_target)"
  say "No kit files, Teams notes, or routing registries were deleted."
}

setup_teams_area() {
  notes_root=$1
  teams="$notes_root/Teams"
  mkdir -p "$teams"
  readme="$teams/README.md"
  if [ ! -f "$readme" ]; then
    cat >"$readme" <<'EOF'
# Teams

This is where distilled team content lives. team-router writes here:
a living ledger per workstream, a dated daily log, and lineage links
back to the raw source it came from.

You own these notes. The AI model is rented and swappable.
EOF
    printf '  wrote %s\n' "Teams/README.md"
  else
    printf '  kept existing Teams/README.md\n'
  fi
}

write_custom_registry() {
  registry_dst=$1
  say ""
  say "Set up your workstreams now. Press Enter on an empty name to finish."
  say "Accents you can use: blue, purple, green, amber."
  say ""

  tmp_registry=$(mktemp "${TMPDIR:-/tmp}/routing-registry.XXXXXX")
  {
    printf '%s\n' "# Routing registry" ""
    printf '%s\n' "team-router reads this file to decide which workstream each distilled item belongs to."
    printf '%s\n' "Match on people signals or client and keyword signals. On a tie or no clear match, team-router proposes and asks before filing."
    printf '%s\n' ""
    printf '%s\n' "| Workstream / folder | People (signals) | Clients / keywords |"
    printf '%s\n' "| --- | --- | --- |"
  } >"$tmp_registry"

  row_count=0
  while :; do
    printf '  Workstream name (empty to finish): '
    IFS= read -r name || name=""
    if [ -z "$name" ]; then
      break
    fi
    printf '    Key people / signals (comma separated): '
    IFS= read -r people || people=""
    printf '    Clients / keywords (comma separated): '
    IFS= read -r keywords || keywords=""
    printf '| %s | %s | %s |\n' "$name" "$people" "$keywords" >>"$tmp_registry"
    row_count=$((row_count + 1))
  done

  if [ "$row_count" -eq 0 ]; then
    say "No workstreams entered. Falling back to the starter registry."
    cp -p "$REGISTRY_TEMPLATE" "$registry_dst"
    rm -f "$tmp_registry"
    printf '  wrote %s (starter)\n' "$(basename "$registry_dst")"
    return 0
  fi

  {
    printf '%s\n' ""
    printf '%s\n' "## Routing rules"
    printf '%s\n' ""
    printf '%s\n' "- Highest signal match wins."
    printf '%s\n' "- If two workstreams tie or none match well, propose and ask."
    printf '%s\n' "- Add a row when a new person or client appears."
    printf '%s\n' "- Keep it small."
  } >>"$tmp_registry"
  cp -p "$tmp_registry" "$registry_dst"
  rm -f "$tmp_registry"
  printf '  wrote %s with %s workstream(s)\n' "$(basename "$registry_dst")" "$row_count"
}

setup_routing() {
  kit_dst=$1
  registry_dst="$kit_dst/team/team-router/templates/routing-registry.md"
  mkdir -p "$(dirname "$registry_dst")"

  if [ "$AUTO" -eq 1 ]; then
    say "Routing: using the starter team structure."
    cp -p "$REGISTRY_TEMPLATE" "$registry_dst"
    printf '  wrote %s (starter)\n' "$(basename "$registry_dst")"
    return 0
  fi

  say ""
  say "Routing setup. Two choices:"
  say "  1. Starter team structure (Platform, Data, Adoption). Fast."
  say "  2. Set up your teams now. A few questions per team."
  say ""

  if ask_yes "Use the starter team structure?" 1; then
    cp -p "$REGISTRY_TEMPLATE" "$registry_dst"
    printf '  wrote %s (starter)\n' "$(basename "$registry_dst")"
  else
    write_custom_registry "$registry_dst"
  fi
}

setup_claude_runtime() {
  kit_dst=$1
  adapter="$kit_dst/runtime/claude-code/install-adapter.sh"
  if [ ! -f "$adapter" ]; then
    return 0
  fi
  if ! command -v python3 >/dev/null 2>&1; then
    say ""
    say "Claude Code wiring (optional): python3 is not available on this machine."
    say "  Preview merge: bash \"$adapter\" --dry-run"
    say "  Apply merge:   bash \"$adapter\" --install"
    return 0
  fi
  if [ "$AUTO" -eq 1 ]; then
    say ""
    say "Claude Code wiring (optional): skipped in non-interactive mode."
    say "  Preview merge: bash \"$adapter\" --dry-run"
    say "  Apply merge:   bash \"$adapter\" --install"
    return 0
  fi
  say ""
  if ask_yes "Merge Claude Code runtime hooks into ~/.claude/settings.json?" 0; then
    if bash "$adapter" --install; then
      say "  Claude Code settings updated."
    else
      say "  Claude Code wiring failed. Run manually:"
      say "    bash \"$adapter\" --dry-run"
    fi
  else
    say "  Skipped Claude Code wiring. Preview anytime:"
    say "    bash \"$adapter\" --dry-run"
  fi
}

main() {
  if [ "$UNINSTALL" -eq 1 ]; then
    say "Compound AI Team edition uninstall"
    uninstall_claude_runtime
    exit 0
  fi

  say "Compound AI Team edition installer"
  say "----------------------------------"
  say "This copies the kit into your cloud docs and gives your distilled"
  say "team notes a home. It never deletes anything and asks before overwriting."
  say ""

  docs_raw=$(ask "Where do your online documents live, for example a OneDrive folder?" "$(pwd)")
  docs_root=$(resolve_dir "$docs_raw")
  kit_dst="$docs_root/Compound AI"

  say ""
  say "Will copy the kit into: $kit_dst"
  if [ "$DRY_RUN" -eq 1 ]; then
    say "DRY RUN: no files or settings will be changed."
    list_copy_tree "$KIT_ROOT" "$kit_dst"
    say ""
    notes_raw=$(ask "Where is your Obsidian or notes root?" "$(pwd)")
    notes_root=$(resolve_dir "$notes_raw")
    say "Would create Teams area in: $notes_root"
    say "Would write starter routing registry in: $kit_dst/team/team-router/templates/routing-registry.md"
    say ""
    preview_claude_runtime
    exit 0
  fi

  if ! ask_yes "Proceed?" 1; then
    say "Stopped. Nothing was written."
    exit 1
  fi

  mkdir -p "$kit_dst"
  copy_tree "$KIT_ROOT" "$kit_dst"

  say ""
  notes_raw=$(ask "Where is your Obsidian or notes root?" "$(pwd)")
  notes_root=$(resolve_dir "$notes_raw")
  say ""
  say "Will create a Teams area in: $notes_root"
  if ask_yes "Proceed?" 1; then
    mkdir -p "$notes_root"
    setup_teams_area "$notes_root"
  else
    say "Skipped the Teams area."
  fi

  say ""
  setup_routing "$kit_dst"

  setup_claude_runtime "$kit_dst"

  cc="$kit_dst/team/command-center/refresh.py"
  say ""
  say "Done. Installed kit root:"
  say "  $kit_dst"
  say ""
  say "Verify the install:"
  say "  bash \"$kit_dst/enforcement/bin/check-kit.sh\" \"$kit_dst\""
  say ""
  say "Next steps:"
  say "  1. Point your AI at this folder: $kit_dst"
  say "  2. Paste raw intake (emails, chats, docs) and ask it to run team-router."
  say "     It distills, routes each item to a workstream, updates the ledger,"
  say "     and appends checked-off items to the dated daily log."
  say "  3. Build the Command Center dashboard:"
  say "     python3 \"$cc\""
  say "     Open the HTML it writes next to task_state.json."
  say ""
  say "You own the notes. The model is rented and swappable."
}

main "$@"
