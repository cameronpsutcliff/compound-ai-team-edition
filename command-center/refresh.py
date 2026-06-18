#!/usr/bin/env python3
"""Command Center renderer for the Compound AI Team edition.

Reads a task_state.json and renders a single self-contained dark dashboard
HTML file. Pure Python 3 standard library only. No third-party imports, no
network calls.

Usage:
    python3 refresh.py [task_state.json] [command-center.html]

Completion persistence: this script only RENDERS. It never edits the state.
An item's "done" lives inside task_state.json as status: "done", so a finished
task stays finished across every rebuild. To re-open an item, edit the JSON.

Author: Cameron Sutcliff
"""

from __future__ import annotations

import argparse
import datetime
import html
import json
import os
import sys

# Workstream accents map to fixed hex values for the dark theme.
ACCENTS = {
    "blue": "#5b9bff",
    "purple": "#b18bff",
    "green": "#56d18a",
    "amber": "#f5b14c",
}

VALID_STATUS = {"open", "waiting", "done"}
STATUS_LABEL = {"open": "Open", "waiting": "Waiting", "done": "Done"}


def fail(message: str) -> None:
    """Print a clear error to stderr and exit non-zero."""
    print("ERROR: " + message, file=sys.stderr)
    sys.exit(1)


def load_state(path: str) -> dict:
    """Load and validate task_state.json against the canonical schema."""
    if not os.path.isfile(path):
        fail("state file not found: " + path)
    try:
        with open(path, "r", encoding="utf-8") as handle:
            data = json.load(handle)
    except json.JSONDecodeError as exc:
        fail("state file is not valid JSON: " + str(exc))
    except OSError as exc:
        fail("could not read state file: " + str(exc))

    if not isinstance(data, dict):
        fail("top level of state must be a JSON object")

    for field in ("generated", "owner", "headline", "workstreams"):
        if field not in data:
            fail("state is missing required field: " + field)

    if not isinstance(data["workstreams"], list):
        fail("workstreams must be a list")

    for ws in data["workstreams"]:
        if not isinstance(ws, dict):
            fail("each workstream must be an object")
        for field in ("key", "label", "accent", "lead", "items"):
            if field not in ws:
                fail("workstream is missing required field: " + field)
        if ws["accent"] not in ACCENTS:
            fail(
                "workstream '%s' has invalid accent '%s' (use blue, purple, green, or amber)"
                % (ws.get("key", "?"), ws["accent"])
            )
        if not isinstance(ws["items"], list):
            fail("workstream '%s' items must be a list" % ws.get("key", "?"))
        for item in ws["items"]:
            if not isinstance(item, dict):
                fail("each item must be an object")
            for field in ("id", "title", "status"):
                if field not in item:
                    fail("item in '%s' is missing field: %s" % (ws.get("key", "?"), field))
            if item["status"] not in VALID_STATUS:
                fail(
                    "item '%s' has invalid status '%s' (use open, waiting, or done)"
                    % (item.get("id", "?"), item["status"])
                )

    return data


def esc(value) -> str:
    """HTML-escape any value, treating None as an empty string."""
    if value is None:
        return ""
    return html.escape(str(value))


def render_item(item: dict, accent_hex: str) -> str:
    """Render one task row. Done items are checked and de-emphasized."""
    status = item["status"]
    done = status == "done"
    box = "&#10003;" if done else "&#9675;"
    row_class = "item done" if done else "item"

    meta_bits = []
    if item.get("due"):
        meta_bits.append("Due " + esc(item["due"]))
    meta_bits.append(STATUS_LABEL[status])
    meta = " &middot; ".join(meta_bits)

    note = ""
    if item.get("note"):
        note = '<div class="note">%s</div>' % esc(item["note"])

    lineage = ""
    if item.get("lineage"):
        lineage = '<div class="lineage">lineage: %s</div>' % esc(item["lineage"])

    return (
        '<li class="%s">'
        '<span class="box" style="color:%s">%s</span>'
        '<div class="body">'
        '<div class="title">%s</div>'
        '<div class="meta">%s</div>'
        "%s%s"
        "</div>"
        "</li>"
    ) % (row_class, accent_hex, box, esc(item["title"]), meta, note, lineage)


def render_workstream(ws: dict) -> str:
    """Render a single workstream card with a per-stream done count."""
    accent_hex = ACCENTS[ws["accent"]]
    items = ws["items"]
    total = len(items)
    done = sum(1 for item in items if item["status"] == "done")
    count = "%d of %d done" % (done, total)

    if items:
        rows = "\n".join(render_item(item, accent_hex) for item in items)
    else:
        rows = '<li class="item empty">No items in this workstream.</li>'

    return (
        '<section class="card" style="border-top:3px solid %s">'
        '<div class="card-head">'
        '<h2 style="color:%s">%s</h2>'
        '<div class="card-sub">Lead: %s &middot; %s</div>'
        "</div>"
        '<ul class="items">%s</ul>'
        "</section>"
    ) % (accent_hex, accent_hex, esc(ws["label"]), esc(ws["lead"]), count, rows)


def render_html(state: dict) -> str:
    """Build the full self-contained dashboard HTML string."""
    cards = "\n".join(render_workstream(ws) for ws in state["workstreams"])
    built = datetime.date.today().isoformat()

    return """<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Command Center</title>
<!-- System fonts only (Inter if locally installed, else system sans). No webfont fetch, so the dashboard renders fully offline. -->
<style>
  :root {{
    --bg: #0e1116;
    --panel: #161b22;
    --border: #232b36;
    --text: #e6edf3;
    --muted: #8b97a7;
    --faint: #5b6675;
  }}
  * {{ box-sizing: border-box; margin: 0; padding: 0; }}
  body {{
    background: var(--bg);
    color: var(--text);
    font-family: "Inter", -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
    line-height: 1.45;
    padding: 40px 24px 64px;
  }}
  .wrap {{ max-width: 1080px; margin: 0 auto; }}
  header {{ margin-bottom: 32px; }}
  .eyebrow {{
    text-transform: uppercase;
    letter-spacing: 0.12em;
    font-size: 12px;
    font-weight: 600;
    color: var(--faint);
  }}
  h1 {{ font-size: 26px; font-weight: 700; margin: 8px 0 6px; }}
  .owner {{ color: var(--muted); font-size: 14px; }}
  .built {{ color: var(--faint); font-size: 12px; margin-top: 4px; }}
  .grid {{ display: grid; gap: 20px; }}
  @media (min-width: 760px) {{
    .grid {{ grid-template-columns: repeat(2, 1fr); }}
  }}
  .card {{
    background: var(--panel);
    border: 1px solid var(--border);
    border-radius: 12px;
    padding: 20px 22px;
  }}
  .card-head {{ margin-bottom: 14px; }}
  .card h2 {{ font-size: 17px; font-weight: 600; }}
  .card-sub {{ color: var(--muted); font-size: 13px; margin-top: 3px; }}
  ul.items {{ list-style: none; }}
  li.item {{
    display: flex;
    gap: 12px;
    padding: 12px 0;
    border-top: 1px solid var(--border);
  }}
  li.item:first-child {{ border-top: none; }}
  .box {{ font-size: 16px; line-height: 1.4; flex: 0 0 auto; }}
  .body {{ flex: 1 1 auto; min-width: 0; }}
  .title {{ font-size: 15px; font-weight: 500; }}
  .meta {{ color: var(--muted); font-size: 12.5px; margin-top: 2px; }}
  .note {{ color: var(--muted); font-size: 13px; margin-top: 5px; }}
  .lineage {{ color: var(--faint); font-size: 12px; margin-top: 5px; font-family: ui-monospace, SFMono-Regular, Menlo, monospace; }}
  li.item.done .title {{ text-decoration: line-through; color: var(--muted); }}
  li.item.done {{ opacity: 0.6; }}
  li.item.empty {{ color: var(--faint); font-size: 13px; }}
  footer {{ color: var(--faint); font-size: 12px; margin-top: 36px; text-align: center; }}
</style>
</head>
<body>
<div class="wrap">
  <header>
    <div class="eyebrow">Command Center</div>
    <h1>{headline}</h1>
    <div class="owner">Owner: {owner}</div>
    <div class="built">State generated {generated} &middot; rendered {built}</div>
  </header>
  <div class="grid">
    {cards}
  </div>
  <footer>Compound AI Team edition. Completion state lives in task_state.json and persists across rebuilds.</footer>
</div>
</body>
</html>
""".format(
        headline=esc(state["headline"]),
        owner=esc(state["owner"]),
        generated=esc(state["generated"]),
        built=esc(built),
        cards=cards,
    )


def main(argv=None) -> int:
    parser = argparse.ArgumentParser(
        description="Render a Compound AI Team edition Command Center dashboard from task_state.json.",
    )
    parser.add_argument(
        "state",
        nargs="?",
        default="task_state.json",
        help="path to the task state JSON (default: ./task_state.json)",
    )
    parser.add_argument(
        "output",
        nargs="?",
        default="command-center.html",
        help="path to write the dashboard HTML (default: ./command-center.html)",
    )
    args = parser.parse_args(argv)

    state = load_state(args.state)
    page = render_html(state)

    try:
        with open(args.output, "w", encoding="utf-8") as handle:
            handle.write(page)
    except OSError as exc:
        fail("could not write output: " + str(exc))

    print("Rendered %s from %s" % (args.output, args.state))
    return 0


if __name__ == "__main__":
    sys.exit(main())
