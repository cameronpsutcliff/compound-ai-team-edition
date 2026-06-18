# Compound AI Operating Standards v2.1.0

Release date: 2026-05-13

Canonical URL: `https://cameronsutcliff.com/compound-ai`

Source repo: `https://github.com/cameronpsutcliff/compound-ai-operating-standards`

## What ships

This release includes:

1. `compound-ai-starter-kit-v2.1.0.zip`
2. `RELEASE-NOTES.md`
3. `SHA256SUMS`

## What's new in v2.1.0

This is a minor-version patch on top of v2.0.0. It addresses two gaps surfaced during the v2.0.0 review cycle: the cognitive-mode skills were pointer files that named the move but did not operationalize the work, and the kit had no protocol for structured multi-agent review.

### New skills

1. **`agent-panel-review`** (Tier 1, session infrastructure). The independent-first-pass panel protocol. Six stages: frame, sealed-independent-pass, structured cross-critique, no-ego self-revise, operator-driven merge, loop-or-ship. Ships with seven reference files covering protocol, role templates, critique format, when-to-convene threshold, agent-strength matrix, and a worked example. Triggers: "set up a panel", "convene a panel", "multi-agent review", "second opinion", "independent review".

2. **`nod-protocol`** (Tier 2, cognitive mode). Five-gate opposite-construction with the signing test. Gates: state the position, construct the strongest opposite (signing test enforced), find the shared assumption, specify the falsifier, decide-defer-or-refuse. Fills the adversarial-reasoning gap in v2.0.0 where `detached-judgment` gestured at structured disagreement but had no gate structure. Triggers: "play devil's advocate", "argue the opposite", "construct the opposite case", "NOD this", "steelman the other side".

### Operationalized cognitive modes

All six existing cognitive-mode skills now ship a `reference/protocol.md` file with step-by-step procedure, output template, worked example, anti-patterns specific to that mode, and a "when to skip" section. Affected skills: `parallel-lens-synthesis`, `consequence-simulation`, `cross-domain-translation`, `convergence-detection`, `detached-judgment`, `simulation-to-action-bridge`.

This addresses the v2.0.0 review finding that "the modes are listed but not operationalized." The pointer files remain under 80 lines; the operational depth lives in the new `reference/protocol.md` files, loaded on demand per the kit's pointer-skill rule.

### Router updates

The `request-router` ships new trigger rows for both new skills, plus two new compound-request entries:

- **Hard decision under uncertainty:** `parallel-lens-synthesis`, then `nod-protocol` on the synthesis, then `simulation-to-action-bridge`
- **High-stakes deliverable:** `agent-panel-review` drives the loop; `nod-protocol` is invoked on disagreements

### Field guide

One new chapter: **Chapter 31. The Agent Panel Review Pattern.** Five staged sub-chapters covering when to convene, role assignment without ego, the sealed independent pass, structured critique, and the no-ego revise. Original Chapter 31 ("Before and After") renumbered to Chapter 32.

## Skill count

| Tier | v2.0.0 | v2.1.0 | Delta |
|---|---|---|---|
| Tier 1 (session infrastructure) | 7 | 8 | +1 (agent-panel-review) |
| Tier 2 (cognitive modes) | 6 | 7 | +1 (nod-protocol) |
| Tier 2 (analytical capabilities) | 5 | 5 | 0 |
| Tier 2 (domain capabilities) | 2 | 2 | 0 |
| **Total** | **20** | **20** | **+2** |

## Compatibility

v2.0.0 installations remain valid. The two new skills are additive. Cognitive mode pointer skills are unchanged; the new reference/protocol.md files load only when the skill explicitly requests them.

## Provenance

Every file ships with a SHA256 hash in `compound-ai.sha256`. Verify your local copy matches the canonical release with `./scripts/verify-origin.py --online`.

## License

- Documentation: CC BY 4.0
- Code: Apache 2.0
- Origin: Compound AI Operating Standards by Cameron Sutcliff
