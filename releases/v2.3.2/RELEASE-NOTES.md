# Compound AI Operating Standards v2.3.2

Release date: 2026-05-14

Canonical URL: `https://cameronsutcliff.com/compound-ai`

Source repo: `https://github.com/cameronpsutcliff/compound-ai-operating-standards`

## What ships

1. `compound-ai-starter-kit-v2.3.2.zip`
2. `RELEASE-NOTES.md`
3. `SHA256SUMS`

## What's new in v2.3.2

A discipline patch in direct response to Codex's cross-feedback critique of v2.3.1. The critique surfaced five real issues; v2.3.2 fixes all of them.

### Fix: SKILL.md files back under the line-count budget

The kit ships claiming every `SKILL.md` is a pointer file under 80 lines. v2.3.1 violated this:

| File | v2.3.1 lines | v2.3.2 lines |
|---|---:|---:|
| `request-router/SKILL.md` | 231 | 98 |
| `agent-panel-review/SKILL.md` | 111 | 66 |
| `agent-panel-planning/SKILL.md` | 100 | 55 |
| `stakeholder-mapping/SKILL.md` | 88 | 44 |

The router prose was split into three reference files:
- `reference/compound-requests.md` -- skill chain recipes
- `reference/panel-offer-threshold.md` -- expanded 5-criteria detail, offer template, soft-offer pattern
- `reference/router-rationale.md` -- why three modes, why judgment beats phrase-list

The panel skills' SKILL.md files compressed by pushing per-stage detail into existing `reference/protocol.md` files (already present, just better used).

The stakeholder-mapping skill's six-step procedure moved into a new `reference/protocol.md`.

The kit now practices the token optimization discipline it teaches.

### Fix: ZIP includes historical release notes

v2.3.1's ZIP build deleted `releases/v2.1.0|v2.2.0|v2.3.0/RELEASE-NOTES.md` before zipping. The manifest expected those files. Result: clean extract + `scripts/verify-integrity.py` returned `MODIFIED`.

v2.3.2's ZIP build retains the release notes history. Clean extract now passes integrity verification.

### Fix: Versioned manifests

The website's `public/compound-ai/manifest.json` was still v1.0.0 in v2.3.1, so `scripts/verify-origin.py --online` would have returned FORKED. v2.3.2 implements versioned manifests:

- `public/compound-ai/manifest.json` -- latest stable, kept synchronized with the most recent release
- `public/compound-ai/releases/v2.3.2/manifest.json` -- immutable per-release verification anchor

Both have the same shape; the latest pointer moves on each release while the per-release manifest stays frozen.

### Fix: Scorecard requires verification preface

A scorecard could praise "Package design" while the package fails on clean extract. v2.3.2 adds a required opening line to the scorecard rubric:

```
Verification performed: [yes/no, commands run, result]
```

If verification was skipped, dimensions 4 (Portability) and 5 (Package design) cap at 75 regardless of apparent quality. Operators cannot score above 75 on dimensions that have not been observed in action.

### Fix: Website version labels

- Field guide reader UI badge was hardcoded "v1.0.0". Now reads from the version constant.
- `releaseUrl` constant pointed at the v1.0.0 GitHub release. Now points at v2.3.2.
- `SHA256SUMS` now covers the field guide markdown in addition to the ZIPs.

## Compatibility

v2.3.1 installations remain functionally valid. The new constraints are additive:
- SKILL.md trims are non-breaking (same skill behavior, less prose)
- Scorecard verification preface is new but optional in legacy scorecards
- Versioned manifests are additive (the latest-pointer manifest stays at the same path)

## Provenance

Every file ships with a SHA256 hash in `compound-ai.sha256`. v2.3.2 is the first release where clean extract + `verify-integrity.py` returns VERIFIED out of the box. Online verification: `./scripts/verify-origin.py --online` returns VERIFIED against the public manifest.

## Recognition

This release exists because Codex flagged the discipline gap. The kit's own panel-review pattern produced its own correction. See the v2.3.1 cross-feedback artifacts in the project's cross-feedback working folder.

## License

- Documentation: CC BY 4.0
- Code: Apache 2.0
- Origin: Compound AI Operating Standards by Cameron Sutcliff
