# Compound AI Operating Standards v2.3.0

Release date: 2026-05-13

Canonical URL: `https://cameronsutcliff.com/compound-ai`

Source repo: `https://github.com/cameronpsutcliff/compound-ai-operating-standards`

## What ships

This release includes:

1. `compound-ai-starter-kit-v2.3.0.zip`
2. `RELEASE-NOTES.md`
3. `SHA256SUMS`

## What's new in v2.3.0

This is a minor-version patch on top of v2.2.0. It addresses real gaps surfaced during cross-kit review:

### Refined router: 5-criteria panel-offer judgment

The Panel Offer Triggers section in `request-router/SKILL.md` was rewritten from phrase-list pattern matching to **agent-judgment against five explicit criteria**. The phrase list was too eager: it would offer a panel on "what do you think?" which is normal collaborative dialogue, not council-tier intent.

The new criteria require the operator to explicitly invite another model, describe stuck-state ("I keep going back and forth"), signal "don't want to decide alone" on a high-stakes decision, use explicit panel/council words, or hold a complete draft plan and want it tested against alternatives.

The soft-offer pattern lets the agent mention the panel as available at the end of a normal response without derailing the conversation. The fast-path (explicit "convene a panel") still auto-invokes.

### Merge framework for `agent-panel-review` Stage 5

A new `reference/merge-framework.md` adds the missing execution guidance for "the merge takes the strongest layer from each, not an average." Per-dimension scoring procedure with three sources of signal (Stage 3 strongest-claim cells, Stage 4 concession lines, one-thing-to-steal cells), plus an explicit operator-bias check (two questions before locking each dimension) to prevent the operator's instinct from masquerading as panel signal.

### Loop-4 recovery framework

A new `reference/loop-4-recovery.md` covers the failure mode where a panel reaches its fourth loop without converging. Five common causes (too-broad question, hidden assumption, wrong panel composition, scope creep, panelist fatigue) with a specific recovery move per cause. The "ship the imperfect" rule protects against sunk-cost panic. Applies to both panel-review and panel-planning.

### Standing-vs-convened panel framing

`agent-panel-planning/reference/when-to-convene.md` gains a sub-section on standing panels (a permanent multi-agent operating structure with refined roles) vs convened panels (per-deliverable assembly). The standing-panel model is stronger if you can sustain the discipline; convened is the right default for episodic high-stakes deliverables. This trade-off was surfaced during cross-kit review by Adam Federman, credited via the citation registry.

### `INSTALL.md` with multi-agent setup pitch

A new top-level `INSTALL.md` walks new operators through the key decision: do you have access to multiple AI agents? If yes, the panel skills light up. If not, the file pitches free-tier setups (Claude/GPT/Gemini free tiers, Aider+Ollama for local, same-model panels in different roles) so single-agent operators can form a panel without paid frontier subscriptions.

### `_citations.md` registry + field guide reader tooltip support

A new top-level `_citations.md` is the canonical attribution registry. Each entry has a key, display name, one-line "what they contributed," and optional link.

The field guide reader (`https://cameronsutcliff.com/compound-ai/field-guide`) now resolves citation markers (`[^key]`) in the markdown to numbered superscript tooltips. Hover reveals Name + Contribution. The first citation marker landed in `agent-panel-planning/reference/when-to-convene.md` crediting Adam Federman for the standing-panel observation.

### Field guide foreword: audience callout

Added a brief "Who this manual is for / who it is not for" section at the end of the foreword. Practitioners moving from prompt-as-code to operating-standards, indie operators, engineers handed a kit, future agents inheriting work.

## Skill count

| Tier | v2.2.0 | v2.3.0 | Delta |
|---|---|---|---|
| Tier 1 (session infrastructure) | 9 | 9 | 0 |
| Tier 2 (cognitive modes) | 7 | 7 | 0 |
| Tier 2 (analytical capabilities) | 5 | 5 | 0 |
| Tier 2 (domain capabilities) | 2 | 2 | 0 |
| **Total** | **21** | **21** | **0** |

v2.3.0 holds the skill count steady at 21. The work is deepening operability of existing skills, not adding new ones.

## Compatibility

v2.2.0 installations remain valid. The router refinement is functionally additive (the criteria evaluator is more selective, not more eager). The new reference files in `agent-panel-review` are additive. `INSTALL.md` and `_citations.md` are new top-level files that do not affect existing skills.

## Provenance

Every file ships with a SHA256 hash in `compound-ai.sha256`. Verify your local copy matches the canonical release with `./scripts/verify-origin.py --online`.

## License

- Documentation: CC BY 4.0
- Code: Apache 2.0
- Origin: Compound AI Operating Standards by Cameron Sutcliff
