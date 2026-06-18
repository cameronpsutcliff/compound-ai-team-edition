# Project Operating Contract
# Compound AI Operating Standards v2.7.0
# Source: cameronsutcliff.com/compound-ai | License: Apache 2.0 (code) / CC BY 4.0 (docs)

Canonical URL: `https://cameronsutcliff.com/compound-ai`

## What this kit is

A vendor-neutral operating layer that turns any capable agent into a
compounding work surface: routing, token discipline, durable goals, validation,
provenance, and memory.

## What this kit is not

1. Not a prompt library.
2. Not vendor-specific. `AGENT.md` is canonical; `CLAUDE.md` points here.
3. Not a replacement for host project rules. Existing project rules win.

## Hard constraints

1. Keep `AGENT.md` and every `SKILL.md` under 100 lines (target 80).
2. Put long content in `reference/` and load it only when needed.
3. Never duplicate Tier 1 content in Tier 2 or 3. Reference upstream.
4. Credit external canon in skill source references.

## Tier model

- `tier-1-global/`: conventions, context, checklists, infrastructure skills.
- `tier-2-capabilities/`: cognitive modes, analysis, domain skills.
- `tier-3-shells/`: slide, scroll, mission-control, course.

## Context map

| Question | Load |
|---|---|
| Current project state | `STATE.md` |
| Recent changes | `session-log.md` |
| Open items | `BACKLOG.md` |
| Tier model | `_tiers.md` |
| File map | `_map.md` |
| Human skill registry | `_skills-index.md` |
| Trigger registry | `tier-1-global/conventions/trigger-registry.yaml` |
| Always-load context | `tier-1-global/context/tier0.md` |

## Context tiers

- Tier 0: always load. Short operating contract + task.
- Tier 1: current state + relevant subsystem slice.
- Tier 2: full specs, long logs, detailed design docs.
- Tier 3: do not load directly. Search or query exact files.

## Durable behavioral overlay

For non-trivial work:

1. Check `trigger-registry.yaml` before answering.
2. Route through the smallest useful skill chain.
3. Use `goal-runner` when work has a verifiable finish line.
4. Load minimum viable context.
5. Validate the rendered or user-visible contract before declaring done.
6. Write useful memory at closeout.

Claude Code `/goal` is optional. If available, it automates continuation; the
portable standard is still `goal-runner`.

## Skills

Twenty-seven skills total. See `_skills-index.md`.

Tier 1 infrastructure (13):
request-router, goal-runner, trigger-indexer, context-loader, token-economist,
engagement-bootstrap, quality-gate, pattern-promoter, provenance-check,
agent-panel-planning, agent-panel-review, release-captain, adoption-captain.

Tier 2 capabilities (14):
parallel-lens-synthesis, consequence-simulation, cross-domain-translation,
convergence-detection, detached-judgment, simulation-to-action-bridge,
nod-protocol, ultra-think, pressure-test, code-audit, autoresearch,
skill-creator, viz, stakeholder-mapping.

## Session lifecycle

Start:

1. Read this file.
2. Read `_skills-index.md`.
3. Load `request-router` and `trigger-registry.yaml`.
4. Read `STATE.md` if present.

End:

1. Record validation performed.
2. Update state/log/backlog if work changed.
3. Promote reusable patterns via `pattern-promoter`.

## Governance

Confirm before destructive data operations, force pushes, billing changes,
external publishing, auth changes, or permission changes.
