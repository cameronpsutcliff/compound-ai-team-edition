# Compound AI Operating Standards v2.3.1

Release date: 2026-05-13

Canonical URL: `https://cameronsutcliff.com/compound-ai`

Source repo: `https://github.com/cameronpsutcliff/compound-ai-operating-standards`

## What ships

This release includes:

1. `compound-ai-starter-kit-v2.3.1.zip`
2. `RELEASE-NOTES.md`
3. `SHA256SUMS`

## What's new in v2.3.1

A patch on v2.3.0 adding one substantive piece: the **scorecard rubric** for `agent-panel-review`. Heavier quantitative alternative to the four-cell critique template, used to evaluate an agent's strategy plan against an operator's drafts.

### New: `agent-panel-review/reference/scorecard-rubric.md`

Ten-dimension evaluation rubric with:

- **0-100 score per dimension** with one-line evidence note citing specific sections or lines of the artifact under review
- **Composite score** (mean of the 10 dimensions)
- **Dual grade** for strategy quality vs artifact production quality (captures the asymmetry where some outputs are A- on strategy and C+ on production)
- **"What this excels at" + "What this misses"** prose summary

The ten dimensions:

1. **Thesis sharpness** — Is the core claim quotable and load-bearing?
2. **Audience layering** — Does the artifact serve its target audience(s)?
3. **Substance density** — Coverage AND concreteness. Patterns named AND demonstrated.
4. **Portability / vendor-neutrality** — Works across platforms; substitution tables for vendor-specific references.
5. **Package design** — Folder structure, download structure, manifest discipline.
6. **Reference artifact / immediate utility** — Can a reader leave with something to deploy?
7. **Audience signaling** — Domain-appropriate language and framing for the specific intended audience.
8. **Discipline** — Length, deduplication, no restatement masquerading as content.
9. **Originality (signature contributions)** — What is novel here that no other source has?
10. **Critique-readiness** — Does the author anticipate critique and name gaps?

### When to use scorecard vs four-cell

| Situation | Use |
|---|---|
| Fast panel critique, qualitative signal sufficient | four-cell template |
| Heavy panel critique, quantitative comparison helps | scorecard |
| Operator scoring own draft for self-check | scorecard |
| Operator scoring single agent's output | scorecard |
| Time-pressured review where structure must be light | four-cell |
| Post-mortem on shipped artifact | scorecard |

Pick one format per panel loop. Mixing within a single loop produces inconsistent signal across panelists. The two are interchangeable on a per-loop basis; a panel can use four-cell at Stage 3 in Loop 1 and switch to scorecard in Loop 2 if rigor needs to step up.

### Pattern lineage

The scorecard format originated in cross-feedback during an earlier build: an operator and an agent session used it to evaluate a strategy plan with citation-grounded scoring across ten dimensions. v2.3.1 promotes it into the kit as a canonical option, with one substitution: the original rubric included a target-employer signaling dimension; the kit ships with **audience signaling** as the generic version, which applies to any target audience.

## Skill count

| Tier | v2.3.0 | v2.3.1 | Delta |
|---|---|---|---|
| Tier 1 (session infrastructure) | 9 | 9 | 0 |
| Tier 2 (cognitive modes) | 7 | 7 | 0 |
| Tier 2 (analytical capabilities) | 5 | 5 | 0 |
| Tier 2 (domain capabilities) | 2 | 2 | 0 |
| **Total** | **21** | **21** | **0** |

v2.3.1 is purely additive. No skill count change; the scorecard rubric is a new reference file inside `agent-panel-review/reference/`.

## Compatibility

v2.3.0 installations remain valid. The scorecard rubric is additive (a new reference file); the four-cell template in `critique-format.md` is unchanged and remains the default. Panels currently running the four-cell template continue working without modification.

## Provenance

Every file ships with a SHA256 hash in `compound-ai.sha256`. Verify your local copy matches the canonical release with `./scripts/verify-origin.py --online`.

## License

- Documentation: CC BY 4.0
- Code: Apache 2.0
- Origin: Compound AI Operating Standards by Cameron Sutcliff
