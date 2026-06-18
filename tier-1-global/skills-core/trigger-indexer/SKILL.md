# Skill: trigger-indexer
# Compound AI Operating Standards v2.6.0
# Source: cameronsutcliff.com/compound-ai | License: Apache 2.0

## What this skill does

Maintains the machine-readable trigger registry used by `request-router`.
Run when skills are added, removed, renamed, or when trigger phrases change.

## Triggers

"reindex triggers", "rebuild trigger registry", "skill count changed",
"routing is stale", "new skill added", "update triggers"

## Procedure

1. Read `_skills-index.md` for the human registry.
2. Read each active `SKILL.md` trigger section or description.
3. Update `tier-1-global/conventions/trigger-registry.yaml`.
4. Ensure every active skill has one registry entry.
5. Ensure every registry pointer resolves to an existing `SKILL.md`.
6. Ensure count math matches: Tier 1 + Tier 2 cognitive + analytical + domain.
7. Report added, changed, removed, and unresolved triggers.

Registry schema: `reference/registry-schema.md`.

## Rules

- The registry is the router's canonical trigger surface.
- `_skills-index.md` is the human-readable overview.
- Do not add vague triggers that fire on normal conversation.
- Prefer action phrases and intent phrases over single keywords.
- Keep vendor-specific triggers optional. Example: `/goal` maps to
  `goal-runner`, but the portable trigger is "completion condition".

## Output format

```
TRIGGER INDEX REPORT
Skills found:
Registry entries:
Added:
Changed:
Removed:
Unresolved pointers:
Count check:
```
