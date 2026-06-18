# Compound AI Operating Standards v2.5.0

Release date: 2026-05-14

Canonical URL: `https://cameronsutcliff.com/compound-ai`

Source repo: `https://github.com/cameronpsutcliff/compound-ai-operating-standards`

## What ships

1. `compound-ai-starter-kit-v2.5.0.zip`
2. `RELEASE-NOTES.md`
3. `SHA256SUMS`

## What's new in v2.5.0

The inbound metabolic loop closes. v2.4.0 added `release-captain` for the outbound case (shipping releases safely). v2.5.0 adds `adoption-captain` for the inbound case: safely adopting the kit into an existing project, with the host stack preserved and the host agent's instruction surfaces durably updated so future sessions inherit the kit's techniques without re-discovery.

### New skill: `adoption-captain` (Tier 1)

Nine files: `SKILL.md` (63 lines, pointer) + eight reference files:

- `reference/discovery-checklist.md` (Stage 1) -- what to read when entering a host project
- `reference/preserve-map.md` (Stage 2) -- Preserve / Add / Modify / Defer / Conflict classification table
- `reference/mapping-rubric.md` (Stage 4) -- per-skill classification logic for all 23 kit skills
- `reference/adoption-plan-template.md` (Stage 5) -- the phased plan format the operator approves before any edits
- `reference/non-breaking-rules.md` (Stage 6) -- protected file list, default `.compound-ai/` placement, rollback procedure
- `reference/validation-protocol.md` (Stage 7) -- per-stack test/build/lint/typecheck commands and PASS/FAIL/NOT-FOUND handling
- `reference/adoption-report-template.md` (Stage 8a) -- the structured adoption report
- `reference/memory-commit-protocol.md` (Stage 8b) -- the marker-bounded instruction-surface updates to CLAUDE.md / AGENT.md / AGENTS.md / .cursorrules so future sessions inherit kit awareness

### The eight stages

1. **Discover host context.** Read existing CLAUDE.md / AGENT.md / AGENTS.md / .cursorrules / CONVENTIONS.md, detect stack via package files, identify test/build/lint commands, read state/decision logs.
2. **Preserve host rules.** Build the Preserve / Add / Modify / Defer / Conflict map. Existing project rules win by default.
3. **Inventory kit surface.** List skills, shells, scripts, hooks, references. Do NOT load the full Field Guide.
4. **Map kit to stack.** Classify each skill: adopt now / adapt / defer / skip / conflict. One-line rationale per classification.
5. **Propose phased plan.** Phase 1 = additive scaffolding only. Phase 2+ = behavior changes, operator-gated.
6. **Apply additively.** Default placement `.compound-ai/`. Never overwrite host files without explicit per-file approval.
7. **Validate non-breakage.** Run host project's own test, build, lint, typecheck commands. Report PASS / FAIL / NOT-FOUND honestly.
8. **Document and commit to memory.** Write `.compound-ai/adoption-report.md`. **Update host agent's instruction surfaces** with bounded `## Compound AI Operating Standards` sections (markers: `<!-- compound-ai:start v2.5.0 -->` ... `<!-- compound-ai:end -->`) listing adopted skills, triggers, preserve rules, validation commands. Operator approves each surface. Global surfaces require a separate explicit confirmation.

### The memory-commit discipline

Stage 8b is the load-bearing extension that distinguishes this skill from a one-shot installer. The adoption is incomplete until the host agent's persistent instruction surfaces have been updated, because every session after the install reads those files at startup. Without commit-to-memory, every session starts adoption from zero. With it, the kit's techniques become part of the agent's default operating context.

Updates are:
- **Marker-bounded** so they can be found, upgraded on future kit versions, or rolled back
- **Project-tailored** from the mapping rubric (only adopted skills appear, not the full registry)
- **Operator-gated per surface** with separate explicit confirmation for global surfaces (`~/.claude/CLAUDE.md`, `~/.codex/AGENTS.md`)
- **Idempotent** (re-running adoption-captain with the same kit version detects existing sections and skips; an upgrade replaces them rather than duplicating)
- **Reversible** (delete everything between the markers to fully roll back)

### New top-level `ADOPT.md`

Entry point for adopting the kit into existing projects. Companion to `HANDOFF.md` (new-project flow). Contains the drop-in prompt for adopting agents, the eight-stage protocol description, default placement rules, and rollback instructions.

### HANDOFF.md forks new vs existing

Explicit fork at the top of `HANDOFF.md`: "if this is a new project, use this file + engagement-bootstrap; if this is an existing project, switch to ADOPT.md + adoption-captain." The fork ensures fresh agents do not run new-project bootstrap on an established codebase.

### Router updates

New fast-path trigger row for `adoption-captain`: "adopt this kit", "install into my current repo", "optimize this existing agent", "use these techniques going forward", "reconfigure my agents", "take this tech stack and implement the kit", "do not break my stack", "migrate my agent instructions".

New "Two-mode bootstrap distinction" section disambiguates new-project (`engagement-bootstrap`) vs existing-project (`adoption-captain`) entry points.

### Codex polish from v2.4.0 critique

Codex's v2.4.0 cross-feedback flagged several stale-content items. All addressed:

- `INSTALL.md` was stuck at v2.3.0 header → updated to v2.5.0
- `INSTALL.md` "18 of 21 skills" → updated to "19 of 23 skills"
- `README.md` had two stale "18 skills" references → both updated to 23
- `AGENT.md` "Tier 2 has 12 skills" while categories listed 14 → fixed to "Tier 2 has 14 skills (7 cognitive + 5 analytical + 2 domain)"
- Site/kit "pointer skills under 80 lines" → reworded to "under 100 lines, target 80" matching the actual budget enforced by `release-captain` Step 9

### Dogfood

Codex's acceptance criterion: "Run one dry adoption against a real mature project, preferably your own website repo, and ship the adoption report as proof."

Done. The eight-stage protocol was dry-run against a real mature project during this release.

## Skill count

| Tier | v2.4.0 | v2.5.0 | Delta |
|---|---|---|---|
| Tier 1 (session infrastructure) | 10 | 11 | +1 (adoption-captain) |
| Tier 2 (cognitive modes) | 7 | 7 | 0 |
| Tier 2 (analytical capabilities) | 5 | 5 | 0 |
| Tier 2 (domain capabilities) | 2 | 2 | 0 |
| **Total** | **22** | **23** | **+1** |

## Compatibility

v2.4.0 installations remain valid. `adoption-captain` is additive. ADOPT.md is a new file. HANDOFF.md fork is additive (new content at the top; existing prompt below). The router's new trigger row is additive.

For users who already adopted v2.4.0 into an existing project: v2.5.0 introduces the canonical adoption protocol. Running `adoption-captain` on a project that previously got an ad-hoc adoption will detect the existing kit at `.compound-ai/` and offer to migrate to the structured protocol. Marker conventions only apply to additions by `adoption-captain` going forward; existing operator-authored kit references in instruction files are left alone unless the operator opts to convert them.

## The metabolic loop is now complete

| Loop | Skill | What it does |
|---|---|---|
| Outbound (kit ships itself) | `release-captain` | Ten-step ship gate before publishing any kit release |
| Inbound (kit enters a project) | `adoption-captain` | Eight-stage protocol for safe adoption into existing projects |
| New-project bootstrap | `engagement-bootstrap` | Creates kit-native scaffolding for fresh projects |
| Daily routing | `request-router` | Dispatches requests to the right skill |
| Quality gating | `quality-gate` | Validates output before ship |
| Pattern promotion | `pattern-promoter` | Promotes proven patterns to the shared layer |

The kit can now be safely handed to any reasonably capable agent on any reasonably-shaped project, new or existing, and the discipline is operationalized end-to-end.

## Provenance

Every file ships with a SHA256 hash in `compound-ai.sha256`. v2.5.0 passes its own `release-captain` ship gate. The dry-run adoption report (`releases/v2.5.0/dry-run-adoption-report.md`) demonstrates `adoption-captain` works against a real mature project.

## License

- Documentation: CC BY 4.0
- Code: Apache 2.0
- Origin: Compound AI Operating Standards by Cameron Sutcliff

## Recognition

This release exists because Codex's v2.3.1 cross-feedback identified the outbound discipline gap (v2.4.0 fixed it), the inbound adoption question was raised (this analysis became this release), and Codex's v2.5.0 prescription tightened the scope into an implementable eight-stage protocol. The memory-commit extension (Stage 8b) was added: adoption is not complete until the host agent's persistent operating memory has been updated to use the kit in future sessions, not just this one.
