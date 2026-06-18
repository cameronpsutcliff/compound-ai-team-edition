# Tier Model

This kit is organized into three tiers. Each tier inherits everything from the tier above it.

```
tier-1-global/         ← inherited by every project, every session
  conventions/         ← style, voice, em-dash policy, skill-author rules
  context/             ← tier0 always-load, tier1-current working context
  checklists/          ← session-start, session-closeout, era transitions
  skills-core/         ← request-router + 6 session infrastructure skills
  design-system/       ← the kit tokens for shells (CSS variables, base styles)

tier-2-capabilities/   ← workhorse skills you load when the task calls for them
  skills/              ← cognitive modes, pressure-test, viz, code-audit, etc.
  templates/           ← lineage-record, model-routing, quality-gates, token-budget

tier-3-shells/         ← project scaffolds (deliverable starting points)
  slide-shell/         ← presentation deck (presentation-deck pattern)
  scroll-shell/        ← data-storytelling page (data-storytelling example)
  mission-control/     ← dashboard layout
  course-shell/        ← sequential lesson flow
```

## Inheritance rules

- **Tier 1 is universal.** Conventions and core skills apply everywhere. Loaded at session start.
- **Tier 2 is on-demand.** Capability skills load when their triggers fire. Most sessions touch 1-3 of these.
- **Tier 3 is per-deliverable.** Shells are starting points for specific output types. Pick one, fill it, ship it.

## Authoring rules

- A file in Tier 1 must be useful to every downstream consumer. If something is domain-specific, move it down.
- A file in Tier 2 should not duplicate Tier 1. Reference upstream, do not copy.
- Shells in Tier 3 inherit the design-system from Tier 1. They should not redefine tokens.

## Why this structure

The pattern is borrowed from a heavier-weight multi-tier enterprise reference pack. The same compounding logic applies: stuff that's universal lives once, stuff that's specific lives where it's specific, and inheritance makes the whole thing composable without duplication.

## Naming note

These tiers (1/2/3 = inheritance hierarchy) are unrelated to context tiers in `tier-1-global/context/` (tier0/tier1/tier2 = how much context to load for a given task). Different concept, similar word.
