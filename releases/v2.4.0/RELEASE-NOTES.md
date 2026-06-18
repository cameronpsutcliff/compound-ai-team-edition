# Compound AI Operating Standards v2.4.0

Release date: 2026-05-14

Canonical URL: `https://cameronsutcliff.com/compound-ai`

Source repo: `https://github.com/cameronpsutcliff/compound-ai-operating-standards`

## What ships

1. `compound-ai-starter-kit-v2.4.0.zip`
2. `RELEASE-NOTES.md`
3. `SHA256SUMS`

## What's new in v2.4.0

A minor version bump that adds the **release-captain** skill: the ten-step ship gate. v2.3.1 shipped with five public failures (ZIP fails verify-integrity, public manifest stale, hardcoded v1.0.0 badge, oversized SKILL.md files, stale releaseUrl). v2.3.2 fixed them. v2.4.0 makes that class of failure mechanically catchable on every future release.

### New skill: `release-captain` (Tier 1)

Four files: `SKILL.md` (68 lines) + four reference files:

- `reference/checklist.md` -- the ten steps in full with pass/fail criteria and remediation notes per step
- `reference/verification-protocol.md` -- exact bash commands per step; runnable by operator or agent
- `reference/output-template.md` -- structured SHIP/BLOCK report format with synthetic worked examples (including a retrospective BLOCK report on what v2.3.1's ship gate would have surfaced)
- `reference/origin.md` -- pattern lineage; credits Codex's v2.3.1 cross-feedback critique that surfaced the need

The ten-step gate:

1. Clean unzip into /tmp
2. Run `scripts/verify-integrity.py`
3. Run `scripts/verify-origin.py --online`
4. Confirm manifest version matches page version (bundled, public, hero badge)
5. Confirm SHA256SUMS covers current assets
6. Confirm field guide UI badge matches markdown version
7. Confirm release-notes link points to the current release
8. Confirm every public download returns 200
9. Confirm `SKILL.md` files within line-count budget
10. Screenshot the website and field guide

Each step has a pass/fail criterion. Any failure blocks the ship; no overrides. Final output: structured SHIP / BLOCK report with evidence per step.

### Router updates

New fast-path trigger row for `release-captain` ("ship gate", "release captain", "is this ready to ship", "pre-release check", "verify the release") routes auto-invocation.

New compound-request entry: "Pre-ship release verification" runs `release-captain`; pair with `agent-panel-review` upstream if the deliverable also warrants editorial review.

### Dogfood

v2.4.0 itself was the first release validated through the ten-step gate before shipping. The gate report is in the release commit.

## Skill count

| Tier | v2.3.2 | v2.4.0 | Delta |
|---|---|---|---|
| Tier 1 (session infrastructure) | 9 | 10 | +1 (release-captain) |
| Tier 2 (cognitive modes) | 7 | 7 | 0 |
| Tier 2 (analytical capabilities) | 5 | 5 | 0 |
| Tier 2 (domain capabilities) | 2 | 2 | 0 |
| **Total** | **21** | **22** | **+1** |

## Compatibility

v2.3.2 installations remain valid. The new skill is additive. The router's new trigger row is additive (existing routing table behavior unchanged). The compound-requests update is documentation only.

## The pattern

The original release worked because three agents ran a sealed-independent-pass protocol without naming it. v2.1.0 named it (review). v2.2.0 named the upstream version (planning). v2.3.x deepened operability and fixed the discipline gaps Codex's panel review surfaced. **v2.4.0 closes the loop**: the kit's own panel-review pattern produced its own correction, and that correction is now a reusable skill.

The kit ships its own metabolism. Adam Federman's NOD critique (v2.0 → v2.1), the operator scorecard recognition (v2.3.0 → v2.3.1), and Codex's discipline critique (v2.3.1 → v2.3.2 → v2.4.0) all produced kit-level improvements through the patterns the kit teaches.

## Provenance

Every file ships with a SHA256 hash in `compound-ai.sha256`. v2.4.0 passes its own ten-step ship gate; the gate report is in this release directory.

## License

- Documentation: CC BY 4.0
- Code: Apache 2.0
- Origin: Compound AI Operating Standards by Cameron Sutcliff
