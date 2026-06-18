---
name: team-router
description: >
  Turn pasted raw intake into distilled, routed, living team records, and keep a Command Center
  current. The core orchestrator for the Compound AI Team edition: distill, route, update the
  ledger, log, and refresh the dashboard. Self-contained, plug-and-play.
triggers:
  - organize my inbox
  - file this
  - route this
  - what am I on the hook for
  - update my command center
  - distill these
  - who am I working with
  - team ledger
---

# team-router

## Purpose

You paste raw intake: emails, chat threads, meeting notes, documents. This skill turns that mess
into clean, routed, living team records and keeps a Command Center dashboard current. It composes
the daily-dashboard idea but stands alone. The asset is yours: plain-text notes the human owns. The
model is rented and swappable. This skill is the translation layer between them.

The human stays on the wheel. You propose, the human approves. You never silently guess where
something goes.

## Step 0: Read the capability profile

Read `../../capability-profile.md` first and branch on its keys. Do not assume infrastructure.

- `vector_search`: `none` means recall is folder-and-link only, search the ledgers and logs by
  reading them. `chroma` or `other` means you may also query that store for prior context. Default
  is `none`.
- `detail_store`: `folders` means full lineage detail lives in a local `knowledge/` folder you create as
  plain files. `chroma` means detail may live in a vector store; still write a folder link so the
  trail survives without it.
- `scheduled_agents`: `false` means a human runs `refresh.py` by hand. `true` means a timer
  rebuilds the dashboard, so you only update the data.

Everything below works at the minimal profile: filesystem only, no vector DB, no timer, no network.

## Step 1: Distill

For each distinct item in the intake, produce the fixed distillation contract. Never paste raw
content into the records. Link to the source instead.

1. **Key points.** The 2 to 4 facts that matter, in plain language.
2. **Captured tasks.** Each action, with owner and due date if present in the source.
3. **Key quotes.** Verbatim lines worth keeping, short and attributed.
4. **Knowledge.** Durable facts or decisions worth remembering past this week.
5. **Lineage link.** A relative path to where the source is stored, for example
   `knowledge/acme-platform-kickoff.md`. This is the trail back to the raw material.

If the source is not yet saved, save it under `knowledge/` and link to that file. The records hold
the distillation; the source holds the detail.

## Step 2: Route

Score each item against `templates/routing-registry.md`. The registry maps people signals (who is
involved) and client or keyword signals to a workstream. Example workstreams: Platform (blue), Data
(purple), Adoption (green), and the optional Risk (amber).

- Strong match: file it into that workstream.
- Low confidence or two close matches: **propose** the workstream and ask before filing. This is the
  idiot-proof default. Propose, never silently guess. Show the human your top candidate and your
  reasoning in one line, then wait.

## Step 3: Update the ledger

Write into the matched workstream's ledger using `templates/team-ledger.md` as the shape. Update in
place, do not append a new copy. The ledger is the current state of the workstream. It has five
sections:

- **Assets.** Links to deliverables, repos, decks, source files.
- **My accountabilities.** Open checkboxes, the things you owe. One line each.
- **Key knowledge.** Durable facts and decisions, each with its lineage link.
- **People.** Who is on this workstream and their role, for example Dana Lee (lead), Sam Rivera,
  Priya Nair, Marco Bianchi.
- **What to run with now.** The single next move on this workstream.

## Step 4: Log

Append every ticked-off item to the dated daily log, using `templates/daily-log.md` as the shape.
The log is history: what got done and when. The ledger is current state. When you check off an
accountability in the ledger, write that completion into today's log so the record persists.

## Step 5: Update the Command Center

Update `command-center/task_state.json` to match the canonical schema. Each workstream is an object
with `key`, `label`, `accent`, `lead`, and an `items` array. Each item has `id`, `title`, `status`,
`due`, `note`, and `lineage`.

- `status` is one of `open`, `waiting`, `done`.
- `accent` is one of `blue`, `purple`, `green`, `amber`.
- Completion lives in the data: set `status: done` and it persists across every rebuild. Never drop
  a done item; the rebuild only renders, it never decides state.

Then act on `scheduled_agents`:

- If `false` (the default): tell the human to run `command-center/refresh.py` to rebuild the
  dashboard from `task_state.json`.
- If `true`: note that the timer will rebuild it; you only needed to update the data.

## Guardrails

- Confidential or client data follows the org's policy. When in doubt, ask before storing.
- Keep generated content separable from source material so the human can always tell what the model
  produced versus what came in.
- The human stays on the wheel. Propose routes, surface low-confidence calls, and never auto-file
  something you are unsure about.
- Reference only files bundled in this Team edition: these templates and the capability profile. No
  outside references, no network calls.
