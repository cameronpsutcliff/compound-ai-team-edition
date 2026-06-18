# Compound AI Operating Standards v2.6.0

Release date: 2026-05-20

Canonical URL: `https://cameronsutcliff.com/compound-ai`

Source repo: `https://github.com/cameronpsutcliff/compound-ai-operating-standards`

## What ships

1. `compound-ai-starter-kit-v2.6.0.zip`
2. `RELEASE-NOTES.md`
3. `SHA256SUMS`

## What's new in v2.6.0

v2.6.0 turns the kit from a standards package into a durable behavioral
overlay. v2.5.0 made adoption safe; v2.6.0 makes adoption active.

### New skill: `goal-runner` (Tier 1)

`goal-runner` is the portable goal loop:

1. Objective
2. Completion condition
3. Validation
4. Context budget
5. Stop conditions
6. Memory update

It includes the durable operating rules pulled from production lessons in durable agentic systems:
slow-lane quarantines, selector/repair symmetry, rendered contract checks,
prompt/gate corpus symmetry, backward-and-forward quality gates, finish-the-list
discipline, time budgets, item caps, and resume points.

Claude Code `/goal` is supported as an adapter for Claude Code v2.1.139+.
The kit does not depend on it. Codex, Cursor, Aider, Continue, and other agents
use the same goal contract manually through `goal-runner`.

### New skill: `trigger-indexer` (Tier 1)

`trigger-indexer` maintains the machine-readable registry used by
`request-router`. It checks active `SKILL.md` files, updates the registry, and
reports count drift, unresolved pointers, added triggers, changed triggers, and
removed triggers.

### New convention: `trigger-registry.yaml`

The router no longer relies only on prose inside `request-router`. The
canonical trigger surface now lives at:

`tier-1-global/conventions/trigger-registry.yaml`

This is the clean public equivalent of the trigger registry pattern that made an internal reference pack more operational in enterprise use.

### Router update

`request-router` now reads the registry first. It still handles panel offers and
compound requests, but the registry is canonical for skill activation.

### Adoption update

`adoption-captain` Stage 8b now commits a behavioral overlay, not only a kit
pointer. Adopted host agents are instructed to:

- Check the trigger registry before complex replies
- Route through the smallest useful skill chain
- Use `goal-runner` for verifiable multi-step work
- Load minimum viable context
- Validate the rendered/user-visible contract
- Write useful memory at closeout
- Preserve host project rules above kit defaults

### Quality-gate update

`quality-gate` now checks rendered contracts and prompt/gate corpus symmetry,
and it records slow-lane behavior for repeated gate failures.

## Count correction

The live v2.5.0 branch had count drift: public surfaces said 23 skills while
the repo contained 25 `SKILL.md` files. v2.6.0 corrects the arithmetic and adds
two new Tier 1 skills:

| Tier | v2.5.0 actual | v2.6.0 | Delta |
|---|---:|---:|---:|
| Tier 1 infrastructure | 11 | 13 | +2 |
| Tier 2 cognitive | 7 | 7 | 0 |
| Tier 2 analytical | 5 | 5 | 0 |
| Tier 2 domain | 2 | 2 | 0 |
| **Total** | **25** | **27** | **+2** |

## Pointer budget

All active `SKILL.md` files remain under 100 lines, target 80. The exact check
is part of `release-captain`.

## Source pattern lineage

The v2.6.0 overlay is grounded in durable-agentic-system lessons from production:

- enhancement logs from production runs
- durable-agentic-systems patterns, especially quarantine slow lanes,
  selector/repair symmetry, rendered contract checks, prompt/gate corpus
  symmetry, cache attribution, schema validation, and observability-first jobs

These references stay outside the startup payload. The kit imports the operating
behaviors, not the source-system-specific implementation details.

## License

Documentation and templates: CC BY 4.0.

Code samples and scripts: Apache 2.0.

Attribution: Compound AI Operating Standards by Cameron Sutcliff.
