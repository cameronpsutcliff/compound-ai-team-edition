# Compound AI Operating Standards v2.2.0

Release date: 2026-05-13

Canonical URL: `https://cameronsutcliff.com/compound-ai`

Source repo: `https://github.com/cameronpsutcliff/compound-ai-operating-standards`

## What ships

This release includes:

1. `compound-ai-starter-kit-v2.2.0.zip`
2. `RELEASE-NOTES.md`
3. `SHA256SUMS`

## What's new in v2.2.0

This is a minor-version patch on top of v2.1.0. It addresses a real gap that surfaced after v2.1.0 shipped: the kit had a panel-review pattern for evaluating finished drafts, but no panel pattern for **upstream plan convergence**. Most multi-agent council patterns start with a plan that already exists. The pattern that actually produced the kit started one step earlier: the agents converged on the plan itself.

### New skill: `agent-panel-planning` (Tier 1)

The upstream sibling of `agent-panel-review`. Six-stage protocol:

1. **Frame.** One prompt to all panelists. Each agent must frame the WHOLE problem, not a slice.
2. **Independent plans (sealed).** Complete plan from each agent with no visibility into the others. Must include spine, owners (proposed), dependencies, open questions.
3. **Cross-feedback with element-level voting.** Four-cell critique per other plan plus votes on specific decision points (with one-line reasoning per vote).
4. **Concession + private revise + cross-suggestions for other agents (sealed).** This is the load-bearing stage. Each agent (a) names what is conceded and to which other agent on what dimension, (b) revises its own plan, and (c) proposes specific path-forward adjustments for each OTHER agent's plan. The third output is what makes the panel collaborative rather than competitive.
5. **Reconvene.** No seal. Each agent reads the others' revised plans plus the cross-suggestions for them, accepts or rejects each suggestion with one-line reasoning, and adjusts position.
6. **Voting + ratification + strength-matched task split.** Operator surfaces remaining contested decisions, all panelists vote (with reasoning), operator decides. Task assignment is empirical, not categorical: tasks go to whoever demonstrated dominant capability on that dimension in this round.

Ships with eight files: `SKILL.md` + seven reference files (`protocol.md`, `cross-feedback-template.md`, `concession-discipline.md`, `voting-format.md`, `task-assignment.md`, `escalation-discipline.md`, `when-to-convene.md`, `worked-example.md`).

### New router behavior: Panel Offer Triggers

The `request-router` now has TWO modes:

1. **Routing table** (existing). Pattern match → invoke skill silently.
2. **Panel Offer Triggers** (new). Operator humility signals → agent OFFERS a panel, does NOT auto-invoke.

Operator humility signals include: "I'm not sure", "what's the right approach", "want a second opinion", "high-stakes", "irreversible", "I have a draft plan but want to test it", "is my plan right". When matched, the agent responds with a panel-offer template asking the operator if they want to convene a planning or review panel. Operator opts in (then skill invokes) or declines (then proceeds solo).

This is the operator's humility (asking for wider input) wired into the kit as a default behavior, not a manual gesture.

### Field guide: Chapter 31 split

The single Chapter 31 from v2.1.0 ("The Agent Panel Review Pattern") is now split into two chapters:

- **Chapter 31: The Agent Panel Planning Pattern.** Seven sub-sections covering when to convene a planning panel, independent plans, cross-feedback with element-level voting, the collaborative revise (concession + plan revision + path-forward for others), reconvene and ratification, strength-matched task assignment, and execution with operator-in-the-loop escalation.
- **Chapter 32: The Agent Panel Review Pattern.** The v2.1.0 content, renumbered. Sub-sections 32.1 through 32.5 cover the review-specific protocol.
- **Chapter 33: Before and After.** The original Chapter 31, renumbered.

Internal cross-references and TOC updated accordingly.

## Skill count

| Tier | v2.1.0 | v2.2.0 | Delta |
|---|---|---|---|
| Tier 1 (session infrastructure) | 8 | 9 | +1 (agent-panel-planning) |
| Tier 2 (cognitive modes) | 7 | 7 | 0 |
| Tier 2 (analytical capabilities) | 5 | 5 | 0 |
| Tier 2 (domain capabilities) | 2 | 2 | 0 |
| **Total** | **20** | **21** | **+1** |

## Compatibility

v2.1.0 installations remain valid. The new skill is additive. The router's new Panel Offer Triggers section is additive (existing routing table behavior unchanged). The field guide chapter renumber only affects Ch 31 → 32 → 33; Chapters 1-30 are unchanged.

## Provenance

Every file ships with a SHA256 hash in `compound-ai.sha256`. Verify your local copy matches the canonical release with `./scripts/verify-origin.py --online`.

## License

- Documentation: CC BY 4.0
- Code: Apache 2.0
- Origin: Compound AI Operating Standards by Cameron Sutcliff
