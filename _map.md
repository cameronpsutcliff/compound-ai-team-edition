# Map

Navigation map for Compound AI Operating Standards v2.7.0. Tier model lives in `_tiers.md`.

## Root files

| Path | Purpose |
|---|---|
| `README.md` | Public-facing intro |
| `AGENT.md` | Root operating contract |
| `HANDOFF.md` | Drop-in prompt for handing the kit to a fresh agent |
| `INSTALL.md` | Multi-agent setup walkthrough; free-tier options |
| `CLAUDE.md` | 3-line pointer to AGENT.md (Claude Code convention) |
| `_tiers.md` | Inheritance model explanation |
| `_skills-index.md` | Complete human skill registry, 27 skills across tiers |
| `_citations.md` | Attribution registry; tooltip source for field guide reader |
| `_map.md` | This file |
| `Project.md` | Human project overview |
| `STATE.md` | Current state of this kit's development |
| `session-log.md` | Append-only history |
| `BACKLOG.md` | Open work |

## Tier 1 -- Global (universal, inherited by everything)

| Path | Purpose |
|---|---|
| `tier-1-global/AGENT.md` | Tier 1 operating rules |
| `tier-1-global/conventions/` | style-guide, token-efficiency, skill-author-guide, provenance, session-log-format, trigger-registry |
| `tier-1-global/context/` | tier0.md (always-load), tier1-current.md, tier1-subsystem/ |
| `tier-1-global/checklists/` | session-start, session-closeout, era transitions, model-routing, new-project, pattern-promotion |
| `tier-1-global/skills-core/` | 13 session infrastructure skills including request-router, goal-runner, trigger-indexer, release-captain, adoption-captain |
| `tier-1-global/design-system/` | the kit CSS tokens for use in Tier 3 shells |

## Tier 2 -- Capabilities (on-demand)

| Path | Purpose |
|---|---|
| `tier-2-capabilities/AGENT.md` | Tier 2 operating rules |
| `tier-2-capabilities/skills/` | 15 capability skills (7 cognitive modes + 5 analytical + 2 domain + 1 orchestration). Cognitive modes ship `reference/protocol.md` files for full operationalization. |
| `tier-2-capabilities/templates/` | lineage-record, loop-spec, model-routing, quality-gates, token-budget |

## Tier 3 -- Shells (project scaffolds)

| Path | Purpose |
|---|---|
| `tier-3-shells/AGENT.md` | Tier 3 operating rules |
| `tier-3-shells/slide-shell/` | Presentation deck scaffold (keyboard nav, speaker notes, fullscreen) |
| `tier-3-shells/scroll-shell/` | Data-storytelling scaffold (Framer Motion, sliders, Recharts) |
| `tier-3-shells/mission-control/` | Dashboard scaffold |
| `tier-3-shells/course-shell/` | Sequential lesson scaffold |

## Support directories

| Path | Purpose |
|---|---|
| `code/` | Reference implementations (cache_key.py, schema_validator.py, pipeline_runs.sql, phase_wrapper.sh) |
| `scripts/` | build-manifest.py, verify-integrity.py, verify-origin.py, new-project.sh |
| `hooks/` | git hooks (pre-commit/no-em-dashes, post-session/append-state) |
| `docs/` | FIELD-GUIDE.md and related publication docs |
| `releases/` | Versioned release archives |

## Upstream Pointers

| Need | Path |
|---|---|
| Canonical framework | `https://cameronsutcliff.com/compound-ai` |
| Source repo | `https://github.com/cameronpsutcliff/compound-ai-operating-standards` |
| Field guide | `https://cameronsutcliff.com/compound-ai/field-guide` |

## Rule

Use this file for navigation. Do not overload `AGENT.md` with file listings.
