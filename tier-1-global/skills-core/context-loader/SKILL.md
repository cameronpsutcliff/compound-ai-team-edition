# Skill: context-loader
# Compound AI Operating Standards
# Source: cameronsutcliff.com/compound-ai | License: Apache 2.0

## What this skill does
Determines the right context tier for the current task and loads only what is needed.

## Triggers
"load context", "what should I read", "start session", "orient me"

## Decision rules
- Mechanical fix (one file): load tier0 only
- Subsystem work: load tier0 + relevant tier1-subsystem slice
- Cross-subsystem or architecture: load tier0 + tier1-current + relevant tier2 section
- Ambiguous task: load tier0 + tier1-current, then query knowledge index

## What it loads
- Always: `context/tier0.md`
- Most sessions: `context/tier1-current.md`
- On demand: `context/tier1-subsystem/[relevant].md`
- Never directly: full codebase, full session archive (use search instead)

## Output
A context bundle ready for the session prompt. Estimated token cost by tier:
- Tier 0 only: 300-500 tokens
- Tier 0 + Tier 1: 800-2,000 tokens
- Tier 0 + Tier 1 + Tier 2 section: 3,000-6,000 tokens

## Source references
- `context/tier0.md` -- always-load operating contract
- `context/tier1-current.md` -- live state
- `AGENT.md` -- full operating contract with context map
- Field Guide Chapter 8: Tiered Context Loading
