# Compound AI - Team Edition

**Own the asset, rent the model. Team edition.**

A thin translation layer between your team's plain-text notes and whatever AI model you use. Your knowledge lives in folders you control. The model is interchangeable. No lock-in.

The Team edition is the complete superset of the Individual edition, plus the org layer in `team/`.

---

## Quick Start (three steps)

**Step 1: Run the installer.**

```bash
python3 team/install/install.py
```

The installer copies the kit into a "Compound AI" folder you choose, creates a Teams content area in your notes, and writes a routing registry. It walks you through a few prompts, and it never deletes anything.

**Step 2: Tell it your roots.**

When prompted, enter:

- Your cloud-docs root: the folder where project files land (Google Drive, SharePoint, wherever).
- Your notes root: the folder where your Obsidian vault (or plain markdown notes) lives.

The installer uses these to place the kit and create your Teams content area. To declare what your machine can do (vector search, scheduled runs), edit `team/capability-profile.md` by hand.

**Step 3: Point your AI at the folder and start pasting intake.**

Open your AI (Claude, GPT, Gemini, anything). Give it the contents of `team/team-router/SKILL.md` as context. Paste raw intake: emails, chat threads, meeting notes, doc summaries. The router does the rest.

---

## What Is Inside

```
team/
  README.md                              <- you are here
  capability-profile.md                  <- what this machine can do (edit locally)
  install/install.py                     <- interactive installer
  team-router/SKILL.md                   <- the routing skill (paste into your AI)
  team-router/templates/
    routing-registry.md                  <- maps topics to workstreams
    team-ledger.md                       <- living task ledger per workstream
    daily-log.md                         <- dated append-only record
  command-center/
    refresh.py                           <- renders task_state.json into the dashboard
    task_state.example.json              <- canonical schema (copy and fill in)
    README.md                            <- how to use the Command Center
```

The routing contract is also defined in `capabilities/team-routing.md` for adapter integrations.

---

## How the Core Loop Works

1. You paste raw intake into your AI with the team-router skill active.
2. The router extracts key points, tasks, key quotes, and knowledge items. It tags the source as a lineage link so nothing is orphaned.
3. Each item goes to a workstream (Platform, Data, Adoption, or Risk). The router updates that workstream's ledger in place and appends new items to the daily log.
4. The Command Center reads `task_state.json` and shows you what needs attention.

Nothing runs on a schedule unless you set one up yourself. The loop fires when you paste. That is the whole system.

---

## The Command Center

Run `python3 team/command-center/refresh.py` to regenerate the dashboard from `task_state.json`. The dashboard shows open and waiting items by workstream, grouped by lead, with due dates. Completed items (status: done) stay in the file and render struck-through and dimmed, so history stays visible but de-emphasized. You never lose history.

---

## Workstreams (defaults)

| Key | Label | Accent | Default Lead |
|-----|-------|--------|--------------|
| platform | Platform | blue | Dana Lee |
| data | Data | purple | Priya Nair |
| adoption | Adoption | green | Marco Bianchi |
| risk | Risk | amber | (unassigned) |

Edit `team/team-router/templates/routing-registry.md` to rename, add, or remove workstreams. The router adapts automatically.

---

## Capability Profile

`team/capability-profile.md` is the portability seam. It tells the router what this machine can do.

The shipped defaults are minimal and run anywhere:

```
filesystem_access: true
vector_search: none
scheduled_agents: false
detail_store: folders
```

If you have Chroma installed and want semantic recall, set `vector_search: chroma`. Everything else stays the same. The skill branches on this value so you are not locked to any stack.

Keep environment-specific overrides in a local `capability-profile.local.md` (gitignored), so the shared repo always ships the minimal profile that works on a bare laptop out of the box.

---

## Guardrails

- Confidential and client data follows your org's policy. This kit does not change that. Keep sensitive material in folders your org already approves for AI use.
- AI-generated drafts are drafts. Keep them separable from reviewed, approved content.
- You stay on the wheel. The router proposes. You decide what ships, what gets assigned, and what gets dropped.

---

## Credits

The three-layer "AI operating system" model and the A.C.E. structure are from Nick Milo (Linking Your Thinking). This kit is Compound AI by Cameron Sutcliff and Joshua Sutcliff.
