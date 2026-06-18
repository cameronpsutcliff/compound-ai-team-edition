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
import json
import os
import shutil
import sys
import textwrap
from pathlib import Path

# The team-edition root is two levels up from this script (install/ -> team-edition/).
KIT_ROOT = Path(__file__).resolve().parent.parent
REGISTRY_TEMPLATE = KIT_ROOT / "skills" / "team-router" / "templates" / "routing-registry.md"


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


def copy_tree(src: Path, dst: Path, auto: bool) -> None:
    """Copy src into dst, asking before overwriting any existing file."""
    for item in sorted(src.rglob("*")):
        if item.is_dir():
            continue
        # Skip the installer copying its own working artifacts.
        rel = item.relative_to(src)
        if "__pycache__" in rel.parts or rel.suffix == ".pyc":
            continue
        target = dst / rel
        ensure_dir(target.parent)
        if target.exists():
            if not auto and not ask_yes(f"Overwrite existing {rel}?", False, auto):
                print(f"  kept existing {rel}")
                continue
        shutil.copy2(item, target)
        print(f"  copied {rel}")


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
    registry_dst = kit_dst / "skills" / "team-router" / "templates" / "routing-registry.md"
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
    args = parser.parse_args()
    auto = args.auto

    say(
        """
        Compound AI Team edition installer
        ----------------------------------
        This copies the kit into your cloud docs and gives your distilled
        team notes a home. It never deletes anything and asks before overwriting.
        """
    )
    print()

    # Step 2: cloud-docs root.
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

    # Step 3: notes root and Teams content area.
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

    # Step 4: routing setup.
    print()
    setup_routing(kit_dst, auto)

    # Step 5: next steps.
    cc = kit_dst / "command-center" / "refresh.py"
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
