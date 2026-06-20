---
name: team-router
description: >
  Turn pasted raw intake into distilled, routed, living team records, and keep a Command Center
  current. The core orchestrator for the Compound AI Team edition: distill, route, update the
  ledger, log, and refresh the dashboard. Self-contained, plug-and-play.
triggers:
  - organize my inbox
  - file this
  - route this intake
  - what am I on the hook for
  - update my command center
  - distill these
  - who am I working with
  - team ledger
---

# team-router

## Purpose

Paste raw intake (emails, chats, meeting notes, documents). Distill it into routed team records and
keep the Command Center current. Plain-text notes are the asset; the model is rented and swappable.
You propose routes; the human approves. Never silently guess where something goes.

Contract: `capabilities/team-routing.md`. Step detail: `reference/routing-procedure.md`.

## Step 0: Capability profile

Read `team/capability-profile.md` and branch on `vector_search`, `detail_store`, and
`scheduled_agents`. Minimal profile (filesystem only) always works. No vector DB, timer, or network
required.

## Step 1: Distill

Per item, produce key points, captured tasks, key quotes, knowledge, and a lineage link under
`knowledge/`. Link to sources; never paste raw intake into ledgers.

## Step 2: Route

Score each item against `templates/routing-registry.md`. Strong match: file it. Tie or low
confidence: propose the workstream with a one-line rationale and wait.

## Step 3: Ledger

Update the matched workstream ledger in place using `templates/team-ledger.md` (assets,
accountabilities, knowledge, people, what to run with now).

## Step 4: Log

Append checked-off accountabilities to today's daily log via `templates/daily-log.md`.

## Step 5: Command Center

Update `team/command-center/task_state.json` (schema in `reference/routing-procedure.md`). Then:

- `scheduled_agents: false` -> tell the human to run `team/command-center/refresh.py`
- `scheduled_agents: true` -> note the timer will rebuild the dashboard

## Guardrails

- Follow org policy for confidential data; ask before storing when unsure.
- Keep model output separable from source material.
- Propose low-confidence routes; never auto-file when unsure.
- Use only bundled Team edition files (templates, capability profile, `capabilities/team-routing.md`).
