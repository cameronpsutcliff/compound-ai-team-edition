# Tier 0 Context
# Compound AI Operating Standards v2.7.0
# Source: cameronsutcliff.com/compound-ai | License: Apache 2.0

Always load this for non-trivial work.

1. Project: [name]
2. Phase: [Demo | Ramp-up | Durable]
3. Primary constraint: [constraint]
4. Source of current state: `STATE.md`
5. Source of recent changes: `session-log.md`

---

## Capabilities available in this kit (27 skills)

Load `_skills-index.md` for the full registry with triggers and pointers.
Load `tier-1-global/conventions/trigger-registry.yaml` when trigger behavior matters.

**Tier 1 - Session infrastructure (13):**
request-router (load at session start), context-loader, token-economist,
engagement-bootstrap, quality-gate, pattern-promoter, provenance-check,
adoption-captain, release-captain, agent-panel-planning,
agent-panel-review, goal-runner, trigger-indexer

**Tier 2 - Cognitive modes (7):**
parallel-lens-synthesis, consequence-simulation, cross-domain-translation,
convergence-detection, detached-judgment, simulation-to-action-bridge,
nod-protocol

**Tier 2 - Analytical capabilities (5):**
ultra-think, pressure-test, code-audit, autoresearch, skill-creator

**Tier 2 - Domain capabilities (2):**
viz, stakeholder-mapping

## Shells available (Tier 3)

For deliverables, pick a shell from `tier-3-shells/`:
slide-shell, scroll-shell, mission-control, course-shell.
Each ships with the relevant interactivity already wired.

## To activate routing

Load `tier-1-global/skills-core/request-router/SKILL.md`.
The router auto-selects the right skill based on what the user is asking for.
