# Skills Index
# Compound AI Operating Standards v2.7.0
# Source: cameronsutcliff.com/compound-ai | License: Apache 2.0

Load at session start. This is the human-readable capability registry. The
machine-readable routing surface is
`tier-1-global/conventions/trigger-registry.yaml`.

Total skills: **28**.

---

## Tier 1: Session Infrastructure (13)

These run the session. `request-router` consults the trigger registry.

| Skill | Trigger | Pointer |
|---|---|---|
| request-router | session start, routing | `tier-1-global/skills-core/request-router/SKILL.md` |
| goal-runner | "goal", "completion condition", "keep going until", "finish all", "/goal" | `tier-1-global/skills-core/goal-runner/SKILL.md` |
| trigger-indexer | "reindex triggers", "rebuild trigger registry", "routing is stale" | `tier-1-global/skills-core/trigger-indexer/SKILL.md` |
| context-loader | "load context", "what should I read", "start session" | `tier-1-global/skills-core/context-loader/SKILL.md` |
| token-economist | "token audit", "optimize context", "reduce cost" | `tier-1-global/skills-core/token-economist/SKILL.md` |
| engagement-bootstrap | "new project", "bootstrap this", "set up the project" | `tier-1-global/skills-core/engagement-bootstrap/SKILL.md` |
| quality-gate | "quality check", "validate output", "is this ready", "rendered contract" | `tier-1-global/skills-core/quality-gate/SKILL.md` |
| pattern-promoter | "promote this pattern", "save this lesson" | `tier-1-global/skills-core/pattern-promoter/SKILL.md` |
| provenance-check | "verify origin", "check provenance" | `tier-1-global/skills-core/provenance-check/SKILL.md` |
| agent-panel-planning | "plan this with the panel", "split this work across agents" | `tier-1-global/skills-core/agent-panel-planning/SKILL.md` |
| agent-panel-review | "set up a panel", "multi-agent review", "second opinion" | `tier-1-global/skills-core/agent-panel-review/SKILL.md` |
| release-captain | "ship gate", "release captain", "verify the release" | `tier-1-global/skills-core/release-captain/SKILL.md` |
| adoption-captain | "adopt this kit", "install into my current repo", "do not break my stack" | `tier-1-global/skills-core/adoption-captain/SKILL.md` |

## Tier 2: Cognitive Modes (7)

| Skill | Trigger | Pointer |
|---|---|---|
| parallel-lens-synthesis | "multiple perspectives", "steelman", "red-team" | `tier-2-capabilities/skills/parallel-lens-synthesis/SKILL.md` |
| consequence-simulation | "what could go wrong", "premortem", "simulate" | `tier-2-capabilities/skills/consequence-simulation/SKILL.md` |
| cross-domain-translation | "explain to", "translate for", "exec summary" | `tier-2-capabilities/skills/cross-domain-translation/SKILL.md` |
| convergence-detection | "common thread", "root cause", "what connects these" | `tier-2-capabilities/skills/convergence-detection/SKILL.md` |
| detached-judgment | "devil's advocate", "base rate", "calibrated" | `tier-2-capabilities/skills/detached-judgment/SKILL.md` |
| simulation-to-action-bridge | "what should we do", "next steps", "turn into a plan" | `tier-2-capabilities/skills/simulation-to-action-bridge/SKILL.md` |
| nod-protocol | "argue the opposite", "construct the opposite case", "NOD this" | `tier-2-capabilities/skills/nod-protocol/SKILL.md` |

## Tier 2: Analytical Capabilities (5)

| Skill | Trigger | Pointer |
|---|---|---|
| ultra-think | "think deeply", "multi-angle", "ultra think" | `tier-2-capabilities/skills/ultra-think/SKILL.md` |
| pressure-test | "pressure test", "critique this", "rip this apart" | `tier-2-capabilities/skills/pressure-test/SKILL.md` |
| code-audit | "code audit", "dead code", "security review" | `tier-2-capabilities/skills/code-audit/SKILL.md` |
| autoresearch | "research this", "find sources", "investigate" | `tier-2-capabilities/skills/autoresearch/SKILL.md` |
| skill-creator | "build a skill", "create a skill", "extend the kit" | `tier-2-capabilities/skills/skill-creator/SKILL.md` |

## Tier 2: Domain Capabilities (2)

| Skill | Trigger | Pointer |
|---|---|---|
| viz | "viz", "what chart", "dashboard design" | `tier-2-capabilities/skills/viz/SKILL.md` |
| stakeholder-mapping | "stakeholder map", "influence interest" | `tier-2-capabilities/skills/stakeholder-mapping/SKILL.md` |

## Tier 2: Orchestration Capabilities (1)

| Skill | Trigger | Pointer |
|---|---|---|
| loop-engineering | "build a loop", "recurring agent job", "loop spec" | `tier-2-capabilities/skills/loop-engineering/SKILL.md` |

---

## v2.7.0 Changes

- Added `loop-engineering`: the Loop Spec contract, three hard stops,
  closed-loop default, maker/checker verification, memory on disk. No loop
  runs without a spec.
- Added `templates/loop-spec.md`: the fill-in per-loop contract.
- Total active skills: 28.

## v2.6.0 Changes

- Added `goal-runner`: durable goal contract, validation loop, slow lanes,
  selector/repair symmetry, rendered contract checks, and memory closeout.
- Added `trigger-indexer`: maintains the machine-readable trigger registry.
- Added `trigger-registry.yaml`: the router's canonical trigger surface.
- Updated `request-router` to use the registry instead of hardcoded prose.
- Updated `adoption-captain` memory commit to install a behavioral overlay.
- Corrected count drift from the v2.5.0 package: repo has 27 active skills.
- Standardized pointer budget language: under 100 lines, target 80.

Historical release notes live in `releases/`.

## Pointer Skill Rule

Every active `SKILL.md` stays under 100 lines, target 80. Deep references live
in `reference/` and load on demand. Skills are tools, not documentation.
