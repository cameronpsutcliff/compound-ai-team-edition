#!/usr/bin/env python3
"""Compound AI Team edition installer.

Idiot-proof, plug-and-play setup. Pure Python 3 standard library only.

What it does:
  1. Copies this kit into a "Compound AI" folder under your cloud-docs root.
  2. Creates a "Teams" content area in your notes root for distilled output.
  3. Sets up a routing registry, either a starter or one built from your answers.

Non-destructive: it asks before overwriting and never deletes anything.
"""

from __future__ import annotations

import argparse
import copy
import json
import os
import shutil
import sys
import textwrap
from pathlib import Path

# Kit root is two levels up from install/ (install/ -> team/ -> operating-standards/).
KIT_ROOT = Path(__file__).resolve().parent.parent.parent
REGISTRY_TEMPLATE = (
    KIT_ROOT / "team" / "team-router" / "templates" / "routing-registry.md"
)
SETTINGS_FRAGMENT = KIT_ROOT / "runtime" / "claude-code" / "settings.fragment.json"

# Paths to skip when copying the full kit (maintainer-only or regenerable).
COPY_SKIP_PARTS = {
    ".git",
    "__pycache__",
    "reference-impl",
    "derive",
    "leak-denylist.local.txt",
}


def say(text: str) -> None:
    print(textwrap.dedent(text).strip("\n"))


def ask(prompt: str, default: str, auto: bool) -> str:
    """Ask a question with a default. In auto mode, return the default."""
    if auto:
        print(f"{prompt} [{default}] -> {default}")
        return default
    try:
        reply = input(f"{prompt} [{default}]: ").strip()
    except EOFError:
        return default
    return reply or default


def ask_yes(prompt: str, default_yes: bool, auto: bool) -> bool:
    suffix = "Y/n" if default_yes else "y/N"
    if auto:
        print(f"{prompt} ({suffix}) -> {'yes' if default_yes else 'no'}")
        return default_yes
    try:
        reply = input(f"{prompt} ({suffix}): ").strip().lower()
    except EOFError:
        return default_yes
    if not reply:
        return default_yes
    return reply.startswith("y")


def resolve_dir(raw: str) -> Path:
    """Expand ~ and make absolute. Does not require the path to exist yet."""
    return Path(os.path.expanduser(raw.strip())).resolve()


def ensure_dir(path: Path) -> None:
    path.mkdir(parents=True, exist_ok=True)


def should_skip_copy(rel: Path) -> bool:
    if rel.suffix == ".pyc":
        return True
    return any(part in COPY_SKIP_PARTS for part in rel.parts)


def copy_tree(src: Path, dst: Path, auto: bool) -> None:
    """Copy src into dst, asking before overwriting any existing file."""
    for item in sorted(src.rglob("*")):
        if item.is_dir():
            continue
        rel = item.relative_to(src)
        if should_skip_copy(rel):
            continue
        target = dst / rel
        ensure_dir(target.parent)
        if target.exists():
            if not auto and not ask_yes(f"Overwrite existing {rel}?", False, auto):
                print(f"  kept existing {rel}")
                continue
        shutil.copy2(item, target)
        print(f"  copied {rel}")


def list_copy_tree(src: Path, dst: Path) -> None:
    for item in sorted(src.rglob("*")):
        if item.is_dir():
            continue
        rel = item.relative_to(src)
        if should_skip_copy(rel):
            continue
        print(f"  would copy {rel} -> {dst / rel}")


def claude_settings_path() -> Path:
    configured = os.environ.get("CLAUDE_SETTINGS")
    if configured:
        return Path(os.path.expanduser(configured)).resolve()
    home = os.environ.get("HOME")
    if not home:
        raise RuntimeError("HOME is not set; cannot locate Claude settings")
    return (Path(home) / ".claude" / "settings.json").resolve()


def load_json_object(path: Path, default: dict | None) -> dict | None:
    if not path.exists():
        return copy.deepcopy(default)
    with path.open("r", encoding="utf-8") as handle:
        data = json.load(handle)
    if not isinstance(data, dict):
        raise RuntimeError(f"settings must be a JSON object: {path}")
    return data


def settings_keys(fragment: dict) -> list[str]:
    keys = []
    hooks = fragment.get("hooks")
    if isinstance(hooks, dict):
        keys.extend(f"hooks.{event}" for event in sorted(hooks))
    keys.extend(
        key for key in sorted(fragment) if key != "hooks" and not key.startswith("_")
    )
    return keys


def merge_settings(base: dict, fragment: dict) -> dict:
    merged = copy.deepcopy(base)
    hooks = merged.get("hooks")
    if not isinstance(hooks, dict):
        hooks = {}
    else:
        hooks = copy.deepcopy(hooks)
    patch_hooks = fragment.get("hooks")
    if isinstance(patch_hooks, dict):
        for event, entries in patch_hooks.items():
            kit_entries = copy.deepcopy(entries) if isinstance(entries, list) else [copy.deepcopy(entries)]
            existing = hooks.get(event)
            existing = list(existing) if isinstance(existing, list) else []
            # Append the kit's hook entries; never replace a user's existing
            # hooks for this event. Dedupe by exact match so re-install stays
            # idempotent. This keeps the "never deletes" promise true.
            for entry in kit_entries:
                if entry not in existing:
                    existing.append(entry)
            hooks[event] = existing
        merged["hooks"] = hooks
    for key, value in fragment.items():
        if key == "hooks" or key.startswith("_"):
            continue
        merged[key] = copy.deepcopy(value)
    return merged


def remove_settings(current: dict, fragment: dict, backup_data: dict | None) -> dict:
    result = copy.deepcopy(current)
    hooks = result.get("hooks")
    if not isinstance(hooks, dict):
        hooks = {}
    else:
        hooks = copy.deepcopy(hooks)
    backup_hooks = backup_data.get("hooks", {}) if isinstance(backup_data, dict) else {}
    if not isinstance(backup_hooks, dict):
        backup_hooks = {}
    patch_hooks = fragment.get("hooks")
    if isinstance(patch_hooks, dict):
        for event, entries in patch_hooks.items():
            kit_entries = entries if isinstance(entries, list) else [entries]
            if isinstance(backup_data, dict) and event in backup_hooks:
                hooks[event] = copy.deepcopy(backup_hooks[event])
            else:
                existing = hooks.get(event)
                if isinstance(existing, list):
                    # Remove only the kit's own entries; preserve user hooks.
                    remaining = [e for e in existing if e not in kit_entries]
                    if remaining:
                        hooks[event] = remaining
                    else:
                        hooks.pop(event, None)
                elif existing == entries:
                    hooks.pop(event, None)
    if hooks:
        result["hooks"] = hooks
    else:
        result.pop("hooks", None)
    for key, value in fragment.items():
        if key == "hooks" or key.startswith("_"):
            continue
        if isinstance(backup_data, dict) and key in backup_data:
            result[key] = copy.deepcopy(backup_data[key])
        elif result.get(key) == value:
            result.pop(key, None)
    return result


def load_settings_fragment() -> dict:
    if not SETTINGS_FRAGMENT.exists():
        raise RuntimeError(f"missing settings fragment: {SETTINGS_FRAGMENT}")
    data = load_json_object(SETTINGS_FRAGMENT, {})
    assert isinstance(data, dict)
    return data


def preview_claude_settings() -> None:
    fragment = load_settings_fragment()
    target = claude_settings_path()
    base = load_json_object(target, {})
    assert isinstance(base, dict)
    merged = merge_settings(base, fragment)
    print(f"DRY RUN: would merge Claude settings into {target}")
    print("Compound AI settings keys: " + ", ".join(settings_keys(fragment)))
    print(json.dumps(merged, indent=2, sort_keys=True))


def install_claude_settings() -> None:
    fragment = load_settings_fragment()
    target = claude_settings_path()
    base = load_json_object(target, {})
    assert isinstance(base, dict)
    merged = merge_settings(base, fragment)
    ensure_dir(target.parent)
    backup = Path(str(target) + ".compound-ai-bak")
    if target.exists() and not backup.exists():
        shutil.copy2(target, backup)
        print(f"  Backup written: {backup}")
    target.write_text(json.dumps(merged, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    print(f"  Installed merged Claude settings: {target}")


def uninstall_claude_settings() -> None:
    fragment = load_settings_fragment()
    target = claude_settings_path()
    if not target.exists():
        print(f"No Claude settings found at: {target}")
        return
    current = load_json_object(target, {})
    assert isinstance(current, dict)
    backup = Path(str(target) + ".compound-ai-bak")
    backup_data = load_json_object(backup, None) if backup.exists() else None
    updated = remove_settings(current, fragment, backup_data)
    target.write_text(json.dumps(updated, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    if backup.exists():
        print(f"Uninstalled Compound AI hooks using backup baseline: {backup}")
    else:
        print(f"Uninstalled Compound AI hooks without backup: {target}")
    print("No kit files, Teams notes, or routing registries were deleted.")


def write_custom_registry(path: Path) -> None:
    """Interactively build a routing-registry.md from the user's answers."""
    say(
        """
        Set up your workstreams now. Press Enter on an empty name to finish.
        Accents you can use: blue, purple, green, amber.
        """
    )
    rows = []
    while True:
        name = input("  Workstream name (empty to finish): ").strip()
        if not name:
            break
        people = input("    Key people / signals (comma separated): ").strip()
        keywords = input("    Clients / keywords (comma separated): ").strip()
        rows.append((name, people, keywords))

    if not rows:
        say("No workstreams entered. Falling back to the starter registry.")
        shutil.copy2(REGISTRY_TEMPLATE, path)
        return

    lines = [
        "# Routing registry",
        "",
        "team-router reads this file to decide which workstream each distilled item belongs to.",
        "Match on people signals or client and keyword signals. On a tie or no clear match, team-router proposes and asks before filing.",
        "",
        "| Workstream / folder | People (signals) | Clients / keywords |",
        "| --- | --- | --- |",
    ]
    for name, people, keywords in rows:
        lines.append(f"| {name} | {people} | {keywords} |")
    lines.extend([
        "",
        "## Routing rules",
        "",
        "- Highest signal match wins.",
        "- If two workstreams tie or none match well, propose and ask.",
        "- Add a row when a new person or client appears.",
        "- Keep it small.",
    ])
    path.write_text("\n".join(lines), encoding="utf-8")
    print(f"  wrote {path.name} with {len(rows)} workstream(s)")


def setup_routing(kit_dst: Path, auto: bool) -> None:
    registry_dst = (
        kit_dst / "team" / "team-router" / "templates" / "routing-registry.md"
    )
    ensure_dir(registry_dst.parent)
    if auto:
        say("Routing: using the starter team structure.")
        shutil.copy2(REGISTRY_TEMPLATE, registry_dst)
        print(f"  wrote {registry_dst.name} (starter)")
        return
    say(
        """
        Routing setup. Two choices:
          1. Starter team structure (Platform, Data, Adoption). Fast.
          2. Set up your teams now. A few questions per team.
        """
    )
    use_starter = ask_yes("Use the starter team structure?", True, auto)
    if use_starter:
        shutil.copy2(REGISTRY_TEMPLATE, registry_dst)
        print(f"  wrote {registry_dst.name} (starter)")
    else:
        write_custom_registry(registry_dst)


def setup_teams_area(notes_root: Path) -> None:
    teams = notes_root / "Teams"
    ensure_dir(teams)
    readme = teams / "README.md"
    if not readme.exists():
        readme.write_text(
            textwrap.dedent(
                """
                # Teams

                This is where distilled team content lives. team-router writes here:
                a living ledger per workstream, a dated daily log, and lineage links
                back to the raw source it came from.

                You own these notes. The AI model is rented and swappable.
                """
            ).strip()
            + "\n",
            encoding="utf-8",
        )
        print(f"  wrote {readme.relative_to(notes_root)}")
    else:
        print("  kept existing Teams/README.md")


def setup_claude_runtime(auto: bool) -> None:
    if auto:
        say(
            f"""
            Claude Code wiring (optional): skipped in non-interactive mode.
              Preview merge: python3 "{Path(__file__).resolve()}" --dry-run
              Apply merge:   run this installer interactively and approve the prompt
            """
        )
        return
    if ask_yes("Merge Claude Code runtime hooks into ~/.claude/settings.json?", False, auto):
        install_claude_settings()
    else:
        say(
            f"""
              Skipped Claude Code wiring. Preview anytime:
                python3 "{Path(__file__).resolve()}" --dry-run
            """
        )


def main() -> int:
    parser = argparse.ArgumentParser(description="Install the Compound AI Team edition.")
    parser.add_argument(
        "--auto",
        "--yes",
        "--non-interactive",
        dest="auto",
        action="store_true",
        help="Use defaults for every prompt, no questions asked.",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Print planned copies and Claude settings keys without writing anything.",
    )
    parser.add_argument(
        "--uninstall",
        action="store_true",
        help="Remove Compound AI Claude Code hook wiring from settings.",
    )
    args = parser.parse_args()
    auto = args.auto

    if args.uninstall:
        say("Compound AI Team edition uninstall")
        uninstall_claude_settings()
        return 0

    say(
        """
        Compound AI Team edition installer
        ----------------------------------
        This copies the kit into your cloud docs and gives your distilled
        team notes a home. It never deletes anything and asks before overwriting.
        """
    )
    print()

    if args.dry_run:
        docs_root = resolve_dir(os.getcwd())
        kit_dst = docs_root / "Compound AI"
        notes_root = resolve_dir(os.getcwd())
        say(f"DRY RUN: would copy the kit into: {kit_dst}")
        list_copy_tree(KIT_ROOT, kit_dst)
        say(f"\nWould create Teams area in: {notes_root}")
        say(
            "Would write starter routing registry in: "
            f"{kit_dst / 'team' / 'team-router' / 'templates' / 'routing-registry.md'}"
        )
        print()
        preview_claude_settings()
        return 0

    docs_raw = ask(
        "Where do your online documents live, for example a OneDrive folder?",
        os.getcwd(),
        auto,
    )
    docs_root = resolve_dir(docs_raw)
    kit_dst = docs_root / "Compound AI"
    say(f"\nWill copy the kit into: {kit_dst}")
    if not ask_yes("Proceed?", True, auto):
        say("Stopped. Nothing was written.")
        return 1
    ensure_dir(kit_dst)
    copy_tree(KIT_ROOT, kit_dst, auto)

    print()
    notes_raw = ask(
        "Where is your Obsidian or notes root?",
        os.getcwd(),
        auto,
    )
    notes_root = resolve_dir(notes_raw)
    say(f"\nWill create a Teams area in: {notes_root}")
    if ask_yes("Proceed?", True, auto):
        ensure_dir(notes_root)
        setup_teams_area(notes_root)
    else:
        say("Skipped the Teams area.")

    print()
    setup_routing(kit_dst, auto)

    print()
    setup_claude_runtime(auto)

    cc = kit_dst / "team" / "command-center" / "refresh.py"
    print()
    say(
        f"""
        Done. Next steps:
          1. Point your AI at this folder: {kit_dst}
          2. Paste raw intake (emails, chats, docs) and ask it to run team-router.
             It distills, routes each item to a workstream, updates the ledger,
             and appends checked-off items to the dated daily log.
          3. Build the Command Center dashboard:
             python3 "{cc}"
             Open the HTML it writes next to task_state.json.

        You own the notes. The model is rented and swappable.
        """
    )
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except KeyboardInterrupt:
        print("\nCancelled. Nothing was deleted.")
        sys.exit(130)
